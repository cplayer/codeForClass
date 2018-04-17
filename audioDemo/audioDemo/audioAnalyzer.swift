//
//  audioAnalyzer.swift
//  audioDemo
//
//  Created by JTDX on 2018/4/17.
//  Copyright © 2018年 JTDX. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class audioAnalyzer : AVAudioRecorderDelegate {
    let RATE_HZ : Int
    let BUFFER_SIZE : Int
    
    var recorder : AVAudioRecorder?
    var player : AVAudioPlayer?
    var isAllowed : Bool?
    var recordPath : String?
    
    init () {
        self.RATE_HZ = 48000
        self.BUFFER_SIZE = self.RATE_HZ
    }
    
    func recordAudio () {
        let audioSession : AVAudioSession = AVAudioSession.sharedInstance()
        let recordSettings : Dictionary<String, Any> = [
            // 音频采样率
            AVSampleRateKey : self.RATE_HZ,
            // 编码格式
            AVFormatIDKey : NSNumber(value : kAudioFormatLinearPCM),
            // 采集音轨
            AVNumberOfChannelsKey : 1,
            // 采样位数
            AVLinearPCMBitDepthKey: 16,
            // 音频质量
            AVEncoderAudioQualityKey : NSNumber(value : AVAudioQuality.max.rawValue)
        ]
        audioSession.requestRecordPermission({ (allowed) in
            if !allowed {
                // let alertView = UIAlertController(title: "无法访问您的麦克风", message: "请到设置 -> 隐私 -> 麦克风 ，打开访问权限", preferredStyle: .alert)
                self.isAllowed = false
            } else {
                self.isAllowed = true
            }
            
            if self.isAllowed! {
                do {
                    try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                    let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                     .userDomainMask,
                                                                     true)[0]
                    self.recordPath = docDir + "/audio.txt"
                    try self.recorder = AVAudioRecorder(url: URL(string: self.recordPath!)!, settings: recordSettings)
                    self.recorder?.delegate = self
                } catch let error as NSError {
                    print(error)
                }
            }
        })
    }
    
}
