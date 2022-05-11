//
//  CollectionViewCell.swift
//  TVOS Test
//
//  Created by Josh  Bayless on 4/30/22.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var poster2: UIImageView!
    @IBOutlet weak var animationView: UIView!
    
    
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
                self.gradientAnimation()
                self.poster.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.animationView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                
            }else{
                self.poster.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.animationView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.poster.layer.mask = nil
            }
        }, completion: nil)
        
    
    }
    
    func gradientAnimation() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.frame = poster.frame
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.opacity = 0.2
        
        poster.layer.addSublayer(gradientLayer)
        
        // animation
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 0.3
        animation.fromValue = -poster.frame.width
        animation.toValue = poster.frame.width
        gradientLayer.add(animation, forKey: "gradientAnimation")
        //remove animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            gradientLayer.removeFromSuperlayer()
        })
    }
}



