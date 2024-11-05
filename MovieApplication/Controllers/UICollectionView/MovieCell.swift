//
//  MovieCell.swift
//  MovieApplication
//
//  Created by João Ângelo on 23/10/24.
//

import UIKit

class MovieCell: UICollectionViewCell {
    static let identifier: String = "MovieCell"
    
    // Closure for tap action on the poster image
    var onPosterTap: (() -> Void)?

    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.numberOfLines = 1
        title.font = UIFont(name: "JostRoman-Bold", size: 16)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add subviews
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(yearLabel)
        
        // Set corner radius for cell appearance
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        // Layout constraints for elements within the cell
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            yearLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        // Tap gesture on the poster image
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePosterTap))
        posterImageView.isUserInteractionEnabled = true
        posterImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handlePosterTap() {
        onPosterTap?() // Trigger the closure when the poster is tapped
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Configure method to set up cell with movie data
    func configure(with imageURL: String, title: String, releaseYear: String) {
        titleLabel.text = title
        yearLabel.text = releaseYear
        
        guard let url = URL(string: imageURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.posterImageView.image = image
                }
            } else {
                print("Failed to load image: \(error?.localizedDescription ?? "No error info")")
            }
        }.resume()
    }
}
