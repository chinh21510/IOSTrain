//
//  CastCollectionViewCell.swift
//  IOSTraining
//
//  Created by Chinh Dinh on 1/16/21.
//  Copyright © 2021 Chinh Dinh. All rights reserved.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var castImage: UIImageView!
    @IBOutlet weak var castNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.roundCorner(cornerRadius: 6)
    }
    
    func setupView(cast: Cast) {
        castImage.setProfile(stringURL: cast.profilePath)
        castNameLabel.text = cast.name
    }

}
