//
//  PlayerTableViewCell.swift
//  Hofer_Pro
//
//  Created by Fabian Hofer on 30.11.21.
//

import Foundation
import UIKit

class PlayerTableViewcell: UITableViewCell{
    
    @IBOutlet var picture: UIImageView!
    @IBOutlet var positionNR: UILabel!
    @IBOutlet var name: UILabel!
    
    let identifier = "PlayerIdentifier"
}
