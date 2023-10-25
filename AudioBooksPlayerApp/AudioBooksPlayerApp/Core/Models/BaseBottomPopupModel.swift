//
//  BaseBottomPopupModel.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 25.10.2023.
//

import Foundation
import ComposableArchitecture

struct BaseBottomPopupModel<T: Equatable> : Equatable {
    static func == (lhs: BaseBottomPopupModel, rhs: BaseBottomPopupModel) -> Bool {
        lhs.title == rhs.title && lhs.content == rhs.content
    }
    
    var title: String
    var content: String
    var buttonTitle: String
    var actionOnTap: T
}
