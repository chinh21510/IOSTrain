//
//  ListMovieGenresViewController.swift
//  IOSTraining
//
//  Created by Chinh Dinh on 1/18/21.
//  Copyright © 2021 Chinh Dinh. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ListMovieGenresViewController: UIViewController {

    @IBOutlet weak var listMovieGenresTableView: UITableView!
    
    var genresId = Int()
    var listMovies = [Movie]()
    var genresName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData(genresId: genresId)
        configTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        setupNavigation()
    }
    
    func setupNavigation() {
        navigationItem.title = "\(genresName)"
    }
    
    func configTableView() {
        listMovieGenresTableView.dataSource = self
        listMovieGenresTableView.delegate = self
        listMovieGenresTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
    }
}

extension ListMovieGenresViewController {
    func getData(genresId: Int) {
        APIManager.requestAPI(api: "https://api.themoviedb.org/3/discover/movie?api_key=d5b97a6fad46348136d87b78895a0c06&language=en-US&genre=\(genresId)", method: .get, parameter: ["":""], token: "") { (json) in
            let data: JSON = json["results"]
            for i in 0..<data.count {
                let object: Movie = Movie(fromJson: data[i])
                self.listMovies.append(object)
            }
            DispatchQueue.main.async {
                self.listMovieGenresTableView.reloadData()
            }
        }
    }
}

extension ListMovieGenresViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listMovies.count != 0 {
            return listMovies.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listMovieGenresTableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath)
        if let cell = cell as? HomeTableViewCell {
            let movie = listMovies[indexPath.row]
            cell.setupView(movie: movie)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
