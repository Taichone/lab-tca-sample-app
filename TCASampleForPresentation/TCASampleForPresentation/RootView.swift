import ComposableArchitecture
import SwiftUI

struct RootView: View {
    var body: some View {
        NavigationStack {
            MessageListView(
              store: .init(
                initialState: MessageList.State()
              ) {
                MessageList()
              }
            )
        }
    }
}

#Preview {
    RootView()
}
