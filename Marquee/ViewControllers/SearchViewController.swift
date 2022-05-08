//
//  SearchViewController.swift
//  TVOS Test
//
//  Created by Josh  Bayless on 5/1/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var searchWelcomeMessage: UILabel!
    
    let viewController = ViewController()
    let jsonManager = JSONManager()
    var searchData: [SearchObject]? {
        didSet {
            DispatchQueue.main.async {
                self.searchCollectionView.reloadData()
            }
            
        }}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCollectionView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.identifier)
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.backgroundColor = .darkGray
        searchCollectionView.layer.cornerRadius = 20
        
        profilePictureSetUp()
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        if searchTextField.hasText {
        if let searchedText = searchTextField.text {
            getSearchResults(for: searchedText)
            searchTextField.text = ""
        }}
    }
    
    func getSearchResults(for searchedText: String) {
        jsonManager.fetchSearchData(for: searchedText) { result in
            switch result {
            case let .success(movieData):
                self.searchData = movieData.results
            case let .failure(error):
                print(error)
            }
        }
    }
    
    
    
    func profilePictureSetUp() {
        
        profilePicture.layer.cornerRadius = profilePicture.frame.size.height/2
        profilePicture.layer.masksToBounds = true
    }
    
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = searchCollectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        if let posterPath = searchData?[indexPath.row].poster_path {
            let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") ?? URL(string: "https://image.tmdb.org/t/p/w500/jrgifaYeUtTnaH7NF5Drkgjg2MB.jpg")
            cell.poster.kf.setImage(with: url)}
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let title = searchData?[indexPath.row].title ?? searchData?[indexPath.row].name
        let releaseDate = searchData?[indexPath.row].first_air_date ?? searchData?[indexPath.row].release_date
        
        let selectedItem = Content(overview: (searchData?[indexPath.row].overview)!,
                                   poster_path: (searchData?[indexPath.row].poster_path)!,
                                   release_date: releaseDate!,
                                   title: title!,
                                   vote_average: (searchData?[indexPath.row].vote_average)!)
        didSelectItem(selectedItem)
        print(selectedItem)
    }
    
    func didSelectItem(_ selectedContent: Content) {
        if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
            detailVC.selectedContent = selectedContent
            self.present(detailVC, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 350, height: 580)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    
}
