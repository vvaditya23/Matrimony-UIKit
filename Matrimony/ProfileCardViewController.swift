//
//  ViewController.swift
//  Matrimony
//
//  Created by Aditya Vyavahare on 04/05/24.
//

import UIKit

class ProfileCardViewController: UIViewController {
    private var currentPage = 1
    private var profiles = [RandomProfile]()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
                collectionView.delegate = self
                collectionView.dataSource = self
                collectionView.isPagingEnabled = true
                collectionView.showsVerticalScrollIndicator = false
                collectionView.backgroundColor = .clear
                collectionView.register(ProfileCardCollectionViewCell.self, forCellWithReuseIdentifier: "ProfileCardCell")
                return collectionView
            }()
    
    override func viewWillAppear(_ animated: Bool) {
        fetchRandomProfiles()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
}

extension ProfileCardViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCardCell", for: indexPath) as! ProfileCardCollectionViewCell
        let profile = profiles[indexPath.item]
        cell.configure(with: profile)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if indexPath.item == profiles.count - 1 {
                currentPage += 1
                fetchRandomProfiles()
            }
        }
}

//API call
extension ProfileCardViewController {
    func fetchRandomProfiles() {
        NetworkManager.shared.fetchRandomProfiles(page: currentPage, resultsPerPage: 10) { result in
            switch result {
            case .success(let fetchedProfiles):
                print("Fetched profiles: \(fetchedProfiles)")
                self.profiles.append(contentsOf: fetchedProfiles)
                DispatchQueue.main.async { 
                    self.collectionView.reloadData()
                }            
            case .failure(let error):
                print("Error fetching profiles: \(error)")
            }
        }
    }
}
