import SwiftUI

struct MessageListView: View {
    @State var isShowingAlert = false
    @State var messages = [String]()
    let messageProvider: MessageProvider

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(self.messages, id: \.self) { message in
                        Text(message)
                    }
                }
                Button(action: {
                    Task {
                        await self.onTapUpdateButtonTapped()
                    }
                }) {
                    UpdateButtonLabel()
                }
            }
            .alert("Failed to fetch messages", isPresented: self.$isShowingAlert) {
                Button("OK") {
                    self.isShowingAlert = false
                }
            } message: {
                Text("")
            }
            .navigationTitle("メッセージ一覧")
        }
    }

    func onTapUpdateButtonTapped() async {
        do {
            try await self.messages = self.messageProvider.fetchMessages()
        } catch {
            self.isShowingAlert = true
        }
    }
}

#Preview {
    MessageListView(messageProvider: MessageAPIClient.shared)
}

// MARK: DI 可能にするために protocol で抽象化
protocol MessageProvider {
    func fetchMessages() async throws -> [String]
}
