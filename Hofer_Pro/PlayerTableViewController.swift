//
//  PlayerTableViewController.swift
//  Hofer_Pro
//
//  Created by Fabian Hofer on 30.11.21.
//

import UIKit
import AVFoundation
import SwiftUI

class PlayerTableViewController: UITableViewController {
    
    enum NetworkError: Error{
        case couldNotParseUrl
        case noResponseData
    }
    private var playerItems: PlayerItem = PlayerItem()
    var prevKey: String?
    var teamName: String?
    let activityIndicatorView = UIActivityIndicatorView()

    
//    variables for next view
    var porträtImage: UIImageView?
    var teamImageUrl: String?
    var positionNrString: String = ""
    let cellidentifier = "PlayerIdentifier"
    private let urlSession = URLSession.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicatorView.startAnimating()
            
        
        if let title = teamName{
            self.navigationItem.title = title
        }
    
        requestPlayers(completion: { [weak self] playerItem, error in
            print(error)
            guard let item = playerItem else{ return}
//            print(item)
            
            self?.playerItems.array = item
        
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.activityIndicatorView.stopAnimating()

            }
        })
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellidentifier, for: indexPath) as? PlayerTableViewcell else{
            fatalError("Could not find a player")        }
        
        let playerItem = playerItems.array[indexPath.row]
        cell.name.text = "\(playerItem.FirstName) \(playerItem.LastName)"
        
        var position = playerItem.Position
        var posString = ""
        if position == "D"{
            posString = "Defenceman"
        }
        if position == "C"{
            posString = "Center"
        }
        if position == "LW"{
            posString = "Left Wing"
        }
        if position == "RW"{
            posString = "Right Wing"
        }
        if position == "G"{
            posString = "Goaltender"
        }
        var jersey: Int
        if let jerseyNR = playerItem.Jersey{
            jersey = jerseyNR
        } else{
            jersey = 00
        }
        
        
        cell.positionNR.text = "\(posString), #\(jersey)"
        positionNrString = "\(posString), #\(jersey)"
        
        if let picUrl = URL(string: playerItem.PhotoUrl ?? "https://logodownload.org/wp-content/uploads/2021/06/nhl-logo-0.png"){
            cell.picture.kf.setImage(with: picUrl)
        }
        porträtImage = cell.picture
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerItems.array.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    // get team
    private func requestPlayers(completion: @escaping ([Player]?, Error?) -> Void) {
        if let key = prevKey{
            
            guard let url = URL(string: "https://api.sportsdata.io/v3/nhl/scores/json/Players/\(key)?key=ec5135b9a9fa4c77b3bea367337399d6") else {
               
                completion(nil, NetworkError.couldNotParseUrl)
                return
            }
//            print(url)
            let task = urlSession.dataTask(with: url){ data, response, error in
                if error != nil{
                    completion(nil, error)
                }
                
                guard let responseData = data else{
                    completion(nil, NetworkError.noResponseData)
                    return}
                
                let decoder = JSONDecoder()
                
                do{
                    let responseData = try decoder.decode([Player].self, from: responseData)
                    completion(responseData, nil)
                    
                } catch{
                    print(error)
                    completion(nil, error)
                }
                
                
                
            }
            task.resume()
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowStats",
           let newController = segue.destination as? StatsViewController,
           let cell = sender as? PlayerTableViewcell,
           let indexPath = tableView.indexPath(for: cell){
            
            
            let player = playerItems.array[indexPath.row]
            newController.teamNameString = teamName
            newController.firstNameString = player.FirstName
            newController.lastNameString = player.LastName
            newController.clubImageUrl = teamImageUrl
            newController.playerID = player.PlayerID
            newController.shootsString = player.Shoots
            
            // position and number string
            var position = player.Position
            var posString = ""
            if position == "D"{
                posString = "Defenceman"
            }
            if position == "C"{
                posString = "Center"
            }
            if position == "LW"{
                posString = "Left Wing"
            }
            if position == "RW"{
                posString = "Right Wing"
            }
            if position == "G"{
                posString = "Goaltender"
            }
            var jersey: Int
            if let jerseyNR = player.Jersey{
                jersey = jerseyNR
            } else{
                jersey = 00
            }
            
            newController.positionNRString = "\(posString), #\(jersey)"
            
            //porträt
            if let url = player.PhotoUrl{
                newController.porträtImageUrl = url
            }
            
            

            
            
        }
        
        
    }
    
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
}
