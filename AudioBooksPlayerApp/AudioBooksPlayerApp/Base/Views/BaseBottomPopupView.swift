//
//  SwiftUIView.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 23.10.2023.
//

import SwiftUI

private enum Const {
    static let spacing: CGFloat = 15
    static let stackBottom: CGFloat = 30
}

public struct BaseBottomPopupView: View {
    let title: String
    let subtitle: String
    let buttonTitle: String
    let buttonAction: () -> Void

    public var body: some View {
        GeometryReader { proxy in
            Group {
                ZStack {
                    VStack(spacing: Const.spacing) {
                        Spacer()
                        Text(title)
                            .multilineTextAlignment(.center)
                            .font(.textTitle)
                            .foregroundColor(.mainTextColor)
                            .background(Color.clear)
                        
                        Text(subtitle)
                            .multilineTextAlignment(.center)
                            .font(.textContent)
                            .foregroundColor(.mainTextColor)
                            .background(Color.clear)
                            .padding([.bottom])
                        
                        Button(action: buttonAction, 
                               label: {
                            Text(buttonTitle)
                                .font(.textSubTitle)
                                .frame(maxWidth: .infinity)
                        })
                        .buttonStyle(MainButtonStyle())
                    }
                    .padding([.bottom], Const.stackBottom)
                    .padding()
                }
                .background(
                    LinearGradient.whiteGradient
                )
                .frame(height: proxy.size.height / 2)
                .frame(maxWidth: .infinity)
            }
            .frame(maxHeight: .infinity, 
                   alignment: .bottom)
        }
    }
}


#Preview {
    BaseBottomPopupView(title: "Unlock learning", 
                        subtitle: "Grow on the go by listening and reading the world's best ideas",
                        buttonTitle: "Start Listening • $89,99") { }
}
