//
//  TeamsTableViewController.swift
//  Hofer_Pro
//
//  Created by Fabian Hofer on 29.11.21.
//

import UIKit
import Kingfisher

class TeamsTableViewController: UITableViewController {
    
    enum NetworkError: Error{
        case couldNotParseUrl
        case noResponseData
    }
    private var teamData: Data = Data.init()
    let activityIndicatorView = UIActivityIndicatorView()
    let cellIdentifier = "TeamIdentifier"
    private let urlSession = URLSession.shared
    private var teamsItems: TeamItem = TeamItem()
    private var logoData: Data = Data.init()
    var logoUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicatorView.startAnimating()
        
        requestTeams(completion: { [weak self] teamItem, error in
           print(error)
            guard let item = teamItem else{ return}
//            print(item)
            
            self?.teamsItems.array = item
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.activityIndicatorView.stopAnimating()

            }
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamsItems.array.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TeamTableViewCell else {
            fatalError("Could not find a team")        }
        
        let teamItem = teamsItems.array[indexPath.row]
        cell.teamName.text = "\(teamItem.City) \(teamItem.Name)"
        
        let finalUrl = getPicture(indexPathRow: indexPath.row, itemUrl: teamItem.WikipediaLogoUrl)
        
        if let picUrl = URL(string: finalUrl){
            cell.teamLogo.kf.setImage(with: picUrl)
            teamsItems.array[indexPath.row].WikipediaLogoUrl = finalUrl
        }
        
 
        return cell
    }
    
    // loads team logo
    func loadImage(picUrl: String){
        
        guard let url  = URL(string: picUrl) else{
            return
        }
        guard let data = try? Data(contentsOf: url) else{
            return
        }
        logoData = data
        return
    }
    
    
    // url needs to be changed because api delivers only partly correct urls
    func getPicture(indexPathRow: Int, itemUrl: String?)->String{
        guard let url = itemUrl else{
            logoUrl = "https://www.pngall.com/wp-content/uploads/2/NHL-PNG-File.png"
            return "https://www.pngall.com/wp-content/uploads/2/NHL-PNG-File.png"
        }
        
        var team = teamsItems.array[indexPathRow]
        let city = team.City
        let name = team.Name
        
        
        
        // the api url for the picture is different to the other urls -> external link is necessary
        if team.TeamID == 15{
            logoUrl = "https://1000logos.net/wp-content/uploads/2018/06/Washington-Capitals-Logo.png"
            team.WikipediaLogoUrl = logoUrl
            return "https://1000logos.net/wp-content/uploads/2018/06/Washington-Capitals-Logo.png"
        }
        if team.TeamID == 12{
            logoUrl = "https://1000logos.net/wp-content/uploads/2018/06/New-York-Rangers-Logo.png"
            team.WikipediaLogoUrl = logoUrl

            return "https://1000logos.net/wp-content/uploads/2018/06/New-York-Rangers-Logo.png"
        }
        if team.TeamID == 4{
            logoUrl = "https://1000logos.net/wp-content/uploads/2018/06/Montreal-Canadiens-Logo.png"
            team.WikipediaLogoUrl = logoUrl
            return "https://1000logos.net/wp-content/uploads/2018/06/Montreal-Canadiens-Logo.png"
        }
        
//        // all star teams
//        if team.TeamID == 31 || team.TeamID == 32 || team.TeamID == 33 || team.TeamID == 34{
//            return "https://www.pngall.com/wp-content/uploads/2/NHL-PNG-File.png"
//        }
    
        
        let cityParts = city.components(separatedBy: " ")
      
        // if name contains of 2 words, e.g "New York"
        var cityString: String = city
        if cityParts.count == 2{
            cityString = "\(cityParts[0])_\(cityParts[1])"
        }
        let nameParts = name.components(separatedBy: " ")

        var nameString: String = name
        
        if nameParts.count == 2{
            nameString = "\(nameParts[0])_\(nameParts[1])"
        }
        
        let id = team.TeamID
        
//        api delivers already correct image for those 2 images
        if id == 26 || id == 28{
            return url
        }
  
        if let url: String = team.WikipediaLogoUrl{

            let addOn: String = "/800px-\(cityString)_\(nameString)_logo.svg.png"
            let urlParts = url.components(separatedBy: "/en")
//            print(urlParts)

            let string: String = urlParts[0] + "/en/thumb" + urlParts[1] + addOn
           // print(string)
            return string
        }
        logoUrl = "https://upload.wikimedia.org/wikipedia/de/1/19/Logo-NHL.svg"
        team.WikipediaLogoUrl = logoUrl

        return "https://upload.wikimedia.org/wikipedia/de/1/19/Logo-NHL.svg"
        

        
    }
    
    
    // get team
    private func requestTeams(completion: @escaping ([Team]?, Error?) -> Void) {
        
        guard let url = URL(string: "https://api.sportsdata.io/v3/nhl/scores/json/AllTeams?key=ec5135b9a9fa4c77b3bea367337399d6") else {
            completion(nil, NetworkError.couldNotParseUrl)
            return
        }
//        print(url)
        let task = urlSession.dataTask(with: url){ data, response, error in
            if error != nil{
                completion(nil, error)
            }
            
            guard let responseData = data else{
                completion(nil, NetworkError.noResponseData)
                return}
            
            let decoder = JSONDecoder()
            
            do{
                let responseData = try decoder.decode([Team].self, from: responseData)
                completion(responseData, nil)
                
            } catch{
                print(error)
                completion(nil, error)
            }
            
            
            
        }
        task.resume()
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
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
    
    
    // send code variable of selceted currency
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPlayers",
           let newController = segue.destination as? PlayerTableViewController,
           let cell = sender as? TeamTableViewCell,
           let indexPath = tableView.indexPath(for: cell){
            
            let teamCode = teamsItems.array[indexPath.row].Key
            newController.prevKey = teamCode
            newController.teamImageUrl = teamsItems.array[indexPath.row].WikipediaLogoUrl
            newController.teamName = "\(teamsItems.array[indexPath.row].City) \(teamsItems.array[indexPath.row].Name)"
            
          
            
        }
        
        
    }
}

