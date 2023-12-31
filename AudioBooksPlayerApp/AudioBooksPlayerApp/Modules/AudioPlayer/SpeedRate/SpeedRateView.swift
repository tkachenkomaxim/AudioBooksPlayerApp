//
//  SpeedRateView.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 23.10.2023.
//

import SwiftUI

// MARK: - Constants

private enum Constants {
    
    enum Sizes {
        static let padding: CGFloat = 10
    }
}

// MARK: - View

struct SpeedRateView: View {
    let title: String
    let onButtonTapped: () -> Void

    var body: some View {
        Button(action: onButtonTapped) {
            Text(title)
                .padding(Constants.Sizes.padding)
                .background(Color.speedBtnBackground)
                .cornerRadius(CGFloat.cornerRadius)
                .font(.speedTitle)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    SpeedRateView(title: "Speed x1",
                  onButtonTapped: { })
}
