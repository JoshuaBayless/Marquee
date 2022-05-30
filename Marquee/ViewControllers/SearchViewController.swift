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
    
    let jsonManager = JSONManager()
    var searchData: [SearchObject]? {
        didSet {
            DispatchQueue.main.async {
                self.searchCollectionView.reloadData()
            }
        }
    }
    
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
            }
        }
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
        if let posterPath = searchData?[indexPath.row].posterPath {
            let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")
            cell.poster.kf.setImage(with: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let title = searchData?[indexPath.row].title ?? searchData?[indexPath.row].name
        let releaseDate = searchData?[indexPath.row].firstAirDate ?? searchData?[indexPath.row].releaseDate
        
        let selectedItem = Content(overview: (searchData?[indexPath.row].overview) ?? "",
                                   posterPath: (searchData?[indexPath.row].posterPath) ?? "",
                                   releaseDate: releaseDate ?? "",
                                   title: title ?? "",
                                   voteAverage: (searchData?[indexPath.row].voteAverage) ?? 0)
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
