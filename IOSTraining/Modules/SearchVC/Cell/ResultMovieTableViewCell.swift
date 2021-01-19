//
//  ResultMovieTableViewCell.swift
//  IOSTraining
//
//  Created by Chinh Dinh on 1/15/21.
//  Copyright © 2021 Chinh Dinh. All rights reserved.
//

import UIKit

class ResultMovieTableViewCell: UITableViewCell {

    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var genresNameLabel: UILabel!
    @IBOutlet weak var contenView: UIView!
    @IBOutlet var voteStars: [UIImageView]!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contenView.roundCorner(cornerRadius: 8)
        contenView.layer.masksToBounds = true
    }
    
    func setupView(movie: Movie, genres: [Genres]) {
        movieTitleLabel.text = movie.title
        movieImage.setBanner(stringURL: movie.backdropPath)
        let genreName: [String] = getGenreName(movie: movie, genres: genres)
        if genreName.count >= 3 {
            genresNameLabel.text = "\(genreName[0]) | \(genreName[1]) | \(genreName[2])"
        } else if genreName.count == 2 {
            genresNameLabel.text = "\(genreName[0]) | \(genreName[1])"
        } else if genreName.count == 1 {
            genresNameLabel.text = "\(genreName[0])"
        } else {
            genresNameLabel.text = ""
        }
        let voteRate: Int = Int(movie.voteAverage / 2)
//        print(voteStars.count)
        if voteRate >= 1 {
            for index in 0..<voteRate {
                voteStars[index].image = UIImage(named: "starFull")
            }
        }
        
    }
    
    func getGenreName(movie: Movie, genres: [Genres]) -> [String] {
        var genreName = [String]()
        for number in movie.genreIds {
            for genre in genres {
                if number == genre.id {
                    genreName.append(genre.name)
                }
            }
        }
        return genreName
    }
    
}

