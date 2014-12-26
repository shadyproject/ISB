//
//  YoutubeParser.swift
//  ISB
//
//  Created by Christopher Martin on 11/3/14.
//
//

import Foundation

#if os(iOS)
    import UIKit
    typealias Image =  UIImage
#else
    import Cocoa
    typealias Image =  NSImage
#endif
    

let YoutubeInfoUrl = "http://www.youtube.com/get_video_info?video_id="
let YoutubeThumbnailUrl = "http://img.youtube.com/vi/"
let YoutubeDataUrl = "http://gdata.youtube.com/feeds/api/videos/"
let UserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.79 Safari/537.4"

enum YoutubeThumbnail:String {
    case Default = "default"
    case DefaultMedium = "mqdefault"
    case DefaultHighQuality = "hqdefault"
    case DefaultMaxQuality = "maxresdefault"
}


//TODO this could probably be a struct
class YoutubeParser {
    internal class func youtubeIdFromUrl(youtubeUrl url:NSURL!) -> String {
        
        //I feel like this could be more functional-y
        if (url.host == "youtu.be") {
            return url.pathComponents![1] as String
        } else if (url.absoluteString!.rangeOfString("www.youtube.com/embed") != nil) {
            return url.pathComponents![2] as String
        } else if (url.host == "youtube.googleapis.com" || url.pathComponents!.first! as NSString == "www.youtube.com") {
            return url.pathComponents![2] as String
        } else {
           return url.dictionaryForQueryString()["v"]!.first!
        }
    }
    
    internal class func h264VideosForYoutubeId(youtubeId id:NSString) -> VideoInfo {
        let url = NSURL(string: "\(YoutubeInfoUrl)\(id)")
        let req = NSMutableURLRequest(URL: url!)
        req.setValue(UserAgent, forHTTPHeaderField: "User-Agent")
        req.HTTPMethod = "GET"
        
        var resp:NSURLResponse? = nil
        var error:NSError? = nil
        
        //TODO replace with NSURLSession
        var respData = NSURLConnection.sendSynchronousRequest(req, returningResponse: &resp, error: &error)
        
        if let unwrappedError = error {
            println("An error occured: \(unwrappedError)")
        }
        
        var qualityDict = [String: String]()
        let responseString = NSString(data:respData!, encoding:NSUTF8StringEncoding)
        let parts = (responseString! as String).dictionaryFromQueryStringComponents()
        
        let streamMap = parts["url_encoded_fmt_stream_map"]!
        let streamMapItems = streamMap.first!.componentsSeparatedByString(",")
        
        for videoEncodedString in streamMapItems {
            let components = videoEncodedString.dictionaryFromQueryStringComponents()
            let type = components["type"]!.first!.stringByDecodingUrlFormat()
            var signature:String? = nil
            
            if (components["stereo3d"] == nil) {
                if (components["itag"] != nil) {
                    signature = components["itag"]?.first
                }
                
                if(signature != nil && type.rangeOfString("mp4").location > 0) {
                    let url = components["url"]!.first!.stringByDecodingUrlFormat()
                    let urlWithSig = "\(url)&signature=\(signature!)"
                    
                    let quality = components["quality"]!.first!.stringByDecodingUrlFormat()
                    qualityDict[quality] = urlWithSig
                }
            }
        }
        let title = parts["title"]!.first!
        let thumbUrl = NSURL(string:parts["iurl"]!.first!)
        let length = parts["length_seconds"]!.first!.toInt()!
        
        let smallUrlStr = qualityDict["small"] ?? ""
        let smallUrl = NSURL(string:smallUrlStr)
        
        let mediumUrlStr = qualityDict["medium"] ?? ""
        let mediumUrl = NSURL(string: mediumUrlStr)
        
        let hdUrlStr = qualityDict["hd720"] ?? ""
        let hdUrl = NSURL(string: hdUrlStr)
        
        let info = VideoInfo(title: title, thumbnailUrl: thumbUrl, length: length,
            smallUrl:  smallUrl,
            mediumUrl: mediumUrl,
            hdUrl: hdUrl)
        
        return info
    }
    
    internal class func h264VideosForYoutubeUrl(youtubeUrl url:NSURL!) -> VideoInfo {
        let youtubeId = self.youtubeIdFromUrl(youtubeUrl:url)
        let info = self.h264VideosForYoutubeId(youtubeId: youtubeId)
        return info
    }
    
    internal class func h264VideosForYoutubeUrl(youtubeUrl url:NSURL!, completion:(VideoInfo) -> Void) {
        let id = self.youtubeIdFromUrl(youtubeUrl: url)
        let bgQueue = dispatch_queue_create("net.shadyproject.isb.background-queue", nil)
        //trailing closure replaces block
        dispatch_async(bgQueue) {
            let info = self.h264VideosForYoutubeId(youtubeId: id)
            completion(info)
        }
    }
    
    class func thumbnailUrlForYoutubeId(youtubeId id:String, thumbnailSize size:YoutubeThumbnail) -> NSURL! {
        let thumbUrl = "\(YoutubeThumbnailUrl)/\(id)/\(size.rawValue).jpg"
        return NSURL(string:thumbUrl)!
    }
    
    internal class func thumbnailUrlForYoutubeUrl(youtubeUrl url:NSURL!, thumbnailSize size:YoutubeThumbnail) -> NSURL! {
        let ytId = self.youtubeIdFromUrl(youtubeUrl: url)
        return self.thumbnailUrlForYoutubeId(youtubeId: ytId, thumbnailSize: size)
    }
    
    internal class func thumbnailForYoutubeId(youtubeId id:String, thumbnailSize size:YoutubeThumbnail, completion:(Image, NSError) -> Void){
        let url = self.thumbnailUrlForYoutubeId(youtubeId: id, thumbnailSize: size)
        let req = NSMutableURLRequest(URL: url)
        req.setValue(UserAgent, forHTTPHeaderField: "User-Agent")
        req.HTTPMethod = "GET"
        
        let opQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(req, queue: opQueue) {
            response, data, error in
            let img = Image(data: data)!
            completion(img, error)
        }
    }
    
    class func detailsForYoutubeId(youtubeId id:String, completion:(Dictionary<String,String>, NSError) -> Void) {
        let detailsUrl = NSURL(string:"\(YoutubeInfoUrl)\(id)?alt=json")!
        
        let req = NSURLRequest(URL: detailsUrl)
        let opQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(req, queue: opQueue) {
            response, data, error in
            var parseError:NSError? = nil
            let dict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &parseError) as Dictionary<String, String>
            completion(dict, parseError!)
        }
    }
    
    internal class func detailsForYoutubeUrl(youtubeUrl url:NSURL!, completion:(Dictionary<String,String>, NSError) -> Void) {
        let id = self.youtubeIdFromUrl(youtubeUrl: url)
        return self.detailsForYoutubeId(youtubeId: id, completion)
    }
}