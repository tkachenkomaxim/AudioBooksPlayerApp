//
//  PlayerView.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//

import ComposableArchitecture
import SwiftUI

// MARK: - Constants

private enum Const {
    
    enum Sizes {
        
        static let padding: CGFloat = 10.0
    }
    
    enum Poster {
        
        static let topPadding: CGFloat = 35.0
        static let scale: CGFloat = 0.4
        static let radius: CGFloat = 10.0
    }
    
    enum ChaptersCount {
        
        static let topPadding: CGFloat = 35.0
    }
    
    enum ChapterContent {
        
        static let height: CGFloat = 45.0
        static let lineLimit: Int = 2
        static let topPadding: CGFloat = 5.0
        static let verticalPadding: CGFloat = 40
    }
    
    enum Slider {
        
        static let topPadding: CGFloat = 15.0
    }
    
    enum ModeSelector {
        
        static let bottomPadding: CGFloat = 5.0
    }
}

// MARK: - View

struct PlayerView: View {
    
    let store: StoreOf<Player>

    var body: some View {
        WithViewStore(self.store) { $0 } content: { viewStore in
            GeometryReader { proxy in
                VStack(spacing: .zero) {
                   URLImageView(url: viewStore.imageURL)
                        .scaledToFit()
                        .frame(height: proxy.size.height * Const.Poster.scale)
                        .padding(.top, Const.Poster.topPadding)
                        .cornerRadius(Const.Poster.radius)

                    Text(viewStore.chaptersCountTitle.uppercased())
                        .font(.chapterTitle)
                        .foregroundColor(.posterForground)
                        .padding(.top, Const.ChaptersCount.topPadding)

                    Text(viewStore.chapterTitle)
                        .font(.chapterContent)
                        .multilineTextAlignment(.center)
                        .frame(height: Const.ChapterContent.height)
                        .lineLimit(Const.ChapterContent.lineLimit)
                        .padding(.top, Const.ChapterContent.topPadding)
                        .padding(.horizontal, Const.ChapterContent.verticalPadding)

                    SliderView(
                        store: store.scope(
                            state: \.progress,
                            action: Player.Action.progress
                        )
                    )
                    .padding(.top, Const.Slider.topPadding)

                    SpeedRateView(title: viewStore.speedTitle) {
                        viewStore.send(.rateButtonTapped)
                    }
                    .padding(.top, Const.Slider.topPadding)

                    Spacer()
                    
                    PlayerActionButtonsView(
                        store: store.scope(
                            state: \.controls,
                            action: Player.Action.controls
                        )
                    )

                    Spacer()

                    ModeSelectorView(
                        store: store.scope(
                            state: \.mode,
                            action: Player.Action.mode
                        )
                    )
                    .padding(.bottom, Const.ModeSelector.bottomPadding)
                }
                .onAppear {
                    viewStore.send(.viewAppeared)
                }
                .customPopup(isShow: viewStore.state.isShowAlert) {
                    BaseBottomPopupView(title: viewStore.state.alert?.title ?? "",
                                        subtitle: viewStore.state.alert?.content ?? "",
                                        buttonTitle: viewStore.state.alert?.buttonTitle ?? "") {
                        if let action = viewStore.state.alert?.actionOnTap {
                            viewStore.send(action)
                        }
                    }
                }
            }
            .padding(Const.Sizes.padding)
            .background(Color.mainColor.ignoresSafeArea())
        }
    }
}

// MARK: - Preview

#Preview {
    
    PlayerView(
        store: Store(
            initialState: Player.State()) {
                Player()
            }
    )
}
