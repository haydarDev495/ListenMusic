

//
//  TracksVC.swift
//  MusicPlayer
//
//  Created by Haydar Bekmuradov on 3.09.22.
//

import MarqueeLabel
import MediaPlayer
import UIKit

class TracksVC: UIViewController {
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var singerName: MarqueeLabel!
    @IBOutlet var musicName: MarqueeLabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var secondTimeLabel: UILabel!
    @IBOutlet var firstTimeLabel: UILabel!
    @IBOutlet var slider: UISlider!

    private let tracks = ["Starboy (with Daft Punk & The Weeknd)",
                          "Moth To A Flame (with Swedish House Mafia & The Weeknd)",
                          "Call Out My Name (The Weeknd)"]
    private let singers = ["Daft Punk & The Weeknd", "Swedish House Mafia & The Weeknd", "The Weeknd"]

    private var player: AVPlayer!
    private var nextButtonDigit = 1
    private var backButtonDigit = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        configurePlayer(music: tracks, index: 0)
        setupRunLine(music: musicName)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    private func configurePlayer(music: [String], index: Int) {
        musicName.text = tracks[index]
        singerName.text = singers[index]
        
        player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: music[index], ofType: "mp3")!))
        player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1000), queue: DispatchQueue.main) { [self] time in

            configureTimeLabels()


            setupRunLine(music: musicName)
            slider.value = Float(time.seconds)
        }
    }

    private func setupRunLine(music: MarqueeLabel) {
        music.type = .continuous
        music.textAlignment = .left
        music.lineBreakMode = .byTruncatingHead
        music.speed = .duration(8.0)
        music.fadeLength = 15.0
        music.leadingBuffer = 0.0
    }

    private func configureTimeLabels() {
        let timeElapsed = CMTimeGetSeconds(self.player!.currentTime())
        let secs = Int(timeElapsed)
        let currenTimeString = NSString(format: "%2d:%02d", secs / 60, secs % 60) as String
        firstTimeLabel.text = currenTimeString

        guard let maxValue = player.currentItem?.asset.duration.seconds else { return }
        let sec = Int(maxValue)
        let minutes = (sec % 3600) / 60
        let seconds = (sec % 3600) % 60
        secondTimeLabel.text = "\(minutes):\(seconds) "
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(collectionView.contentOffset.x / collectionView.frame.width)
        configurePlayer(music: tracks, index: currentPage)
        setupSlider()
    }

    private func setupSlider() {
        guard let maxValue = player.currentItem?.asset.duration.seconds else { return }
        slider.maximumValue = Float(maxValue)
    }

    private func buttonImageTitle() {
        playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
    }

    @IBAction func playButtonAction(_ sender: UIButton) {
        if player?.timeControlStatus == .playing {
            player?.pause()
            sender.setImage(UIImage(named: "Button_Play"), for: .normal)
        } else {
            player?.play()
            sender.setImage(UIImage(named: "pause"), for: .normal)
            setupSlider()
        }
    }

    @IBAction func backButtonAction(_ sender: UIButton) {
        collectionView.isPagingEnabled = false
        switch backButtonDigit {
        case 0:
            let getIndex = IndexPath(item: 2, section: 0)
            collectionView.scrollToItem(at: getIndex, at: .left, animated: false)
            backButtonDigit = 2
        case 1:
            let getIndex = IndexPath(item: 0, section: 0)
            collectionView.scrollToItem(at: getIndex, at: .left, animated: true)
            backButtonDigit = 0
        case 2:
            let getIndex = IndexPath(item: 1, section: 0)
            collectionView.scrollToItem(at: getIndex, at: .left, animated: true)
            backButtonDigit = 1
        default:
            backButtonDigit = 0
        }
        setupSlider()
        collectionView.isPagingEnabled = true
    }

    @IBAction func nextButtonAction(_ sender: UIButton) {
        collectionView.isPagingEnabled = false
        switch nextButtonDigit {
        case 0:
            let getIndex = IndexPath(item: 0, section: 0)
            collectionView.scrollToItem(at: getIndex, at: .right, animated: true)
            nextButtonDigit += 1
        case 1:
            let getIndex = IndexPath(item: 1, section: 0)
            collectionView.scrollToItem(at: getIndex, at: .centeredHorizontally, animated: true)
            nextButtonDigit += 1
        case 2:
            let getIndex = IndexPath(item: 2, section: 0)
            collectionView.scrollToItem(at: getIndex, at: .right, animated: true)
            nextButtonDigit = 0
        default:
            nextButtonDigit = 0
        }
        setupSlider()
        collectionView.isPagingEnabled = true
    }
}

// MARK: CV DataSource

extension TracksVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tracks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TrackCVCell
        cell.setupUICell(image: tracks[indexPath.row])
        return cell
    }
}

// MARK: CV Delegate

extension TracksVC: UICollectionViewDelegate {}
