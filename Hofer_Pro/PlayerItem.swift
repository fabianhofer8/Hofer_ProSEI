//
//  PlayerItem.swift
//  Hofer_Pro
//
//  Created by Fabian Hofer on 30.11.21.
//

import Foundation
import UIKit


struct PlayerItem: Codable{
    
    var array: [Player]
    
    init(){
        self.array = []
    }
   
}


struct Player: Codable{
    var FirstName: String
    var LastName: String
    var Position: String
    var Jersey: Int?
    var PhotoUrl: String?
    var PlayerID: Int?
    var Shoots: String?
    
}
