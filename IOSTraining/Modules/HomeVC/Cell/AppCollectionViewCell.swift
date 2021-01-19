//
//  AppCollectionViewCell.swift
//  IOSTraining
//
//  Created by Chinh Dinh on 1/13/21.
//  Copyright © 2021 Chinh Dinh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol AppCollectionViewCellDelegate: class {
    func didSelectItem(index: Int)
    func didSelectFavoriteItem(cell: AppCollectionViewCell, section: Int)
    func showDetail(movie: Movie)
    func didError()
}


class AppCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    weak var delegate: AppCollectionViewCellDelegate?
    
    var listMovies: [Movie]?
    var listAllMovies: [[Movie]]?
    
    var currentIndex: Int? {
        didSet {
            self.homeCollectionView.reloadData()
            self.homeCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0),
                                                 at: .centeredHorizontally,
                                                 animated: false)
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        homeCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        self.homeCollectionView.register(UINib(nibName: "Section", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Section")
    }
    
    func setupView(allMovies: [[Movie]]?,listMovies: [Movie]?, index: Int) {
        listAllMovies = allMovies
        self.listMovies = listMovies
        currentIndex = index
    }
    
    func getNumberOfSection(list: [[Movie]]?) -> Int {
        if let list = list, list.count > 1 {
            return list.count
        }
        return 1
    }
    
    func getNumberOfRow(list: [Movie]?) -> Int{
        if let list = list {
            if list.count > 4 {
                return 4
            }
            return list.count
        }
        return 0
    }
}

extension AppCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if currentIndex == 0 {
            return listAllMovies?.count ?? 1
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if currentIndex != 0 {
            return listMovies?.count ?? 0
        } else {
            if let list = listAllMovies {
                for item in 0..<list.count {
                    if section == item {
                        if list[item].count > 4 {
                            return 4
                        }
                        return list[item].count
                    }
                }
            }
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath)
        if currentIndex != 0 {
            if let cell = cell as? HomeCollectionViewCell, let movie = listMovies?[indexPath.item] {
                cell.setupView(movie: movie)
            }
        } else {
            let number = indexPath.section
            if let cell = cell as? HomeCollectionViewCell, let movie = listAllMovies?[number][indexPath.item] {
                cell.setupView(movie: movie)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie: Movie?
        if currentIndex != 0 {
            movie = listMovies?[indexPath.item]
        } else {
            movie = listAllMovies?[indexPath.section][indexPath.item]
        }
        if let movie = movie {
            delegate?.showDetail(movie: movie)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let header = homeCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Section", for: indexPath)
        if let header = header as? Section {
            header.setupView(section: indexPath.section + 1)
            header.delegate = self
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        if currentIndex != 0 {
            return CGSize(width: homeCollectionView.bounds.width, height: 0)
        }
        return CGSize(width: homeCollectionView.bounds.width, height: 48)
    }
    
    
}

extension AppCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 2, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension AppCollectionViewCell: SeeAllMovieCategoryDelegate {
    func seeAllMovieCategory(section: Int) {
        currentIndex = section
        delegate?.didSelectItem(index: section)
    }
}
