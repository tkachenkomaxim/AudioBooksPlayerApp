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
    
    static var playerSliderMain: Font {
        .system(size: 13.0, weight: .regular, design: .rounded)
    }
    
    static var speedTitle: Font {
        .system(size: 13.0, weight: .semibold)
    }
    
    static var chapterTitle: Font {
        .system(size: 13.0, weight: .medium, design: .rounded)
    }
    
    static var chapterContent: Font {
        .system(size: 17.0, design: .rounded)
    }
}
