//
//  PlayerActionButtonsView.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//

import ComposableArchitecture
import SwiftUI

private enum Const {
    
    enum Size {
        
        static let spacing: CGFloat = 25.0
        
        static let nextButton: CGFloat = 20.0
        static let seekButtons: CGFloat = 30.0
        static let playButton: CGFloat = 35.0
    }
    
    enum Icons {
        
        static let previous = "backward.end.fill"
        static let seekBack = "gobackward.5"
        static let play = "play.fill"
        static let pause = "pause.fill"
        static let seekForward = "goforward.10"
        static let next = "forward.end.fill"
    }
}

struct PlayerActionButtonsView: View {
    
    let store: StoreOf<PlayerActionButtonsReducer>

    var body: some View {
        WithViewStore(self.store) { $0 } content: { viewStore in
            HStack(spacing: Const.Size.spacing) {
                
                BaseActionButtonView(icon: Const.Icons.previous,
                                     fontSize: Const.Size.nextButton,
                                     isEnabled: viewStore.hasPreviousChapter) {
                    viewStore.send(.previousTapped)
                }
                
                BaseActionButtonView(icon: Const.Icons.seekBack,
                                     fontSize: Const.Size.seekButtons,
                                     isEnabled: viewStore.canSeekBackward) {
                    viewStore.send(.seekBackTapped)
                }
                
                BaseActionButtonView(icon: viewStore.playerState.isPlaying ? Const.Icons.pause : Const.Icons.play,
                                     fontSize: Const.Size.playButton,
                                     isEnabled: viewStore.playerState.isEnabled) {
                    viewStore.send(.playTapped)
                }
                
                BaseActionButtonView(icon: Const.Icons.seekForward,
                                     fontSize: Const.Size.seekButtons,
                                     isEnabled: viewStore.canSeekForward) {
                    viewStore.send(.seekForwardTapped)
                }
                
                BaseActionButtonView(icon: Const.Icons.next,
                                     fontSize: Const.Size.nextButton,
                                     isEnabled: viewStore.hasNextChapter) {
                    viewStore.send(.nextTapped)
                }
            }
        }
    }
}

#Preview {
    PlayerActionButtonsView(
        store: Store(
            initialState: PlayerActionButtonsReducer.State(
                playerState: .paused,
                hasPreviousChapter: false,
                hasNextChapter: true
            )) {
                PlayerActionButtonsReducer()
            }
    )
}
