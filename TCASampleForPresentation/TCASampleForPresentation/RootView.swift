import ComposableArchitecture
import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            TCAMessageListView(
                store: .init(
                    initialState: MessageList.State()
                ) {
                    MessageList()
                }
            )
            .tabItem { Text("TCA") }

            MessageListView(messageProvider: MessageAPIClient.shared)
                .tabItem { Text("SwiftUI") }
        }
    }
}

#Preview {
    RootView()
}
