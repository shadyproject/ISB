//
//  ImportController.swift
//  ISB
//
//  Created by Christopher Martin on 11/22/14.
//
//

import Foundation
import AVFoundation

enum ImportStatus {
    case NotStarted
    case Running (Float) //percent done (approximate)
    case Succeeded (NSData) //raw data for audio track
    case Failed (NSError) //error that occured
}

protocol ImportControllerDelegate {
    func status(ImportStatus) -> Void
    func didStart(ImportStatus) -> Void
    func didFinish(ImportStatus) -> Void
}

class ImportController {

    internal var delegate: ImportControllerDelegate

    init(delegate: ImportControllerDelegate) {
        self.delegate = delegate
    }

    internal func startImport(fromUrl:NSURL!) {
        println("Starting Import")
        delegate.didStart((ImportStatus.Running(0.0)))
        
        //TODO this should maybe happen on a background thread since we're doing network stuff
        println("Parsing URL")
        let info = YoutubeParser.h264VideosForYoutubeUrl(youtubeUrl: fromUrl)
        delegate.status(ImportStatus.Running(10.0))
        
        println("Loading stream into AVFoundation")
        let asset = AVAsset.assetWithURL(info.smallUrl!) as AVURLAsset
        delegate.status(ImportStatus.Running(20.0))
        
        var loadingPercent = Float(20.0)
        
        asset.loadValuesAsynchronouslyForKeys(["tracks"], completionHandler: { () -> Void in
            var error:NSError? = nil
            let status = asset.statusOfValueForKey("tracks", error: &error)
            
            switch status {
            case .Loaded:
                loadingPercent += Float(10.0)
                self.delegate.status(.Running(loadingPercent))
                
                for track in asset.tracks {
                    if track.mediaType == AVMediaTypeAudio {
                        track
                    }
                }
                
                
                println("Almost Done")
                self.delegate.status(ImportStatus.Running(99.9))

                println("Finished")
                self.delegate.status(ImportStatus.Succeeded("Finished".dataUsingEncoding(NSUTF8StringEncoding)!))
            case .Failed:
                self.delegate.status(.Failed(error!))
            case .Cancelled:
                self.delegate.didFinish(.Failed(NSError(domain: "Cancelled", code: 0, userInfo: nil)))
            case .Unknown:
                self.delegate.status(.Failed(NSError(domain: "Unknown", code: 1, userInfo: nil)))
            case .Loading:
                loadingPercent += 0.1
                self.delegate.status(ImportStatus.Running(loadingPercent))
            }
        })
    }
}