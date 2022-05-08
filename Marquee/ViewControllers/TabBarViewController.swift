//
//  TabBarViewController.swift
//  TVOS Test
//
//  Created by Josh  Bayless on 5/1/22.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    private func setupView() {
        let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController")
        homeVC.tabBarItem.title = "Home"
        let favoritesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavoritesViewController")
        homeVC.tabBarItem.title = "Favorites"
        let searchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController")
        homeVC.tabBarItem.title = "Search"
        viewControllers = [homeVC, favoritesVC, searchVC]
    }
    
}
