//
//  ModeSelectorReducer.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 23.10.2023.
//

import ComposableArchitecture
import Foundation

struct ModeSelectorReducer: Reducer {
    
    // MARK: - State
    
    struct State: Equatable {
        
        var mode: ModeSelector = .audio
    }
    
    // MARK: - Action

    enum Action: Equatable {
        
        case selectorTaped
    }
    
    // MARK: - Reduce

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        
        switch action {
        case .selectorTaped:
            state.mode.toggle()
            return .none
        }
    }
}

// MARK: - ModeSelector State Helper

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
