//
//  DetailViewController.swift
//  TVOS Test
//
//  Created by Josh  Bayless on 5/1/22.
//

import UIKit
import AVKit
import Kingfisher

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var mainPoster: UIImageView!
    @IBOutlet weak var userScore: UILabel!
    @IBOutlet weak var scoreBar: UIProgressView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var contentOverview: UILabel!
    @IBOutlet weak var contentTitle: UILabel!
    var selectedContent = Content(overview: "", posterPath: "", releaseDate: "", title: "", voteAverage: 0.0)
    let viewController = ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userScore.text = "Rating: \(selectedContent.voteAverage)"
        scoreBar.progress = Float(selectedContent.voteAverage*0.1)
        contentTitle.text = selectedContent.title
        contentOverview.text = selectedContent.overview

        releaseDate.text = selectedContent.releaseDate
        let url = URL(string: "https://image.tmdb.org/t/p/w500/\(selectedContent.posterPath)")
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        mainPoster.kf.setImage(with: url, placeholder: nil, options: [.processor(processor)])

        profilePicSetUp()
        favoritesButtonSetup(for: selectedContent)
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        
        let url = Bundle.main.url(forResource: "ThanksForComing", withExtension: ".mp4")
        let player = AVPlayer(url: url!)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true){
            player.play()
        }
    }
    
    @IBAction func saveForLaterButtonPressed(_ sender: Any) {
        viewController.updateFavorite(at: selectedContent)
        favoritesButtonSetup(for: selectedContent)
    }
    
    //MARK: - UI Setup Methods
    func profilePicSetUp() {
        profilePic.layer.cornerRadius = profilePic.frame.size.height/2
        profilePic.layer.masksToBounds = true
    }
    
    func favoritesButtonSetup(for selectedContent: Content) {
        let info = viewController.isFavorited(selectedContent)
        if info.0 {
            favoriteButton.setTitle("Remove From List", for: .normal)
            favoriteButton.titleLabel?.textAlignment = .center
        }else {
            favoriteButton.setTitle("Watch Later", for: .normal)
        }
    }
}
