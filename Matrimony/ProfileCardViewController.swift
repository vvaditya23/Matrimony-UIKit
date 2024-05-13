//
//  ProfileCardViewController.swift
//  Matrimony
//
//  Created by Aditya Vyavahare on 04/05/24.
//

import UIKit

class ProfileCardViewController: UIViewController, UINavigationBarDelegate {
    private var currentPage = 1
    private var profiles = [RandomProfile]()
    private var genderReceived = ""
    
    let navbar = UINavigationBar()
    let navItem = UINavigationItem()
    
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
        navbar.delegate = self

        navItem.title = "Matches"
        navItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .done, target: self, action: #selector(filterButtonTapped))
        navItem.rightBarButtonItem?.tintColor = .black
        navbar.items = [navItem]

        view.addSubview(navbar)
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        navbar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: navbar.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("GenderRefresh"), object: nil)
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
                if genderReceived == "male" {
                    NetworkManager.shared.resetSeed()
                    NetworkManager.shared.fetchRandomProfiles(page: currentPage, resultsPerPage: 10, gender: "male") { result in
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
                } else if genderReceived == "female" {
                    NetworkManager.shared.resetSeed()
                    NetworkManager.shared.fetchRandomProfiles(page: currentPage, resultsPerPage: 10, gender: "female") { result in
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
                } else {
                    fetchRandomProfiles()
                }
            }
        }
}

extension ProfileCardViewController {
    @objc func filterButtonTapped() {
        let filterVC = FilterViewController()
        filterVC.isModalInPresentation = true   //disables swipe down to close gesture
        present(filterVC, animated: true)
    }
}

//API call
extension ProfileCardViewController {
    func fetchRandomProfiles() {
        NetworkManager.shared.fetchRandomProfiles(page: currentPage, resultsPerPage: 10, gender: "") { result in
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
    
    @objc func handleNotification(_ notification: Notification) {
        profiles = []
        collectionView.reloadData()
        NetworkManager.shared.resetSeed()
        currentPage = 1
        if let userInfo = notification.userInfo {
            if let gender = userInfo["gender"] as? String {
                    genderReceived = gender
                NetworkManager.shared.fetchRandomProfiles(page: currentPage, resultsPerPage: 10, gender: gender) { result in
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
    }
}
