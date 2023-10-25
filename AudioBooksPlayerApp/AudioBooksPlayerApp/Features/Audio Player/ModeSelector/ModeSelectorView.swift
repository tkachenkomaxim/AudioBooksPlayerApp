//
//  ModeSelectorView.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 23.10.2023.
//

import ComposableArchitecture
import SwiftUI

// MARK: - Constants

private enum Const {
    enum Sizes {
        static let padding: CGFloat = 15.0
        static let spacing: CGFloat = 35.0
        static let width: CGFloat = 45.0
        static let borderCornerRadius: CGFloat = 50
        static let lineWidth: CGFloat = 1
    }
    enum Icons {
        static let text: String = "text.alignleft"
        static let audio: String = "headphones"
    }
}

// MARK: - View

struct ModeSelectorView: View {
    
    @Namespace private var nameSpace
    let store: StoreOf<ModeSelectorReducer>

    var body: some View {
        WithViewStore(self.store) { $0 } content: { viewStore in
            ZStack {
                Circle()
                    .fill(Color.thumbColor)
                    .frame(width: Const.Sizes.width)
                    .matchedGeometryEffect(
                        id: viewStore.mode,
                        in: nameSpace,
                        properties: .position,
                        anchor: .center,
                        isSource: false
                    )

                HStack(spacing: Const.Sizes.spacing) {
                    Image(systemName: Const.Icons.audio)
                        .font(.textSubTitle)
                        .matchedGeometryEffect(id: ModeSelector.audio,
                                               in: nameSpace)
                        .foregroundColor(viewStore.mode == .audio ?
                            .backgroundSecondColor : .mainTextColor)
                    Image(systemName: Const.Icons.text)
                        .font(.textSubTitle)
                        .matchedGeometryEffect(id: ModeSelector.text,
                                               in: nameSpace)
                        .foregroundColor(viewStore.mode == .text ? 
                            .backgroundSecondColor : .mainTextColor)
                }
                .padding(Const.Sizes.padding)
            }
            .animation(.easeIn, value: viewStore.mode)
            .background {
                Capsule()
                    .fill(Color.backgroundSecondColor)
            }
            .overlay(
                RoundedRectangle(cornerRadius: Const.Sizes.borderCornerRadius)
                    .stroke(Color.selectorBorderColor, lineWidth: Const.Sizes.lineWidth)
            )
            .onTapGesture {
                viewStore.send(.selectorTaped)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    
    ZStack {
        Color(uiColor: .secondarySystemFill)
            .ignoresSafeArea()
        ModeSelectorView(
            store: Store(
                initialState: ModeSelectorReducer.State(mode: .audio)) {
                    ModeSelectorReducer()
                }
        )
    }
}
