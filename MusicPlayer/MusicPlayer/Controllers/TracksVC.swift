//
//  TracksVC.swift
//  MusicPlayer
//
//  Created by Haydar Bekmuradov on 3.09.22.
//

import UIKit

class TracksVC: UIViewController {
    private let reuseIdentifier = "Cell"
    
    private let photos = ["Daft Punk, The Weeknd - Starboy", "Swedish House Mafia, The Weeknd - Moth To A Flame", "The Weeknd - Call Out My Name"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: CV DataSource

extension TracksVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TrackCVCell
        cell.musicImage.image = UIImage(named: photos[indexPath.row])
        return cell
    }
}

// MARK: CV Delegate

extension TracksVC: UICollectionViewDelegate {}

