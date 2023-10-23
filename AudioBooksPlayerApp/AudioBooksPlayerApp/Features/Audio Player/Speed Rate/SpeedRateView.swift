//
//  SpeedRateView.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 23.10.2023.
//

import SwiftUI

private enum Constants {
    enum Sizes {
        static let padding: CGFloat = 10
    }
}

struct SpeedRateView: View {
    let title: String
    let onButtonTapped: () -> Void

    var body: some View {
        Button(action: onButtonTapped) {
            Text(title)
                .padding(Constants.Sizes.padding)
                .background(Color.speedBtnBackground)
                .cornerRadius(CGFloat.cornerRadius)
                .font(.textSubTitle)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SpeedRateView(title: "Speed 1x",
                  onButtonTapped: { })
}
