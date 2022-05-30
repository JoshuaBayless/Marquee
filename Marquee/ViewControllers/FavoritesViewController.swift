//
//  FavoritesViewController.swift
//  TVOS Test
//
//  Created by Josh  Bayless on 5/1/22.
//

import UIKit
import Kingfisher

class FavoritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    let viewController = ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoritesCollectionView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.identifier)
        favoritesCollectionView.delegate = self
        favoritesCollectionView.dataSource = self
        favoritesCollectionView.backgroundColor = .darkGray
        favoritesCollectionView.layer.cornerRadius = 20
        profilePictureSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        viewController.fetchFavorites()
        favoritesCollectionView.reloadData()
    }
    
    func profilePictureSetUp() {
        profilePicture.layer.cornerRadius = profilePicture.frame.size.height/2
        profilePicture.layer.masksToBounds = true
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FavoritesList.shared.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favoritesCollectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        if let posterPath = FavoritesList.shared.list[indexPath.row].posterPath {
            let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")
            cell.poster.kf.setImage(with: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = Content(overview: FavoritesList.shared.list[indexPath.row].overview ?? "",
                                   posterPath: FavoritesList.shared.list[indexPath.row].posterPath ?? "",
                                   releaseDate: FavoritesList.shared.list[indexPath.row].releaseDate ?? "",
                                   title: FavoritesList.shared.list[indexPath.row].title ?? "",
                                   voteAverage: FavoritesList.shared.list[indexPath.row].voteAverage)
        didSelectItem(selectedItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 350, height: 580)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func didSelectItem(_ selectedContent: Content) {
        if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
            detailVC.selectedContent = selectedContent
            self.present(detailVC, animated: true, completion: nil)
        }
    }
}
