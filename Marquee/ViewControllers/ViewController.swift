//
//  ViewController.swift
//  TVOS Test
//
//  Created by Josh  Bayless on 4/29/22.
//

import UIKit
import Kingfisher
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let jsonManager = JSONManager()
    var movies = [Movie]()
    var tvShows = [TVdata]()
    var comingSoon = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        profilePictureSetUp()
        fetchFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPopularMovies()
        getTVShows()
        getComingSoon()
        tableView.reloadData()
    }
    
    func profilePictureSetUp() {
        profilePicture.layer.cornerRadius = profilePicture.frame.size.height/2
        profilePicture.layer.masksToBounds = true
    }
}

//MARK: - Table View Methods
extension ViewController:UITableViewDelegate, UITableViewDataSource, CollectionViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Popular Movies"
        case 1:
            return "Popular TV Shows"
        case 2:
            return "Coming soon"
        default:
            return "Something went wrong"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        cell.collectionView.tag = indexPath.section
        switch indexPath.section {
        case 0:
            cell.movies = movies
        case 1:
            cell.tvShows = tvShows
        case 2:
            cell.movies = comingSoon
        default:
            print("Something went wrong")
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    func didSelectItem(_ selectedContent: Content) {
        if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
            detailVC.selectedContent = selectedContent
            self.present(detailVC, animated: true, completion: nil)
        }
    }
    
    //MARK: - Data Fetching Methods
    func getPopularMovies() {
        jsonManager.fetchPopularMovies { result in
            switch result {
            case let .success(movieData):
                self.movies = movieData.results
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func getTVShows() {
        jsonManager.fetchPopularTVShows { result in
            switch result {
            case let .success(movieData):
                self.tvShows = movieData.results
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func getComingSoon() {
        jsonManager.fetchComingSoon { result in
            switch result {
            case let .success(movieData):
                self.comingSoon = movieData.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    //MARK: - CoreData Methods
    func fetchFavorites() {
        do {
            FavoritesList.shared.list = try context.fetch(Favorites.fetchRequest())
        } catch {
            print(error)
        }
    }
    
    func updateFavorite(at selectedContent: Content) {
        
        let info = isFavorited(selectedContent)
        print(info)
        if info.0 {
            context.delete(FavoritesList.shared.list[info.1])
            do {
                try context.save()
                
            } catch {
                print(error)
            }
            fetchFavorites()
        } else {
            print("trying to create favorite")
            let newFavorite = Favorites(context: context)
            
            newFavorite.title = selectedContent.title
            newFavorite.overview = selectedContent.overview
            newFavorite.posterPath = selectedContent.posterPath
            newFavorite.releaseDate = selectedContent.releaseDate
            newFavorite.voteAverage = selectedContent.voteAverage
            print(newFavorite)
            do {
                try context.save()
                
            } catch {
                print(error)
            }
            fetchFavorites()
        }
    }
    
    func isFavorited(_ selectedContent: Content) -> (Bool,Int) {
        var index = 0
        for item in FavoritesList.shared.list {
            if item.title == selectedContent.title {
                return (true,index)
            }
            index += 1
        }
        return (false,0)
    }
}

