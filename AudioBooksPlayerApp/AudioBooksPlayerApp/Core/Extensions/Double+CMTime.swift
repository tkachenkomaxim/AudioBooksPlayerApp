//
//  Double+CMTime.swift
//  AudioBooksPlayerApp
//
//  Created by Maksym Tkachenko on 25.10.2023.
//

import Foundation
import CoreMedia.CMTime

// MARK: - Double+CMTime

extension Double {
    
    func cmTime(timescale: UInt64 = NSEC_PER_SEC) -> CMTime {
        
        CMTime(seconds: self, preferredTimescale: CMTimeScale(timescale))
    }
}
