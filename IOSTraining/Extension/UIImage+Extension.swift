//
//  UIImage+Extension.swift
//  IOSTraining
//
//  Created by Chinh Dinh on 1/5/21.
//  Copyright © 2021 Chinh Dinh. All rights reserved.
//

import UIKit
import Nuke

extension UIImageView {
    func setImage(stringURL: String?) {
        if let stringURL = stringURL,
            let url = URL(string: "http://image.tmdb.org/t/p/w500/\(stringURL)") {
            Nuke.loadImage(with: url, into: self)
        }
    }
    
    func setBanner(stringURL: String?) {
        if let stringURL = stringURL,
            let url = URL(string: "http://image.tmdb.org/t/p/w780/\(stringURL)") {
            Nuke.loadImage(with: url, into: self)
        }
    }
    
    func setProfile(stringURL: String?) {
        if let stringURL = stringURL,
            let url = URL(string: "http://image.tmdb.org/t/p/h632/\(stringURL)") {
            Nuke.loadImage(with: url, into: self)
        }
    }
}



extension UILabel {
    func addBorderBottom() {
        let lineView = UIView(frame: CGRect(x: 0,
                                            y: self.frame.height - 3,
                                            width: self.frame.width,
                                            height: 3.0))

        lineView.backgroundColor = UIColor.systemTeal
        self.addSubview(lineView)
    }
    
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText

        let lengthForVisibleString: Int = self.vissibleTextLength
        let mutableString: String = self.text!
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
        let readMoreLength: Int = (readMoreText.count)
        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }

    var vissibleTextLength: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)

        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)

        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
    
}
