import ComposableArchitecture
import SwiftUI

@Reducer
struct Counter {
    @ObservableState
    struct State: Equatable {
        var count = 0
    }
    
    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                return .none
            case .incrementButtonTapped:
                state.count += 1
                return .none
            }
        }
    }
}

struct CounterView: View {
    let store: StoreOf<Counter>
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("\(self.store.count)")
                .bold()
                .font(.system(size: 50))
            
            Spacer()
            
            HStack {
                LabeledRectangle(type: .minus)
                    .onTapGesture { self.store.send(.decrementButtonTapped) }
                
                LabeledRectangle(type: .plus)
                    .onTapGesture { self.store.send(.incrementButtonTapped) }
            }
            .scaledToFit()
            .padding()
        }
    }
}

struct LabeledRectangle: View {
    private let image: Image
    private let rectangleColor: Color
    
    init(type: Self.LabelType) {
        switch type {
        case .minus:
            self.image = Image(systemName: "minus")
            self.rectangleColor = .pink
        case .plus:
            self.image = Image(systemName: "plus")
            self.rectangleColor = .cyan
        }
        
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(self.rectangleColor)
            self.image
                .resizable()
                .scaledToFit()
                .padding(30)
        }
        .padding()
        .shadow(radius: 10)
    }
    
    enum LabelType {
        case plus
        case minus
    }
}

#Preview {
    NavigationStack {
        CounterView(
            store: Store(initialState: Counter.State()) {
                Counter()
            }
        )
    }
}
