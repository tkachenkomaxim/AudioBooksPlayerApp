//
//  BaseActionButtonView.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//

import SwiftUI

struct BaseActionButtonView: View {
    var icon: String = "play.fill"
    var fontSize: CGFloat = 35
    var color: Color = .black
    var isEnabled: Bool
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: fontSize, height: fontSize)
        }
        .foregroundColor(isEnabled ? .actionEnabledColor : .actionDisabledColor)
        .disabled(!isEnabled)
    }
}
