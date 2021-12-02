//
//  StatsItem.swift
//  Hofer_Pro
//
//  Created by Fabian Hofer on 30.11.21.
//

import Foundation


struct StatsItem{
    var player: Stats?
    
    init(){
        player = nil
    }
}

struct Stats: Codable{
    var Position: String?
    var Goals: Double?
    var Assists: Double?
    var Games: Double?
    var Hits: Double?
    var PenaltyMinutes: Double?
    var PlusMinus: Double?
    
    // Goalie
    var GoaltendingGoalsAgainst: Double?
    var GoaltendingSaves: Double?
    var GoaltendingShutouts: Double?
    var GoaltendingWins: Double?
    var GoaltendingLosses: Double?
    var GoaltendingShotsAgainst: Double?
}
