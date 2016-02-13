//
//  HowlModel.swift
//  
//
//  Created by Kyle Willcox on 1/29/15.
//  Copyright (c) 2015 TimeLapse. All rights reserved.
//

import Foundation
import Darwin

class howlModel: NSObject, Printable {
    let  howlId: Int
    let  latitude: Double
    let  longetitude: Double
    let  title:String
    let  desc:String
    let  post_time:String
    var  voteCount:Int
   
    //Intilizer how for a howlModel
    
    init(l_id: Int?, lat: Double?, longet: Double?, title:String?, desc:String?, post_time:String?) {
        self.howlId = l_id ?? 0
        self.latitude = lat ?? 0.0
        self.longetitude = longet ?? 0.0
        self.title = title ?? ""
        self.desc = desc ?? ""
        self.post_time = post_time ?? ""
        self.voteCount = 0
  
        
    }
    
    //Description for debugging purposes
    override var description: String {
        
        return "The id is: \(howlId), and latitude is: \(latitude)/n The longetitude is: \(longetitude) and the title is \(title) with desc: \(desc)"
    }
    
    
    //Method to get distance of howl from another point
    func getDistanceFromHowl(distLat:Double, distLong:Double) -> Double{
        
        var latDiff = (self.latitude - distLat)
        latDiff*=latDiff
        
        var lonDiff = (self.longetitude - distLong)
        lonDiff*=lonDiff
        
        let total = sqrt(lonDiff+latDiff)
        
        return total
        
    }
    
    //Method to upvote
    func upVoteHowl(){
        self.voteCount++
        
    }
    
    //Method to downvote
    func downVoteHowl(){
        self.voteCount--
    }
    
    
    
    
}