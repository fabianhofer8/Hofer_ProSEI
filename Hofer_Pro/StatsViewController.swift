//
//  StatsViewController.swift
//  Hofer_Pro
//
//  Created by Fabian Hofer on 30.11.21.
//

import Foundation
import UIKit
import Kingfisher

class StatsViewController: UIViewController{
    
    
    enum NetworkError: Error{
        case couldNotParseUrl
        case noResponseData
    }
    private let urlSession = URLSession.shared

    
    
    @IBOutlet var gamesPlayed: UILabel!
    @IBOutlet var teamLogo: UIImageView!
    @IBOutlet var teamName: UILabel!
    @IBOutlet var lastName: UILabel!
    @IBOutlet var positionNR: UILabel!
    @IBOutlet var firstName: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var goals: UILabel!
    @IBOutlet var assists: UILabel!
    @IBOutlet var points: UILabel!
    @IBOutlet var hits: UILabel!
    
    @IBOutlet var penalties: UILabel!
    @IBOutlet var plusMinus: UILabel!
    @IBOutlet var shoots: UILabel!
    @IBOutlet var gamesLabel: UILabel!
    @IBOutlet var goalsLabel: UILabel!
    @IBOutlet var assistsLabel: UILabel!
    @IBOutlet var pointsLabel: UILabel!
    
    @IBOutlet var shootsLabel: UILabel!
    @IBOutlet var plusMinusLabel: UILabel!
    @IBOutlet var penaltiesLabel: UILabel!
    @IBOutlet var hitsLabel: UILabel!
    
    
    
    let identifier = "StatsIdentifier"
    
// data from tableview cell
    var playerID: Int?
    var jersey: Int?
    var shootsString: String?
    var teamNameString: String?
    var firstNameString: String?
    var lastNameString: String?
    var positionNRString: String?
    var porträtImageUrl: String?
    var clubImageUrl: String?
    var id: Int = 0
    
    var statItems: Stats = Stats()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let prevID = playerID{
            id = prevID
        }
        
        requestStats(completion: { statsItem, error in
            print(error)
            guard let item = statsItem else{
                return
            }
            print(item)
            self.statItems = item
            self.addData()
            
           
            
            })
        
