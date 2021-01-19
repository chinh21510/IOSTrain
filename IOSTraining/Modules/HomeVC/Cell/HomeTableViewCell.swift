//
//  HomeTableViewCell.swift
//  IOSTraining
//
//  Created by Chinh Dinh on 1/14/21.
//  Copyright © 2021 Chinh Dinh. All rights reserved.
//

import UIKit
import Nuke

protocol AddToFavoriteTable: class {
    func addFavoriteItem(cell: HomeTableViewCell)
}

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDurationLabel: UILabel!
    @IBOutlet weak var movieOverViewLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var delegate: AddToFavoriteTable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImage.roundCorner(cornerRadius: 4)
    }
    
    func setupView(movie: Movie) {
        movieImage.setImage(stringURL: movie.posterPath)
        movieTitleLabel.text = movie.title
        movieOverViewLabel.text = movie.overview
    }
    
    @IBAction func addFavorite(_ sender: Any) {
        self.delegate?.addFavoriteItem(cell: self)
    }
}
