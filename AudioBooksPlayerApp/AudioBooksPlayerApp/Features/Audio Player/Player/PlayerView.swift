//
//  PlayerView.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//

import ComposableArchitecture
import SwiftUI

private enum Const {
    enum Sizes {
        static let background: Color = .mainColor
        static let padding: CGFloat = 10.0
    }
    
    enum ChaptersCountLabel {
        static let font: Font = .system(size: 13.0, weight: .medium, design: .rounded)
        static let color: Color = .gray
        static let topPadding: CGFloat = 35.0
    }
    
    enum ChapterTitleLabel {
        static let font: Font = .system(size: 17.0, design: .rounded)
        static let height: CGFloat = 45.0
        static let lineLimit: Int = 2
        static let topPadding: CGFloat = 10.0
    }
    
    enum Controls {
        static let topPadding: CGFloat = 65.0
    }
    
    enum Cover {
        static let scale: CGFloat = 0.4
    }
    
    enum Progress {
        static let topPadding: CGFloat = 25.0
    }
    
    enum Rate {
        static let topPadding: CGFloat = 15.0
    }
}


struct PlayerView: View {
    let store: StoreOf<Player>

    var body: some View {
        WithViewStore(self.store) { $0 } content: { viewStore in
            GeometryReader { proxy in
                VStack(spacing: .zero) {
                   URLImageView(url: viewStore.imageURL)
                        .scaledToFit()
                        .frame(height: proxy.size.height * Const.Cover.scale)
                        .padding(.top, 25)

                    Text(viewStore.chaptersCountTitle.uppercased())
                        .font(Const.ChaptersCountLabel.font)
                        .foregroundColor(Const.ChaptersCountLabel.color)
                        .padding(.top, 25)

                    Text(viewStore.chapterTitle)
                        .font(Const.ChapterTitleLabel.font)
                        .multilineTextAlignment(.center)
                        .frame(height: Const.ChapterTitleLabel.height)
                        .lineLimit(Const.ChapterTitleLabel.lineLimit)
                        .padding(.top, 0)

                    SliderView(
                        store: store.scope(
                            state: \.progress,
                            action: Player.Action.progress
                        )
                    )
                    .padding(.top, 15)

                    SpeedRateView(title: viewStore.rateTitle) {
                        viewStore.send(.rateButtonTapped)
                    }
                    .padding(.top, Const.Rate.topPadding)

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
                    .padding(.bottom, 5)
                }
                .onAppear {
                    viewStore.send(.viewAppeared)
                }
                .customPopup(isShow: !viewStore.state.isPremium) {
                    BaseBottomPopupView(title: "Unlock learning",
                                        subtitle: "Grow on the go by listening and reading the world's best ideas",
                                        buttonTitle: "Start Listening • $89,99") { 
                        viewStore.send(.buyPremiumTapped)
                    }
                }
            }
            .padding(Const.Sizes.padding)
            .background(Const.Sizes.background.ignoresSafeArea())
        }
    }
}

#Preview {
    
    PlayerView(
        store: Store(
            initialState: Player.State()) {
                Player()
            }
    )
}
