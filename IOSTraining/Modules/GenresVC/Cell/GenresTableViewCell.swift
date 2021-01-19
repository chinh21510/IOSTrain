//
//  GenresTableViewCell.swift
//  IOSTraining
//
//  Created by Chinh Dinh on 1/16/21.
//  Copyright © 2021 Chinh Dinh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Nuke

class GenresTableViewCell: UITableViewCell {

    @IBOutlet weak var genreTitleLabel: UILabel!
    @IBOutlet weak var genreImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupView(genres: Genres) {
        genreTitleLabel.text = genres.name
        genreImage.setBanner(stringURL: genres.image)
    }
    
}
