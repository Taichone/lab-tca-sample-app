import ComposableArchitecture
import SwiftUI

struct RootView: View {
    var body: some View {
        CounterView(
          store: .init(
            initialState: Counter.State()
          ) {
            Counter()
          }
        )
    }
}

#Preview {
    RootView()
}
