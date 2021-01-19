//
//  Section.swift
//  IOSTraining
//
//  Created by Chinh Dinh on 1/13/21.
//  Copyright © 2021 Chinh Dinh. All rights reserved.
//

import UIKit

protocol SeeAllMovieCategoryDelegate {
    func seeAllMovieCategory(section: Int)
}

class Section: UICollectionReusableView {

    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var seeAllButton: UIButton!
    
    var delegate: SeeAllMovieCategoryDelegate?
    var section: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupView(section: Int) {
        self.section = section
        if let sectionTitle = AppContraints.shared.sectionTitle {
            categoryTitleLabel.text = sectionTitle[section]
        }
    }
    
    @IBAction func seeAllMovie(_ sender: Any) {
        guard let section = section else { return }
        self.delegate?.seeAllMovieCategory(section: section)
    }
    
}
