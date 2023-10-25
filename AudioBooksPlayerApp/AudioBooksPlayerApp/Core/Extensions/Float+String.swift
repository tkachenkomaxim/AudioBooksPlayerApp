//
//  Float+String.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 25.10.2023.
//

import Foundation

// MARK: - Float+String

extension Float {
    
    var stringWithTruncatedZero: String {
        
        truncatingRemainder(dividingBy: 1) == 0 ? 
        String(format: "%.0f", self) : String(self)
    }
}
