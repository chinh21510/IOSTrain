//
//  MovieDetailViewController.swift
//  IOSTraining
//
//  Created by Chinh Dinh on 1/6/21.
//  Copyright © 2021 Chinh Dinh. All rights reserved.
//

import UIKit
import Alamofire
import Nuke
import SwiftyJSON



class MovieDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet var voteStars: [UIImageView]!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var similarMovieTableView: UITableView!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var similarLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var showMore: UIButton!
    
    
    var listGenres = [Genres]()
    var detailMovie: MovieDetail?
    var movieId = Int()
    var casts = [Cast]()
    var similarMovies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        requestAPIDetailMovie(movieId: movieId)
//        requestCastInfo(movieId: movieId)
//        requestSimilarMovie(movieId: movieId)
//        getDataGenres()
        requestData()
        castCollectionView.dataSource = self
        castCollectionView.delegate = self
        castCollectionView.register(UINib(nibName: "CastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CastCollectionViewCell")
        setupNavigationBarItem()
        setupUI()
    }
    
    private func setupNavigationBarItem() {
        navigationItem.title = "Movie Detail"
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.systemTeal
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scrollView.isHidden = true
        setupUICollectionView(collecitonView: castCollectionView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.isHidden = false
        setupView()
        similarMovieTableView.dataSource = self
        similarMovieTableView.delegate = self
        similarMovieTableView.register(UINib(nibName: "ResultMovieTableViewCell", bundle: nil), forCellReuseIdentifier: "ResultMovieTableViewCell")
    }
    
    func setupUI() {
        castLabel.addBorderBottom()
        similarLabel.addBorderBottom()
    }
    
    func setupView() {
        movieImage.setImage(stringURL: detailMovie?.posterPath)
        movieTitleLabel.text = detailMovie?.title
        if detailMovie?.genres.count ?? 0 >= 3 {
            genresLabel.text = "\(detailMovie?.genres[0].name ?? "") | \(detailMovie?.genres[1].name ?? "") | \(detailMovie?.genres[2].name ?? "")"
        } else if detailMovie?.genres.count == 2 {
            genresLabel.text = "\(detailMovie?.genres[0].name ?? "") | \(detailMovie?.genres[1].name ?? "")"
        } else if detailMovie?.genres.count == 1{
            genresLabel.text = "\(detailMovie?.genres[0].name ?? "")"
        } else {
            genresLabel.text = "Genres: No"
        }
        let voteRate: Int = Int(Int(detailMovie?.voteAverage ?? 0.0) / 2)
        if voteRate >= 1 {
            for index in 0..<voteRate {
                voteStars[index].image = UIImage(named: "starFull")
            }
        }
        languageLabel.text = "Language: \(detailMovie?.spokenLanguages[0].englishName ?? "English")"
        if let countries = detailMovie?.productionCountries, countries.count > 0 {
            durationLabel.text = "\(detailMovie?.releaseDate ?? "")  (\(countries[0].iso31661 ?? "US"))  \(detailMovie?.runtime ?? Int()) min"
            
        }
        descriptionTextView.text = "\(detailMovie?.overview ?? "")"
    }
    
    func setupUICollectionView(collecitonView: UICollectionView) {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 15
        collecitonView.collectionViewLayout = layout
        layout.scrollDirection = .horizontal
        collecitonView.setCollectionViewLayout(layout, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.castCollectionView.bounds.width) / 3.5, height: (self.castCollectionView.bounds.height) / 2.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if casts.count != 0 {
            return casts.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = castCollectionView.dequeueReusableCell(withReuseIdentifier: "CastCollectionViewCell", for: indexPath) as! CastCollectionViewCell
        let cast = casts[indexPath.item]
        cell.setupView(cast: cast)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if similarMovies.count != 0 {
            return similarMovies.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = similarMovieTableView.dequeueReusableCell(withIdentifier: "ResultMovieTableViewCell", for: indexPath) as! ResultMovieTableViewCell
        let movie = similarMovies[indexPath.row]
        cell.setupView(movie: movie, genres: listGenres)
        return cell
    }
    
    func getRowHeightFromText(strText : String!) -> CGFloat {
        let textView : UITextView! = UITextView(frame: CGRect(x:      self.descriptionTextView.frame.origin.x,
        y: 0,
        width: self.descriptionTextView.frame.size.width,
        height: 0))
        textView.text = strText
        textView.font = UIFont(name: "Fira Sans", size:  14.0)
        textView.sizeToFit()

        var txt_frame : CGRect! = CGRect()
        txt_frame = textView.frame

        var size : CGSize! = CGSize()
        size = txt_frame.size

        size.height = 50 + txt_frame.size.height
        return size.height
    }
    
    @IBAction func showMoreButtonClick(_ sender: UIButton) {
        if sender.tag == 0 {
            let height = self.getRowHeightFromText(strText: self.descriptionTextView.text)
            self.descriptionTextView.frame = CGRect(x: self.descriptionTextView.frame.origin.x, y: self.descriptionTextView.frame.origin.y, width: self.descriptionTextView.frame.size.width, height: height)
            
            showMore.setTitle("Less", for: .normal)
            sender.tag = 1
        } else{
            self.descriptionTextView.frame = CGRect(x: self.descriptionTextView.frame.origin.x, y: self.descriptionTextView.frame.origin.y, width: self.descriptionTextView.frame.size.width, height: 116)
            showMore.setTitle("More", for: .normal)
            sender.tag = 0
        }
    }
}

extension MovieDetailViewController {
    func reloadData() {
        similarMovieTableView.reloadData()
        castCollectionView.reloadData()
    }
    func requestData() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        APIManager.requestAPI(api: "http://api.themoviedb.org/3/movie/\(movieId)?api_key=d5b97a6fad46348136d87b78895a0c06", method: .get, parameter: ["":""], token: "") { (json) in
            dispatchGroup.leave()
            let data: JSON = json
            let object: MovieDetail = MovieDetail(fromJson: data)
            self.detailMovie = object
        }
        dispatchGroup.enter()
        APIManager.requestAPI(api: "http://api.themoviedb.org/3/movie/\(movieId)/credits?api_key=d5b97a6fad46348136d87b78895a0c06&page=1", method: .get, parameter: ["":""], token: "") { (json) in
            dispatchGroup.leave()
            let data: JSON = json["cast"]
            for i in 0..<data.count {
                let object: Cast = Cast(fromJson: data[i])
                self.casts.append(object)
            }
        }
        dispatchGroup.enter()
        APIManager.requestAPI(api: "http://api.themoviedb.org/3/movie/\(movieId)/similar?api_key=d5b97a6fad46348136d87b78895a0c06", method: .get, parameter: ["":""], token: "") { (json) in
            dispatchGroup.leave()
            let data: JSON = json["results"]
            for i in 0..<data.count {
                let object: Movie = Movie(fromJson: data[i])
                self.similarMovies.append(object)
            }
        }
        dispatchGroup.enter()
        APIManager.requestAPI(api: "https://api.themoviedb.org/3/genre/movie/list?api_key=d5b97a6fad46348136d87b78895a0c06&language=en-US", method: .get, parameter: ["":""], token: "") { (json) in
            dispatchGroup.leave()
            let data: JSON = json["genres"]
            for i in 0..<data.count {
                let object: Genres = Genres(fromJson: data[i])
                self.listGenres.append(object)
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            self?.reloadData()
        }
        
    }
    
}
