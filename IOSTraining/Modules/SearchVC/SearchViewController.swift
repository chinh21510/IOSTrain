//
//  SearchViewController.swift
//  IOSTraining
//
//  Created by Chinh Dinh on 1/15/21.
//  Copyright © 2021 Chinh Dinh. All rights reserved.
//

import UIKit
import Alamofire
import Nuke
import SwiftyJSON

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    
    var listGenres: [Genres] = [Genres]()
    var listMovieResult = [Movie]()
    var textSearch = String()
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        resultTableView.dataSource = self
        resultTableView.delegate = self
        resultTableView.register(UINib(nibName: "ResultMovieTableViewCell", bundle: nil), forCellReuseIdentifier: "ResultMovieTableViewCell")
        searchTextField.delegate = self
        addTapGEstureInView()
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        view.endEditing(true)
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDataGenres()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupUI() {
        searchView.layer.borderWidth = 0.5
        searchView.layer.borderColor = UIColor.lightGray.cgColor
        searchView.layer.cornerRadius = 8
    }
    
    
    @IBAction func cancelText(_ sender: Any) {
        searchTextField.text = ""
        resultTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMovieResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultTableView.dequeueReusableCell(withIdentifier: "ResultMovieTableViewCell", for: indexPath) as! ResultMovieTableViewCell
        let movie = listMovieResult[indexPath.row]
        cell.setupView(movie: movie, genres: listGenres)
        if indexPath.item == (20 * currentPage) - 1 {
            currentPage = currentPage + 1
            resultMovieSearch(string: textSearch)
            resultTableView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = listMovieResult[indexPath.row]
        let movieDetailVC = MovieDetailViewController(nibName: "MovieDetailViewController", bundle: nil)
        movieDetailVC.movieId = movie.id
        self.navigationController?.pushViewController(movieDetailVC, animated: true)
    }
    
    func resultMovieSearch(string: String) {
        let queue = DispatchQueue.init(label: "search", attributes: .concurrent)
        listMovieResult = []
        queue.sync {
            APIManager.requestAPI(api: "http://api.themoviedb.org/3/search/movie?api_key=d5b97a6fad46348136d87b78895a0c06&query=\(string)&page=\(currentPage)", method: .get, parameter: ["":""], token: "") { (json) in
                let data: JSON = json["results"]
                for i in 0..<data.count {
                    let object: Movie = Movie(fromJson: data[i])
                    self.listMovieResult.append(object)
                }
                DispatchQueue.main.async {
                    self.resultTableView.reloadData()
                }
            }
        }
    }
}

extension SearchViewController {
    func getDataGenres() {
        APIManager.requestAPI(api: "https://api.themoviedb.org/3/genre/movie/list?api_key=d5b97a6fad46348136d87b78895a0c06&language=en-US", method: .get, parameter: ["":""], token: "") { (json) in
            let data: JSON = json["genres"]
            for i in 0..<data.count {
                let object: Genres = Genres(fromJson: data[i])
                self.listGenres.append(object)
            }
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(self.reload(_:)),
                                               object: textField)
        perform(#selector(self.reload(_:)),
                with: textField, afterDelay: 1)
    }
    
    @objc func reload(_ textField: UITextField) {
        guard let query = textField.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            print("nothing to search")
            return
        }
        print(query)
        // Todo call Api
        resultMovieSearch(string: query)
    }
}

extension SearchViewController {
    func addTapGEstureInView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapView))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func tapView() {
        view.endEditing(true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
