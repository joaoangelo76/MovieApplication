//
//  ViewController.swift
//  MovieApplication
//
//  Created by João Ângelo on 22/10/24.
//

import UIKit

class HomeController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBlue
        
        Decoding.fetchMovies { movies in
            if let movies = movies {
                for movie in movies {
                    
                }
            } else {
                print("No movies found or an error occurred.")
            }
        }
    }
}



