//
//  HomeTableViewCell.swift
//  IOSTraining
//
//  Created by Chinh Dinh on 1/14/21.
//  Copyright © 2021 Chinh Dinh. All rights reserved.
//

import UIKit
import Nuke
import CoreData
protocol AddToFavoriteTable: class {
    func addFavoriteItem(cell: HomeTableViewCell)
}

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDurationLabel: UILabel!
    @IBOutlet weak var movieOverViewLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    var movies: [NSManagedObject] = []
    var delegate: AddToFavoriteTable?
    var movie: Movie?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImage.roundCorner(cornerRadius: 4)
    }
    
    func setupView(movie: Movie) {
        movieImage.setImage(stringURL: movie.posterPath)
        movieTitleLabel.text = movie.title
        movieOverViewLabel.text = movie.overview
        movie.checkFavorite(button: favoriteButton)
    }
    
    @IBAction func addFavorite(_ sender: Any) {
        self.delegate?.addFavoriteItem(cell: self)
        self.save(movieId: movie?.id ?? 2, movies: movies)
        if movie?.favoriteMovie == false {
            movie?.favoriteMovie = true
        }
    }
}
