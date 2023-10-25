//
//  Color+Design.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 23.10.2023.
//

import SwiftUI

public extension Color {
   
    static var selectorBorderColor: Color {
        .gray.opacity(0.5)
    }
    
    static var mainTextColor: Color {
        .black
    }
    
    static var thumbColor: Color {
        .init(uiColor: .systemBlue)
    }
    
    static var mainColor: Color {
        Color(UIColor(red: 254.0 / 255.0, green: 248.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0))
    }
    
    static var backgroundSecondColor: Color {
        .white
    }
    
    static var speedBtnBackground: Color {
        .gray.opacity(0.15)
    }
    
    static var sliderColor: Color {
        .init(uiColor: .gray)
    }
    
    static var mainBlueColor: Color {
        Color(UIColor(red: 42.0 / 255.0, green: 100.0 / 255.0, blue: 246.0 / 255.0, alpha: 1.0))
    }
    
    static var actionEnabledColor: Color {
        .init(uiColor: .label)
    }
    static var actionDisabledColor: Color {
        .init(uiColor: .label).opacity(0.25)
    }
      
    static var posterForground: Color {
        .init(uiColor: .gray)
    }
}
