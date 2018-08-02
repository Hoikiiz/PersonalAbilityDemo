//
//  ThumbImageManager.swift
//  PersonalAbilityDemo
//
//  Created by SunYang on 2018/8/2.
//  Copyright © 2018年 SunYang. All rights reserved.
//

import UIKit
import AVFoundation

class ThumbImageManager: NSObject {
    let avAsset = AVAsset(url: URL(fileURLWithPath: Bundle.main.path(forResource: "10", ofType: "mov")!))
    
    func getImage(start: Float64) -> CGImage? {
        let generator = AVAssetImageGenerator(asset: avAsset)
        generator.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(start, 200)
        var actuakTime = CMTimeMake(0, 0)
        
        return try? generator.copyCGImage(at: time, actualTime: &actuakTime)
    }
}
