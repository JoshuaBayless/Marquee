//
//  TableViewCell.swift
//  TVOS Test
//
//  Created by Josh  Bayless on 4/30/22.
//

import UIKit
import Kingfisher

protocol CollectionViewDelegate: AnyObject {
    func didSelectItem(_ selectedContent: Content)
}

class TableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    static let identifier = "TableViewCell"
    var delegate: CollectionViewDelegate?
    let viewController = ViewController()

    var movies: [Movie]? {
        didSet {
            collectionView.reloadData()
        }
    }
    var tvShows: [TVdata]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "TableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .darkGray
        collectionView.layer.cornerRadius = 20
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Collection View Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag{
        case 0:
            return movies?.count ?? 0
        case 1:
            return tvShows?.count ?? 0
        case 2:
            return movies?.count ?? 0
        default:
            print("collectionview.tag is out of range")
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        
        switch collectionView.tag {
        case 1:
            if let posterPath = tvShows?[indexPath.row].posterPath {
                let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") ?? URL(string: "https://image.tmdb.org/t/p/w500/jrgifaYeUtTnaH7NF5Drkgjg2MB.jpg")
                let processor = RoundCornerImageProcessor(cornerRadius: 20)
                cell.poster.kf.setImage(with: url, placeholder: nil, options: [.processor(processor)])}
        default:
            if let posterPath = movies?[indexPath.row].posterPath {
                let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") ?? URL(string: "https://image.tmdb.org/t/p/w500/jrgifaYeUtTnaH7NF5Drkgjg2MB.jpg")
                let processor = RoundCornerImageProcessor(cornerRadius: 20)
                cell.poster.kf.setImage(with: url, placeholder: nil, options: [.processor(processor)])}
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView.tag {
        case 1:
            let selectedContent = Content(overview: tvShows?[indexPath.row].overview ?? "",
                                          posterPath: tvShows?[indexPath.row].posterPath ?? "",
                                          releaseDate: tvShows?[indexPath.row].firstAirDate ?? "",
                                          title: tvShows?[indexPath.row].name ?? "",
                                          voteAverage: tvShows?[indexPath.row].voteAverage ?? 0)
            delegate?.didSelectItem(selectedContent)
        default:
            let selectedContent = Content(overview: movies?[indexPath.row].overview ?? "",
                                          posterPath: movies?[indexPath.row].posterPath ?? "",
                                          releaseDate: movies?[indexPath.row].releaseDate ?? "",
                                          title: movies?[indexPath.row].title ?? "",
                                          voteAverage: movies?[indexPath.row].voteAverage ?? 0)
            delegate?.didSelectItem(selectedContent)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 500)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
}


