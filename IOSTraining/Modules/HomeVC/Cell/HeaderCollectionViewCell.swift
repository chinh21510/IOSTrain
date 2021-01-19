//
//  HeaderCollectionViewCell.swift
//  IOSTraining
//
//  Created by Chinh Dinh on 1/17/21.
//  Copyright © 2021 Chinh Dinh. All rights reserved.
//

import UIKit

class HeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupView(header: String, isSelect: Bool) {
        headerLabel.text = header
        if isSelect {
            headerLabel.textColor = UIColor.systemTeal
        } else {
            headerLabel.textColor = UIColor.darkText
        }
        lineView.isHidden = !isSelect
        lineView.backgroundColor = UIColor.systemTeal
    }

}
