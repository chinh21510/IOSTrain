//
//  ViewController.swift
//  IOSTraining
//
//  Created by Chinh Dinh on 1/4/21.
//  Copyright © 2021 Chinh Dinh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Nuke
import CoreData

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var appCollectionView: UICollectionView!
    @IBOutlet weak var changeDisplayButton: UIButton!
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var lineView: UIView!
    
    var currentIndex = 0
    var isHorizontal = true
    var allMovies = [[Movie]]()
    var listPopular = [Movie]()
    var listTopRated = [Movie]()
    var listUpComing = [Movie]()
    var listNowPlaying = [Movie]()
    var headerString = ["Movies", "Popular", "Top Rated", "Up Coming", "Now Playing"]
    var testView = UIView()
    var currentPage: Int = 1
    var movies: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataCoreData()
        configCollectionView()
        configHeaderCollec()
        getAllData()
        requestDataPopular()
        requestDataTopRated()
        requestDataUpComing()
        requestDataNowPlaying()
        testView.backgroundColor = UIColor.red
        changeDisplayButton.setImage(UIImage(named: "menuLine"), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func getDataCoreData() {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "MovieFavorite")
        
        //3
        do {
          movies = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func checkMovieFavorite(movie: Movie) {
        for index in 0..<movies.count {
            let data:[String: Any] = movies[index].dictionaryWithValues(forKeys: ["movieId"])
            if data["movieId"] as? Int ?? 0 == movie.id {
                movie.favoriteMovie = true
            }
        }
    }
    
    func configHeaderCollec() {
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        headerCollectionView.register(UINib(nibName: "HeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HeaderCollectionViewCell")
        setupUI(collecitonView: headerCollectionView)
    }
    
    private func configCollectionView() {
        appCollectionView.dataSource = self
        appCollectionView.delegate = self
        appCollectionView.register(UINib(nibName: "AppCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AppCollectionViewCell")
        appCollectionView.register(UINib(nibName: "AppRowCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AppRowCollectionViewCell")
        setupUI(collecitonView: appCollectionView)
    }
    
    func reloadDataCollection() {
        appCollectionView.reloadData()
        headerCollectionView.reloadData()
    }
    
    func setupUI(collecitonView: UICollectionView) {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collecitonView.collectionViewLayout = layout
        layout.scrollDirection = .horizontal
        collecitonView.setCollectionViewLayout(layout, animated: true)
    }
    
    @IBAction func changeDisplay(_ sender: Any) {
        isHorizontal.toggle()
        if changeDisplayButton.currentImage == UIImage(named: "menuLine") {
            changeDisplayButton.setImage(UIImage(named: "menu"), for: .normal)
        } else {
            changeDisplayButton.setImage(UIImage(named: "menuLine"), for: .normal)
        }
        appCollectionView.reloadData()
    }
    
    func didError() {
        let alert = UIAlertController(title: "Load data failed", message: "Can't get data from server, please try again later.", preferredStyle: .alert)
        let actionReload = UIAlertAction(title: "Reload", style: .cancel) { [weak self] (action)in
            self?.getAllData()
        }
        alert.addAction(actionReload)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

extension ViewController {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == appCollectionView {
            return CGSize(width: UIScreen.main.bounds.width, height: self.appCollectionView.frame.height)
        } else {
            let number: Int
            if allMovies.count > 0 {
                number = allMovies.count + 1
            } else {
                number = 1
            }
            return CGSize(width: UIScreen.main.bounds.width / CGFloat(number), height: self.headerCollectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let number: Int
        if allMovies.count > 0 {
            number = allMovies.count + 1
        } else {
            number = 1
        }
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == headerCollectionView {
            let cell = headerCollectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCollectionViewCell", for: indexPath)
            if let cell = cell as? HeaderCollectionViewCell {
                let title = headerString[indexPath.item]
                var isSelect = false
                if currentIndex == indexPath.item {
                    isSelect = true
                }
                cell.setupView(header: title, isSelect: isSelect)
            }
            return cell
        } else {
            if isHorizontal {
                let cell = appCollectionView.dequeueReusableCell(withReuseIdentifier: "AppCollectionViewCell", for: indexPath)
                if let cell = cell as? AppCollectionViewCell {
                    if currentIndex == 0 {
                        cell.setupView(allMovies: allMovies, listMovies: nil, index: currentIndex)
                    } else {
                        if indexPath.item == 1 {
                            cell.setupView(allMovies: nil, listMovies: listPopular, index: currentIndex)
                        } else if indexPath.item == 2 {
                            cell.setupView(allMovies: nil, listMovies: listTopRated, index: currentIndex)
                        } else if indexPath.item == 3 {
                            cell.setupView(allMovies: nil, listMovies: listUpComing, index: currentIndex)
                        } else {
                            cell.setupView(allMovies: nil, listMovies: listNowPlaying, index: currentIndex)
                        }
                    }
                    cell.delegate = self
                }
                return cell
            } else {
                let cell = appCollectionView.dequeueReusableCell(withReuseIdentifier: "AppRowCollectionViewCell", for: indexPath)
                if let cell = cell as? AppRowCollectionViewCell {
                    if currentIndex == 0 {
                        cell.setupView(allMovies: allMovies, listMovies: nil, index: currentIndex)
                    } else {
                        if indexPath.item == 1 {
                            cell.setupView(allMovies: nil, listMovies: listPopular, index: currentIndex)
                        } else if indexPath.item == 2 {
                            cell.setupView(allMovies: nil, listMovies: listTopRated, index: currentIndex)
                        } else if indexPath.item == 3 {
                            cell.setupView(allMovies: nil, listMovies: listUpComing, index: currentIndex)
                        } else {
                            cell.setupView(allMovies: nil, listMovies: listNowPlaying, index: currentIndex)
                        }
                    }
                    cell.delegate = self
                }
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == headerCollectionView {
            scrollToPage(index: indexPath.item, animated: false)
        }
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

extension ViewController {
    func getAllData() {
        let listUrl = [
            "http://api.themoviedb.org/3/movie/popular?api_key=d5b97a6fad46348136d87b78895a0c06&page=\(currentPage)",
            "http://api.themoviedb.org/3/movie/top_rated?api_key=d5b97a6fad46348136d87b78895a0c06&page=\(currentPage)",
            "http://api.themoviedb.org/3/movie/upcoming?api_key=d5b97a6fad46348136d87b78895a0c06&page=\(currentPage)",
            "http://api.themoviedb.org/3/movie/now_playing?api_key=d5b97a6fad46348136d87b78895a0c06&page=\(currentPage)"
        ]
        let group = DispatchGroup()
        for url in listUrl {
            group.enter()
            APIManager.requestAPI(api: url, method: .get, parameter: ["":""], token: "") { (json) in
                var movies = [Movie]()
                group.leave()
                if let data: JSON = json["results"] {
                    guard data.count != 0 else {
                        self.didError()
                        return
                    }
                    for i in 0..<data.count {
                        if let object: Movie = Movie(fromJson: data[i]) {
                            self.checkMovieFavorite(movie: object)
                            movies.append(object)
                        }
                    }
                }
                self.allMovies.append(movies)
            }
        }

        group.notify(queue: DispatchQueue.main) { [weak self] in
            self?.loadingView.stopAnimating()
            self?.setupData(list: self?.allMovies)
        }

    }
    
    func setupData(list: [[Movie]]?) {
        if let list = list {
            for item in 0..<list.count {
                if list[item].count == 0 {
                    allMovies.remove(at: item)
                    headerString.remove(at: item + 1)
                }
            }
        }
        AppContraints.shared.sectionTitle = headerString
        reloadDataCollection()
    }
//    
    func requestDataPopular() {
        APIManager.requestAPI(api: "http://api.themoviedb.org/3/movie/popular?api_key=d5b97a6fad46348136d87b78895a0c06&page=\(currentPage)", method: .get, parameter: ["":""], token: "") { (json) in
            let data: JSON = json["results"]
            for i in 0..<data.count {
                let object: Movie = Movie(fromJson: data[i])
                self.checkMovieFavorite(movie: object)
                self.listPopular.append(object)
            }
        }
    }
    
    func requestDataTopRated() {
        APIManager.requestAPI(api: "http://api.themoviedb.org/3/movie/top_rated?api_key=d5b97a6fad46348136d87b78895a0c06&page=\(currentPage)", method: .get, parameter: ["":""], token: "") { (json) in
            let data: JSON = json["results"]
            for i in 0..<data.count {
                let object: Movie = Movie(fromJson: data[i])
                self.checkMovieFavorite(movie: object)
                self.listTopRated.append(object)
            }
        }
    }
    
    func requestDataUpComing() {
        APIManager.requestAPI(api: "http://api.themoviedb.org/3/movie/upcoming?api_key=d5b97a6fad46348136d87b78895a0c06&page=\(currentPage)", method: .get, parameter: ["":""], token: "") { (json) in
            let data: JSON = json["results"]
            for i in 0..<data.count {
                let object: Movie = Movie(fromJson: data[i])
                self.checkMovieFavorite(movie: object)
                self.listUpComing.append(object)
            }
        }
    }
    
    func requestDataNowPlaying() {
        APIManager.requestAPI(api: "http://api.themoviedb.org/3/movie/now_playing?api_key=d5b97a6fad46348136d87b78895a0c06&page=\(currentPage)", method: .get, parameter: ["":""], token: "") { (json) in
            let data: JSON = json["results"]
            for i in 0..<data.count {
                let object: Movie = Movie(fromJson: data[i])
                self.checkMovieFavorite(movie: object)
                self.listNowPlaying.append(object)
            }
        }
    }
}

extension ViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let number = scrollView.contentOffset.x / scrollView.frame.width
        let index = Int(number.rounded())
        if currentIndex != index {
            currentIndex = index
            scrollToPage(index: currentIndex, animated: true)
        }
    }
    
    private func scrollToPage(index: Int, animated: Bool) {
        appCollectionView.setContentOffset(CGPoint(x: CGFloat(index)*appCollectionView.bounds.width, y: 0), animated: animated)
        reloadDataCollection()
    }
}

extension ViewController: AppCollectionViewCellDelegate, AppRowCollectionViewCellDelagate {
    
    func didSelectFavoriteItem(cell: AppCollectionViewCell, index: Int) {
        var indexPath = appCollectionView.indexPath(for: cell)
        if currentIndex != 0 {
            indexPath?.section = index
            appCollectionView.reloadData()
        } else {
           indexPath?.section = index
           appCollectionView.reloadData()
        }
    }
    
    func didSelectItem(index: Int) {
        scrollToPage(index: index, animated: false)
        currentIndex = index
    }
    
    func showDetail(movie: Movie) {
        let detailVC = MovieDetailViewController()
        detailVC.movieId = movie.id
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func didSelectFavoriteItemRow(cell: AppRowCollectionViewCell, index: Int) {
        var indexPath = appCollectionView.indexPath(for: cell)
        if currentIndex != 0 {
            indexPath?.section = index
            appCollectionView.reloadData()
        } else {
           indexPath?.section = index
           appCollectionView.reloadData()
        }
    }
   
}
