//
//  TrackCVCell.swift
//  MusicPlayer
//
//  Created by Haydar Bekmuradov on 3.09.22.
//

import UIKit

class TrackCVCell: UICollectionViewCell {
    @IBOutlet var blurView: UIView!
    @IBOutlet private var musicImage: UIImageView!

    func setupUICell(image: String) {
        musicImage.layer.cornerRadius = 10
        musicImage.image = UIImage(named: image)

        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurView.bounds
        blurView.layer.cornerRadius = 10
        blurView.layer.borderWidth = 0.1
        blurView.layer.borderColor = UIColor.white.cgColor
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.addSubview(blurEffectView)
    }
}