        addData()
        self.reloadInputViews()

        
        
    }
    
    // adds all content into view
    private func addData(){
        
        DispatchQueue.main.async { [self] in
            self.plusMinusLabel.layer.masksToBounds = true
            self.plusMinusLabel.layer.cornerRadius = 8
            self.plusMinus.layer.masksToBounds = true
            self.plusMinus.layer.cornerRadius = 8
            
            self.hitsLabel.layer.masksToBounds = true
            self.hitsLabel.layer.cornerRadius = 8
            self.hits.layer.masksToBounds = true
            self.hits.layer.cornerRadius = 8
            
            self.penaltiesLabel.layer.masksToBounds = true
            self.penaltiesLabel.layer.cornerRadius = 8
            self.penalties.layer.masksToBounds = true
            self.penalties.layer.cornerRadius = 8
            
            self.shoots.layer.masksToBounds = true
            self.shoots.layer.cornerRadius = 8
            self.shootsLabel.layer.masksToBounds = true
            self.shootsLabel.layer.cornerRadius = 8
            
            
            
            
            self.gamesLabel.layer.masksToBounds = true
            self.gamesLabel.layer.cornerRadius = 8
            self.goalsLabel.layer.masksToBounds = true
            self.goalsLabel.layer.cornerRadius = 8
            self.assistsLabel.layer.masksToBounds = true
            self.assistsLabel.layer.cornerRadius = 8
            self.pointsLabel.layer.masksToBounds = true
            self.pointsLabel.layer.cornerRadius = 8
            
            self.goals.layer.masksToBounds  = true
            self.goals.layer.cornerRadius = 5
            self.gamesPlayed.layer.masksToBounds  = true
            self.gamesPlayed.layer.cornerRadius = 5
            self.assists.layer.masksToBounds  = true
            self.assists.layer.cornerRadius = 5
            self.points.layer.masksToBounds  = true
            self.points.layer.cornerRadius = 5
                
            // add api data into view
            
            if let lns = self.lastNameString{
                self.lastName.text = lns
            }
            if let fns = self.firstNameString{
                self.firstName.text = fns
            }
            if let pns = self.positionNRString{
                self.positionNR.text = pns
            }
            if let hand = self.shootsString{
                shoots.text = hand
            }
            
            if let teamLogoUrl = self.clubImageUrl{
                let picUrl = URL(string: teamLogoUrl)
                self.teamLogo.kf.setImage(with: picUrl)
            }
            if let tns = self.teamNameString{
                self.teamName.text = tns
            }
            
            if let img = self.porträtImageUrl{
                let url = URL(string: img)
                self.image.kf.setImage(with: url)
                
            }
            
            if let gapd = self.statItems.Games{
                self.gamesPlayed.text = "\(Int(gapd))"
                
                if let asts = self.statItems.Assists{
                    self.assists.text = "\(Int(asts))"
                    
                    if let gls = self.statItems.Goals{
                        self.goals.text = "\(Int(gls))"
                        
                        self.points.text = "\(Int(asts + gls))"
                       
                    }
                    
                }
                
            }else{
                self.goals.text = "0"
                self.assists.text = "0"
                self.gamesPlayed.text = "0"
                self.points.text = "0"

            }
            
            // bottom four values
            
            
            if let hts = self.statItems.Hits{
                self.hits.text = "\(Int(hts))"
            }else{
                self.hits.text = "0"
            }
            
            
            if let pen = self.statItems.PenaltyMinutes{
                self.penalties.text = "\(Int(pen))"
            }else{
                self.penalties.text = "0"
            }
            
            if let plmi = self.statItems.PlusMinus{
                self.plusMinus.text = "\(Int(plmi))"
            }else{
                self.plusMinus.text = "0"
            }
            
            // for goalies
            if let x = statItems.Position{
                if x == "G"{
                    goalsLabel.text = "Saves"
                    assistsLabel.text = "Wins"
                    pointsLabel.text = "Losses"
                
                    plusMinusLabel.text = "S/against"
                    hitsLabel.text = "G/against"
                    penaltiesLabel.text = "Shutouts"
   
                    if let svs = self.statItems.GoaltendingSaves{
                        self.goals.text = "\(Int(svs))"
                    }
                    if let wins = self.statItems.GoaltendingWins{
                        self.assists.text = "\(Int(wins))"
                    }
                    if let lost = self.statItems.GoaltendingLosses{
                        self.points.text = "\(Int(lost))"
                    }
                    
                    if let so = statItems.GoaltendingShutouts{
                        self.penalties.text = "\(Int(so))"
                    }
                    if let sa = statItems.GoaltendingShotsAgainst{
                        self.plusMinus.text = "\(Int(sa))"
                    }
                    if let ga = statItems.GoaltendingGoalsAgainst{
                        self.hits.text = "\(Int(ga))"
                    }
    
                }
                
            }
            
            
        }

    }
    
    //request stats from player
 func requestStats(completion: @escaping (Stats?, Error?) -> Void){
        
        guard let url = URL(string: "https://api.sportsdata.io/v3/nhl/stats/json/PlayerSeasonStatsByPlayer/2021/\(id)?key=ec5135b9a9fa4c77b3bea367337399d6") else{
            completion(nil, NetworkError.couldNotParseUrl)
            return
        }
        let task = urlSession.dataTask(with: url){ data, response, error in
            if error != nil{
                completion(nil, error)
            }
            
            guard let responseData = data else{
                completion(nil, NetworkError.noResponseData)
            return}
            
            let decoder = JSONDecoder()
            
            do{
                let responseData = try decoder.decode(Stats.self, from: responseData)
                completion(responseData, nil)
            }catch{
                print(error)
                completion(nil, error)
            }
        }
        task.resume()
    }
    
}
