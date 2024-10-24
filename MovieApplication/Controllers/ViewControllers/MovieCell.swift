//
//  MovieCell.swift
//  MovieApplication
//
//  Created by João Ângelo on 23/10/24.
//

import Foundation
import UIKit

class MovieCell: UICollectionViewCell{
    
    static let identifier: String = "MovieCell"
    
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
        posterImageView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with imageURL: String){
        guard let url = URL(string: imageURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data){
                DispatchQueue.main.async {
                    self.posterImageView.image = image
                }
            } else {
                print("Failed to load image: \(error?.localizedDescription ?? "No error info")")
            }
        }.resume()
    }
}
