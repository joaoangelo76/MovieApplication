//
//  DetailsController.swift
//  MovieApplication
//
//  Created by João Ângelo on 24/10/24.
//

import Foundation
import UIKit

class DetailsController: UIViewController{
    
    var movies: [Movies] = []
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        self.view.backgroundColor = .yellow
    }
}
