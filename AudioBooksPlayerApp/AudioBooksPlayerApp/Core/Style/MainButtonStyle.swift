//
//  MainButtonStyle.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 23.10.2023.
//

import SwiftUI

public struct MainButtonStyle: ButtonStyle {
    
    // MARK: - Private Props
    
    private let color: Color
    private let minHeight: CGFloat
    
    // MARK: - Lifecycle
    
    public init(color: Color = .mainBlueColor, 
                minHeight: CGFloat = 60) {
        
        self.color = color
        self.minHeight = minHeight
    }
    
    // MARK: - Public func

    public func makeBody(configuration: Configuration) -> some View {
        
        configuration.label
            .frame(minHeight: minHeight)
            .foregroundColor(.backgroundSecondColor)
            .background(color.clipShape(RoundedRectangle(cornerRadius: 6)))
    }
}
