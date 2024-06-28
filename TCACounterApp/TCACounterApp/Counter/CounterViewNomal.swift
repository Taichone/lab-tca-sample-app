import SwiftUI

struct CounterViewNomal: View {
    @State var count = 0

    var body: some View {
        VStack {
            Spacer()

            Text("\(self.count)")
                .bold()
                .font(.system(size: 50))

            Spacer()

            HStack {
                LabeledRectangle(type: .minus)
                    .onTapGesture { self.count -= 1 }

                LabeledRectangle(type: .plus)
                    .onTapGesture { self.count += 1}
            }
            .scaledToFit()
            .padding()
        }
    }
}

#Preview {
    CounterViewNomal(count: 999)
}
