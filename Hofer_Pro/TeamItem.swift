//
//  TeamItem.swift
//  Hofer_Pro
//
//  Created by Fabian Hofer on 29.11.21.
//

import Foundation
import UIKit

struct TeamItem: Codable{
    
    var array: [Team]
    
    init(){
        self.array = []
    }
   
}


struct Team: Codable{
    var Name: String
    var City: String
    var WikipediaLogoUrl: String?
    var TeamID: Int
    var Key: String
}
