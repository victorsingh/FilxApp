//
//  NowPlayingViewController.swift
//  FlixApp
//
//  Created by Victor Singh on 9/4/18.
//  Copyright © 2018 victor. All rights reserved.
//

import UIKit
import AlamofireImage

class NowPlayingViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    var isLoading: Bool = false
    var movies: [[String: Any]] = []
    var currentMovies: [[String: Any]] = []
    var refreshControl: UIRefreshControl!
    let alertController = UIAlertController(title: "Cannot Get Movies", message: "The internet Connection Appearss to be offline", preferredStyle: .alert)
    // create a cancel action

    override func viewDidLoad() {
        super.viewDidLoad()
        let retryAction = UIAlertAction(title: "Retry", style: .cancel) { (action) in
            // handle retry response here. Doing nothing will dismiss the view.
            self.fetchMovies()
        }
        alertController.addAction(retryAction)

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector (NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        tableView.dataSource = self
        activityIndicator.startAnimating()
        self.isLoading = true
        fetchMovies()
        // Do any additional setup after loading the view.
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
    }
    
    @objc func didPullToRefresh (_ refreshControl: UIRefreshControl){
        fetchMovies()
    }
    
    func fetchMovies() {

        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")! //! is used to unwrapthis if you dont get a proper response
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main )
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                self.present(self.alertController, animated: true) {
                    // optional code for what happens after the alert controller has finished presenting
                }
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                print(dataDictionary)
                let movies = dataDictionary["results"] as! [[String: Any]]
                self.movies = movies
                self.currentMovies = movies

                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            
                if(self.isLoading == true) {
                    self.activityIndicator.stopAnimating()
                    self.isLoading = false
                }
            }
        }

        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentMovies.count
    }
    
    func searchBar (_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentMovies = movies.filter ({ (movie: [String: Any]) -> Bool in
            guard let text = searchBar.text else { return false }
            let movieString = movie["title"] as! String
            return searchText.isEmpty ? (movie["title"] != nil) : movieString.range(of: text, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCellTableViewCell
        let movie = currentMovies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        let posterPathString = movie["poster_path"] as! String
        let baseURLString = "https://image.tmdb.org/t/p/w500"
        
        let posterURL = URL(string: baseURLString + posterPathString)!
        cell.posterImageView.af_setImage(withURL: posterURL)
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
