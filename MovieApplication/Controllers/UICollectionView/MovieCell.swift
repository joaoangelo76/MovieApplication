//
//  MovieCell.swift
//  MovieApplication
//
//  Created by João Ângelo on 23/10/24.
//

import UIKit

class MovieCell: UICollectionViewCell {
    static let identifier: String = "MovieCell"
    
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
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(yearLabel)
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePosterTap))
        posterImageView.isUserInteractionEnabled = true
        posterImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handlePosterTap() {
        onPosterTap?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with imageURL: String, title: String, releaseYear: String) {
        titleLabel.text = title
        yearLabel.text = releaseYear
        
        guard let url = URL(string: imageURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
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
