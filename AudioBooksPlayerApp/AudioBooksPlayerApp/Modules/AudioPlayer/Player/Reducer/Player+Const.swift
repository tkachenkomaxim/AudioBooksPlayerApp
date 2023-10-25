//
//  PlayerReducer.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//

import ComposableArchitecture
import Foundation
import UIKit.UIImage

// MARK: - Player+Constants

extension Player {
    enum Constants {
        
        enum Progress {
            
            static let defaultChapter: Int = 0
            static let step: Double = 1.0
            static let seekForwardInterval: Double = 10.0
            static let seekBackwardInterval: Double = 5.0
        }
        
        enum Rate {
            
            static let max: Float = 2.0
            static let min: Float = 0.25
            static let step: Float = 0.25
            static let normal: Float = 1.0
        }
    }
}

