//
//  LinearGradient+Design.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 23.10.2023.
//

import SwiftUI

public extension LinearGradient {
    static var mainGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: .mainColor, location: 0),
                .init(color: .clear, location: 1),
            ]),
                startPoint:  UnitPoint(x: 0.5, y: 0.2),
                endPoint: .top
        )
    }
    
    static var whiteGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: .white, location: 0),
                .init(color: .clear, location: 1)
            ]),
                startPoint:  UnitPoint(x: 0.5, y: 0.2),
                endPoint: .top
        )
    }
}
