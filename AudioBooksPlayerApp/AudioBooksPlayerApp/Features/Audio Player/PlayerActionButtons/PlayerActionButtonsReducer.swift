//
//  PlayerActionButtonsReducer.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//

import ComposableArchitecture
import Foundation

enum PlayerState: Equatable {
    case playing
    case paused
    case disabled

    var isEnabled: Bool { self != .disabled }
    var isPlaying: Bool { self == .playing }
}

struct PlayerActionButtonsReducer: Reducer {
    struct State: Equatable {
        
        var playerState: PlayerState = .disabled
        var hasPreviousChapter: Bool = false
        var hasNextChapter: Bool = false

        var canSeekBackward: Bool { playerState != .disabled }
        var canSeekForward: Bool { playerState != .disabled }
    }

    enum Action {
        
        case previousTapped
        case seekBackTapped
        case playTapped
        case seekForwardTapped
        case nextTapped
    }

    func reduce(into _: inout State, action _: Action) -> Effect<Action> {
        .none
    }
}

