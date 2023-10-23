//
//  Color+Design.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 23.10.2023.
//

import SwiftUI

public extension Color {
    static var mainColor: Color {
        Color(UIColor(red: 254.0 / 255.0, green: 248.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0))
    }
    
    static var secondaryTextColor: Color {
        Color(UIColor(red: 156.0 / 255.0, green: 153.0 / 255.0, blue: 151.0 / 255.0, alpha: 1.0))
    }
    
    static var mainBlueColor: Color {
        Color(UIColor(red: 42.0 / 255.0, green: 100.0 / 255.0, blue: 246.0 / 255.0, alpha: 1.0))
    }
    
    static var speedBackgroundColor: Color {
        Color(UIColor(red: 241.0 / 255.0, green: 235.0 / 255.0, blue: 232.0 / 255.0, alpha: 1.0))
    }
    
    static var selectorBorderColor: Color {
        .gray.opacity(0.5)
    }
    
    static var mainTextColor: Color {
        .black
    }
    
    static var thumbColor: Color {
        .init(uiColor: .systemBlue)
    }
    
    static var backgroundSecondColor: Color {
        .white
    }
    
    static var speedBtnBackground: Color {
        .gray.opacity(0.15)
    }
       
}
