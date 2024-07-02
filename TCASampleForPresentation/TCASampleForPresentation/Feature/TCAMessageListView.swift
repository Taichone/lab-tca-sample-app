import ComposableArchitecture
import SwiftUI

@Reducer
struct MessageList {
    @ObservableState
    struct State: Equatable {
        var messages = [String]()
        var isShowingAlert = false
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case closeAlertButtonTapped
        case fetchMessageButtonTapped
        case fetchMessagesResponse(Result<[String], Error>) // メッセージの fetch 結果
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
                    state.messages = response
                case .failure:
                    state.isShowingAlert = true
                }
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
                        try await MessageAPIClient.shared.fetchMessages()
                    }
                )
            )
        }
    }
}

struct TCAMessageListView: View {
    @Bindable var store: StoreOf<MessageList>

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(self.store.messages, id: \.self) { message in
                        Text(message)
                    }
                }
                Button(action: {
                    self.store.send(.fetchMessageButtonTapped)
                }) {
                    UpdateButtonLabel()
                }
            }
            .alert("エラー", isPresented: self.$store.isShowingAlert) {
                Button("OK") {
                    self.store.send(.closeAlertButtonTapped)
                }
            } message: {
                Text("メッセージの取得に失敗しました。")
            }
            .navigationTitle("メッセージ一覧")
        }
    }
}

#Preview {
    TCAMessageListView(
        store: Store(initialState: MessageList.State()) {
            MessageList()
        }
    )
}

class MockMessageAPIClientWithError: MessageProvider {
    static let shared = MockMessageAPIClientWithError()

    private init() {}
    func fetchMessages() async throws -> [String] {
        throw MessageError.fetchError
    }
}
