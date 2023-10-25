//
//  Double+TimeCode.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 24.10.2023.
//

import Foundation
import CoreMedia.CMTime

extension Double {
    var timeCode: String {
        guard self != .infinity else { return "--:--" }

        let totalSeconds = Int(self)
        let hours = Int(totalSeconds / 3600)
        let minutes = Int(totalSeconds % 3600 / 60)
        let seconds = Int((totalSeconds % 3600) % 60)

        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
}

extension Double {
    func cmTime(timescale: UInt64 = NSEC_PER_SEC) -> CMTime {
        CMTime(seconds: self, preferredTimescale: CMTimeScale(timescale))
    }
}

import Foundation

extension Float {
    var stringWithTruncatedZero: String {
        truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

