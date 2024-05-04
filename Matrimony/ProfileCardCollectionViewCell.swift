//
//  ProfileCardCollectionViewCell.swift
//  Matrimony
//
//  Created by Aditya Vyavahare on 04/05/24.
//

import UIKit

class ProfileCardCollectionViewCell: UICollectionViewCell {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let nameAgeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    private let emailNationalityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(profileImageView)
        profileImageView.addSubview(nameAgeLabel)
        profileImageView.addSubview(locationLabel)
        profileImageView.addSubview(emailNationalityLabel)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameAgeLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        emailNationalityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            profileImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            profileImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            emailNationalityLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 10),
            emailNationalityLabel.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -10),
            emailNationalityLabel.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -20),
            
            locationLabel.bottomAnchor.constraint(equalTo: emailNationalityLabel.topAnchor, constant: -3),
            locationLabel.leadingAnchor.constraint(equalTo: emailNationalityLabel.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -20),
            
            nameAgeLabel.bottomAnchor.constraint(equalTo: locationLabel.topAnchor, constant: -3),
            nameAgeLabel.leadingAnchor.constraint(equalTo: emailNationalityLabel.leadingAnchor),
            nameAgeLabel.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -20)
        ])
        
        emailNationalityLabel.numberOfLines = 0
        locationLabel.numberOfLines = 0
        nameAgeLabel.numberOfLines = 0
    }
    
    func configure(with profile: RandomProfile) {
        nameAgeLabel.text = "\(profile.name.first + " " + profile.name.last), \(profile.dob.age)"
        nameAgeLabel.textColor = .white
        
        locationLabel.text = "\(profile.location.city), \(profile.location.state), \(profile.location.country)"
        locationLabel.textColor = .white
        
        emailNationalityLabel.text = "\(profile.email) · \(profile.nat)"
        emailNationalityLabel.textColor = .white
        
        profileImageView.loadImage(from: profile.picture.large)
    }
}
