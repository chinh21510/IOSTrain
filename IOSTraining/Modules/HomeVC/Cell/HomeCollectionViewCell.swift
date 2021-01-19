//
//  HomeCollectionViewCell.swift
//  IOSTraining
//
//  Created by Chinh Dinh on 1/13/21.
//  Copyright © 2021 Chinh Dinh. All rights reserved.
//

import UIKit
import Nuke

protocol AddToFavoriteCollection: class {
    func addFavoriteItem(cell: HomeCollectionViewCell)
}

class HomeCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDurationLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var viewContents: UIView!
    
    var delegate: AddToFavoriteCollection?
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContents.roundCorner(cornerRadius: 8)
        viewContents.layer.masksToBounds = true
        // Initialization code
    }
    
    func setupView(movie: Movie) {
        movieTitleLabel.text = movie.title
        movieDurationLabel.text = movie.releaseDate
        movieImage.setImage(stringURL: movie.posterPath)
    }
    
    @IBAction func addFavorite(_ sender: Any) {
        self.delegate?.addFavoriteItem(cell: self)
    }
    
}
