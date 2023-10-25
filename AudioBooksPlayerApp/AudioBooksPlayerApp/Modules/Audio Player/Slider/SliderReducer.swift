//
//  SliderReducer.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//

import ComposableArchitecture
import Foundation

struct Position: Equatable {
    
    let time: Double
    let step: Double
}

// MARK: - Slider Status

enum SliderStatus: Equatable {
    
    case disabled
    case enabled(Position)

    var isEnabled: Bool {
        self != .disabled
    }

    var duration: Double {
        switch self {
        case .disabled:
            return .leastNonzeroMagnitude
        case let .enabled(position):
            return position.time
        }
    }

    var step: Double {
        switch self {
        case .disabled:
            return .leastNonzeroMagnitude
        case let .enabled(position):
            return position.step
        }
    }
}

struct SliderReducer: Reducer {
    
    // MARK: - State
    
    struct State: Equatable {
        var current: Double = .zero
        var status: SliderStatus = .disabled

        var isEnabled: Bool { status.isEnabled }
        var duration: Double { status.duration }
        var step: Double { status.step }
    }
    
    // MARK: - Action

    enum Action: Equatable {
        case sliderUpdated(Double)
    }

    // MARK: - Reduce
    
    func reduce(into _: inout State, action _: Action) -> Effect<Action> {
        .none
    }
}
