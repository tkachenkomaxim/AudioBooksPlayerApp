//
//  SliderView.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 23.10.2023.
//

import ComposableArchitecture
import SwiftUI
import UIKit.UISlider

// MARK: - Constants

private enum Const {
    enum Sizes {
        static let width: CGFloat = 50.0
    }
    
    enum Progress {
        
        static let color: UIColor = .systemBlue
        static let step: Double = 1.0
        static let minimumValue: Double = .zero
    }
    
    enum Slider {
        static let title: String = "Progress"
        static let color: UIColor = UIColor(Color.thumbColor)
        static let image: UIImage? = UIImage(
            systemName: "circle.fill",
            withConfiguration: UIImage.SymbolConfiguration(scale: .medium)
        )
    }
}

// MARK: - View

struct SliderView: View {
    let store: StoreOf<SliderReducer>

    var body: some View {
        WithViewStore(self.store) { $0 } content: { viewStore in
            Slider(
                value: viewStore.binding(
                    get: \.current,
                    send: SliderReducer.Action.sliderUpdated
                ),
                in: .zero ... viewStore.duration,
                step: viewStore.step
            ) {
                Text(Const.Slider.title)
            } minimumValueLabel: {
                Text(viewStore.current.timeCode)
                    .font(.playerSliderMain)
                    .foregroundColor(Color.sliderColor)
                    .frame(width: Const.Sizes.width)
            } maximumValueLabel: {
                Text(viewStore.duration.timeCode)
                    .font(.playerSliderMain)
                    .foregroundColor(Color.sliderColor)
                    .frame(width: Const.Sizes.width)
            }
            .onAppear(perform: onAppear)
            .disabled(!viewStore.isEnabled)
            .tint(Color.thumbColor)
        }
    }

    private func onAppear() {
        UISlider.appearance()
            .setThumbImage(Const.Slider.image, for: .normal)
        UISlider.appearance()
            .minimumTrackTintColor = Const.Slider.color
    }
}

// MARK: - Preview

#Preview {
    SliderView(
        store: Store(
            initialState: SliderReducer.State()) {
                SliderReducer()
            }
    )
}
