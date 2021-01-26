//
//  AppRowCollectionViewCell.swift
//  IOSTraining
//
//  Created by Chinh Dinh on 1/14/21.
//  Copyright © 2021 Chinh Dinh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol AppRowCollectionViewCellDelagate: class {
    func didSelectItem(index: Int)
    func showDetail(movie: Movie)
    func didSelectFavoriteItemRow(cell: AppRowCollectionViewCell, index: Int)
    
}

class AppRowCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var homeTableView: UITableView!
    
    var delegate: AppRowCollectionViewCellDelagate?
    var currentPage = 1
    var listMovies: [Movie]?
    var listAllMovies: [[Movie]]?
    
    var currentIndex: Int? {
        didSet {
            homeTableView.reloadData()
//            scrollToTop()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        homeTableView.dataSource = self
        homeTableView.delegate = self
        homeTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        homeTableView.register(UINib(nibName: "SectionTableView", bundle: nil), forHeaderFooterViewReuseIdentifier: "SectionTableView")
    }
    
    func setupView(allMovies: [[Movie]]?, listMovies: [Movie]?, index: Int) {
        listAllMovies = allMovies
        self.listMovies = listMovies
        currentIndex = index
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if currentIndex != 0 {
            return 1
        }
        return listAllMovies?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x:0, y:0, width: homeTableView.frame.width, height: 50))
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemGray5
        } else {
            view.backgroundColor = UIColor.lightGray
        }
        let labelHeader = UILabel(frame: CGRect(x:20, y:10, width: homeTableView.frame.width - 50, height: 30))
        labelHeader.font = labelHeader.font.withSize(17)
        if currentIndex == 0 {
            if let sectionTitle = AppContraints.shared.sectionTitle {
                labelHeader.text = sectionTitle[section+1]
            }
            let button = UIButton(frame: CGRect(x: view.bounds.width - 80, y: 10, width: 80, height: 30))  // create button
            button.tag = section
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            view.addSubview(button)
            
            let seeAll = UILabel(frame: CGRect(x: view.bounds.width - 80, y: 10, width: 60, height: 30))
            seeAll.font = labelHeader.font.withSize(17)
            seeAll.text = "See All"
            view.addSubview(seeAll)
            
            let imageView = UIImageView(frame: CGRect(x: view.bounds.width - 20, y: 17.5, width: 15, height: 15))
            imageView.image = UIImage(named: "seeAll")
            view.addSubview(imageView)
        }
        view.addSubview(labelHeader)
        return view
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        pushToMoviesVC(section: sender.tag + 1)
    }
    
    private func pushToMoviesVC(section: Int) {
        currentIndex = section
        delegate?.didSelectItem(index: section)
        self.homeTableView.reloadData()
    }
    
    private func scrollToTop() {
        let topRow = IndexPath(row: 0,
                               section: 0)
                               
        self.homeTableView.scrollToRow(at: topRow,
                                   at: .top,
                                   animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if currentIndex != 0 {
            return CGFloat.leastNormalMagnitude
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath)
        
        if currentIndex != 0 {
            if let cell = cell as? HomeTableViewCell, let movie = listMovies?[indexPath.item] {
                cell.setupView(movie: movie)
                cell.delegate = self
            }
        } else {
            let number = indexPath.section
            if let cell = cell as? HomeTableViewCell, let movie = listAllMovies?[number][indexPath.item] {
                cell.setupView(movie: movie)
                cell.delegate = self
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
}

extension AppRowCollectionViewCell: AddToFavoriteTable {
    func addFavoriteItem(cell: HomeTableViewCell) {
        let indexPath = homeTableView.indexPath(for: cell)
        delegate?.didSelectFavoriteItemRow(cell: self, index: indexPath?.row ?? 0)
        homeTableView.reloadData()
    }
}
