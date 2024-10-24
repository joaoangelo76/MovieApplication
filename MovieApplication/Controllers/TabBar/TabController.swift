//
//  TabController.swift
//  MovieApplication
//
//  Created by João Ângelo on 23/10/24.
//

import Foundation
import UIKit

class TabController: UITabBarController{
    
    override func viewDidLoad() {
        setupTabs()
        
        self.tabBar.isTranslucent = true
    }
    
    private func setupTabs(){
        let home = self.createNav(with: "Home", and: UIImage(systemName: "house"), vc: HomeController())
        let favorites = self.createNav(with: "Favorites", and: UIImage(systemName: "star.fill"), vc: FavoritesController())
        
        self.setViewControllers([home, favorites], animated: true)
    }
    
    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController{
        
        let nav = UINavigationController(rootViewController: vc)
        
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        
        nav.viewControllers.first?.navigationItem.title = title + "Controller"
        
        nav.viewControllers.first?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Button", style: .plain, target: nil, action: nil)
        
        return nav
    }
    
}
