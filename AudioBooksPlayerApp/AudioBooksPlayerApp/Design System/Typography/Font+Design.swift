//
//  Font+Design.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 23.10.2023.
//

import SwiftUI

public extension Font {
    static var textContent: Font {
        .system(size: 20, weight: .regular)
    }
    
    static var textTitle: Font {
        .system(size: 30, weight: .bold)
    }
    
    static var textSubTitle: Font {
        .system(size: 18, weight: .semibold)
    }
}
