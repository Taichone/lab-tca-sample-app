import ComposableArchitecture
import SwiftUI

@Reducer
struct MessageList {
    @ObservableState
    struct State: Equatable {
        var messages = [String]()
        var isShowingAlert = false
        @Presents var destination: Destination.State?  // Tree-based navigation
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case closeAlertButtonTapped
        case fetchMessageButtonTapped
        case fetchMessagesResponse(Result<[String], Error>) // メッセージの fetch 結果
        case destination(PresentationAction<Destination.Action>)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .fetchMessageButtonTapped:
                return self.fetchMessages()

            case .closeAlertButtonTapped:
                state.isShowingAlert = false
                return .none

            case let .fetchMessagesResponse(result):
                switch result {
                case let .success(response):
                    print("fetch result is \(response)")
                    state.messages = response
                case .failure:
                    print("fetch error")
                    state.isShowingAlert = true
                }
                return .none

            case .destination:
                return .none

            case .binding:
                return .none
            }
        }
    }

    // Effect を返すメソッド
    func fetchMessages() -> Effect<Action> {
        .run { send in
            await send(
                .fetchMessagesResponse(
                    Result {
                        try await MessageAPIClient.fetchMessages()
                    }
                )
            )
        }
    }
}

extension MessageList {
    @Reducer(state: .equatable)
    public enum Destination {
        case alert(AlertState<Alert>)

        public enum Alert: Equatable {}
    }
}

enum MessageError: Error {
    case fetchError
}

extension AlertState where Action == MessageList.Destination.Alert {
  static let fetchMessagesError = Self {
    TextState("Fetch Messages Error")
  } message: {
    TextState("Failed to fetch messages.")
  }
}

struct MessageListView: View {
    @Bindable var store: StoreOf<MessageList>

    var body: some View {
        VStack {
            List {
                ForEach(self.store.messages, id: \.self) { message in
                    Text(message)
                }
            }
            Button(action: {
                self.store.send(.fetchMessageButtonTapped)
            }) {
                ZStack {
                    Text("最新のメッセージを取得する")
                        .bold()
                        .foregroundStyle(.white)
                        .padding()
                        .background(content: {
                            RoundedRectangle(cornerSize: .init(width: 10, height: 10))
                                .foregroundStyle(.blue)
                                .shadow(radius: 10)
                        })
                }

            }
        }
        .alert("Failed to fetch messages", isPresented: self.$store.isShowingAlert) {
            Button("OK") {
                self.store.send(.closeAlertButtonTapped)
            }
        } message: {
            Text("")
        }
        .navigationTitle("メッセージ一覧")
    }
}

#Preview {
    NavigationStack {
        MessageListView(
            store: Store(initialState: MessageList.State()) {
                MessageList()
            }
        )
    }
}
