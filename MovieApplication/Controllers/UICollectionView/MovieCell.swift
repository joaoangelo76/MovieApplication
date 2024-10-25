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
    
    let titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .black
        title.numberOfLines = 1
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    let yearLabel: UILabel = {
        let year = UILabel()
        year.font = UIFont.systemFont(ofSize: 14)
        year.textColor = .lightGray
        year.textAlignment = .center
        year.translatesAutoresizingMaskIntoConstraints = false
        return year
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(yearLabel)
        posterImageView.frame = contentView.bounds
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: posterImageView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: posterImageView.bottomAnchor),
            yearLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            yearLabel.centerYAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with imageURL: String, title: String, releaseYear: String){
        guard let url = URL(string: imageURL) else { return }
        
        DispatchQueue.main.async {
            self.titleLabel.text = title
            self.yearLabel.text = releaseYear
        }
        
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
