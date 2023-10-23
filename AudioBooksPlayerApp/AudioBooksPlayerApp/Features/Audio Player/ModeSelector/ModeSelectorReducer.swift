//
//  ModeSelectorReducer.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 23.10.2023.
//

import ComposableArchitecture
import Foundation

struct ModeSelectorReducer: Reducer {
    
    struct State: Equatable {
        
        var mode: ModeSelector = .audio
    }

    enum Action: Equatable {
        
        case selectorTaped
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        
        switch action {
        case .selectorTaped:
            state.mode.toggle()
            return .none
        }
    }
}

enum ModeSelector: Int {
    
    case text = 0
    case audio = 1

    mutating func toggle() {
        switch self {
        case .text:
            self = .audio
        case .audio:
            self = .text
        }
    }
}
