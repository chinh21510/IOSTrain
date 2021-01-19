//
//  GenresViewController.swift
//  IOSTraining
//
//  Created by Chinh Dinh on 1/16/21.
//  Copyright © 2021 Chinh Dinh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Nuke

class GenresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var genresTableView: UITableView!
    
    var listGenres = [Genres]()
    var listMovieAllGenres = [[Movie]]()
    var listMovieGenres = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataGenres()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        genresTableView.dataSource = self
        genresTableView.delegate = self
        genresTableView.register(UINib(nibName: "GenresTableViewCell", bundle: nil), forCellReuseIdentifier: "GenresTableViewCell")
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listGenres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = genresTableView.dequeueReusableCell(withIdentifier: "GenresTableViewCell", for: indexPath) as! GenresTableViewCell
        let genres = listGenres[indexPath.row]
        cell.setupView(genres: genres)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let genres = listGenres[indexPath.row]
        let detailGenresVC = ListMovieGenresViewController(nibName: "ListMovieGenresViewController", bundle: nil)
        detailGenresVC.genresId = genres.id
        detailGenresVC.genresName = genres.name
        self.navigationController?.pushViewController(detailGenresVC, animated: true)
        
    }
        
    func getDataGenres() {
        let group = DispatchGroup()
            APIManager.requestAPI(api: "https://api.themoviedb.org/3/genre/movie/list?api_key=d5b97a6fad46348136d87b78895a0c06&language=en-US", method: .get, parameter: ["":""], token: "") { (json) in
                let data: JSON = json["genres"]
                for i in 0..<data.count {
                    let object: Genres = Genres(fromJson: data[i])
                    self.listGenres.append(object)
                }
                for genres in self.listGenres {
                    group.enter()
                    APIManager.requestAPI(api: "https://api.themoviedb.org/3/discover/movie?api_key=d5b97a6fad46348136d87b78895a0c06&language=en-US&genre=\(genres.id ?? 0)", method: .get, parameter: ["":""], token: "") { (json) in
                        group.leave()
                        let number = Int.random(in: 0..<json["results"].count)
                        let data: JSON = json["results"][number]
                        let backdropPath = data["backdrop_path"].stringValue
                        genres.image = backdropPath
                    }
                }
                group.notify(queue: .main) {
                    self.genresTableView.reloadData()
                }
            }
        
    }
    
}
