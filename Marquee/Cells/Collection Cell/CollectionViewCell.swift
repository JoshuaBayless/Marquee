//
//  CollectionViewCell.swift
//  TVOS Test
//
//  Created by Josh  Bayless on 4/30/22.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var poster: UIImageView!
    
    
    
    
    static let identifier = "CollectionViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "CollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {

        coordinator.addCoordinatedAnimations({
            if self.isFocused {
                self.poster.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }else{
                self.poster.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }, completion: nil)
    
    }
}
