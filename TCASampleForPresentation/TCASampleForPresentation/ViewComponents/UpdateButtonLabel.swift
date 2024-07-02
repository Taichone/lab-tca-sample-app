//
//  UpdateButton.swift
//  TCASampleForPresentation
//
//  Created by Taichi on 2024/07/02.
//

import SwiftUI

struct UpdateButtonLabel: View {
    var body: some View {
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

#Preview {
    UpdateButtonLabel()
}
