//
//  FMBeans.swift
//  ZifyFM
//
//  Created by Siva Sankar on 04/10/17.
//  Copyright © 2017 Siva Sankar. All rights reserved.
//

import UIKit

class FMBeans: NSObject {

}

class ImagesBean: NSObject {
    var imageUrl : String?
    var size : String?
}

class ArtistBean: NSObject {
    
    var name : String?
    var listeners : String?
    var mbid : String?
    var streamable : NSNumber?
    let picturesArray : NSMutableArray = NSMutableArray()
    var url : String?
    
    func getArtistsList(response : NSDictionary, artistsArray : NSMutableArray) {
        
        let resultDict : NSDictionary? = response["artistmatches"] as? NSDictionary
        let artistArray : NSArray? = resultDict?["artist"] as? NSArray
        
        for dict in artistArray as! [NSDictionary] {
            
            let articalBean: ArtistBean = ArtistBean()
            
            if let name = dict["name"] as? String {
                articalBean.name = name
            }
            
            if let listeners = dict["listeners"] as? String {
                articalBean.listeners = listeners
            }
            
            if let mbid = dict["mbid"] as? String {
                articalBean.mbid = mbid
            }
            
            if let url = dict["url"] as? String {
                articalBean.url = url
            }
            
            if let streamable = dict["streamable"] as? NSNumber {
                articalBean.streamable = streamable
            }
            
            let pictures: NSArray = dict["image"] as! NSArray
            
            for images in pictures as! [Dictionary<String, Any>] {
                let imagesBean : ImagesBean = ImagesBean()
                if let imageUrl = images["#text"] as? String {
                    imagesBean.imageUrl = imageUrl
                }
                
                if let size = images["size"] as? String {
                    imagesBean.size = size
                }
                articalBean.picturesArray.add(imagesBean)
            }
            artistsArray.add(articalBean)
        }
    }
}
