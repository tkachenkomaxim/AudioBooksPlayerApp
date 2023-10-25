//
//  PopupViewModifier.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//
import SwiftUI

public struct PopupViewModifier<Popup: View>: ViewModifier {
    
    // MARK: - Public Props
    
    public var isNeedToShow: Bool
    
    @ViewBuilder public let bottomPopup: Popup
    
    // MARK: - View

    public func body(content: Content) -> some View {
        
        ZStack {
            content
            if isNeedToShow {
                bottomPopup
            }
        }
    }
}

// MARK: - ViewModifier Extension

public extension View {
    
    func customPopup<Popup: View>(isShow: Bool,
                                  @ViewBuilder popup: () -> Popup) -> some View {
        
        modifier(PopupViewModifier(isNeedToShow: isShow,
                                   bottomPopup: popup))
    }
}
