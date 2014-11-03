//
//  SoundController.swift
//  ISB
//
//  Created by Christopher Martin on 11/3/14.
//
//

import Foundation
import AVFoundation

class SoundController {
    var eatPlayer: AVAudioPlayer!
    var ballsPlayer: AVAudioPlayer!
    var wtfPlayer: AVAudioPlayer!
    
    init() {
        func getSound(soundFileName: String) -> NSURL {
            let path = NSBundle.mainBundle().pathForResource(soundFileName, ofType: "m4a")!
            let url = NSURL(fileURLWithPath:path)!
            return url
        }
        
        let error:NSErrorPointer = nil;
        eatPlayer = AVAudioPlayer(contentsOfURL: getSound("eat"), error: error)
        ballsPlayer = AVAudioPlayer(contentsOfURL: getSound("lickers"), error: error)
        wtfPlayer = AVAudioPlayer(contentsOfURL: getSound("wtf-internet"), error: error)
    }
    
    internal func playEat() {
        eatPlayer.play()
    }
    
    internal func playBalls() {
        ballsPlayer.play()
    }
    
    internal func playInternet() {
        wtfPlayer.play()
    }
}
