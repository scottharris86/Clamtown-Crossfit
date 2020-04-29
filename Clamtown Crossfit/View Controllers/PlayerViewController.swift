//
//  PlayerViewController.swift
//  Clamtown Crossfit
//
//  Created by scott harris on 4/28/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    var tempViewTapGesture: UITapGestureRecognizer?
    var videoControlsTapGuesture: UITapGestureRecognizer?
    var isMinimized: Bool = false
    var player: AVPlayer?
    var isPlaying: Bool = false
    let playerView = UIView()
    var playerLayer: AVPlayerLayer?
    let videoControlsOverlayView = UIView()
    let playPauseButton = UIButton()
    var videoURL: URL? {
        didSet {
            configurePlayer()
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        view.frame = parent!.view.bounds
//    }
    
    override func viewDidLoad() {
        guard let parent = self.parent else { return }
        
        let frame = CGRect(x: parent.view.frame.size.width - parent.view.safeAreaInsets.right - 150 - 16, y: parent.view.frame.height - parent.view.safeAreaInsets.bottom - (150 * 9 / 16), width: 150, height: 150 * 9 / 16)
        
        self.view.frame = frame
        view.backgroundColor = .white
        tempViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapped))
        view.addGestureRecognizer(tempViewTapGesture!)
        
        setupPlayerView()
        showPlayerFullScreen()
        
        
    }
    
    func showPlayerFullScreen() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            guard let parent = self.parent else { return }
            self.view.frame = CGRect(x: 0, y: parent.view.safeAreaInsets.top, width: parent.view.frame.width, height: (parent.view.frame.height - parent.view.safeAreaInsets.top))
            let width = parent.view.frame.width
            let height = width * 9 / 16
            let frame = CGRect(x: 0, y: 0, width: width, height: height)

            self.playerView.frame = frame
            self.playerLayer?.frame = self.playerView.bounds
            
            // DO WE NEED?!?!?!
            self.playerView.layoutIfNeeded()
            
        }, completion: {(finished) in
            if let controls = self.videoControlsTapGuesture {
                self.playerView.addGestureRecognizer(controls)
            }
            if !self.isPlaying {
//               self.setupPlayerView()
            }
            
        })
    }
    
    @objc private func handleTapped() {
        if isMinimized {
            showPlayerFullScreen()
        } else {
            minimizePlayer()
        }
        
        isMinimized.toggle()
    }
    
    func minimizePlayer() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            guard let parent = self.parent else { return }
            
            let frame = CGRect(x: parent.view.frame.size.width - parent.view.safeAreaInsets.right - 150 - 16, y: parent.view.frame.height - parent.view.safeAreaInsets.bottom - (150 * 9 / 16), width: 150, height: 150 * 9 / 16)
            
            self.view.frame = frame
            let width = self.view.frame.width
            let height = self.view.frame.height
            let playerFrame = CGRect(x: 0, y: 0, width: width, height: height)
            
            
            // DO WE NEED???
            self.playerView.layoutIfNeeded()

            self.playerView.frame = playerFrame
            self.playerLayer?.frame = playerFrame
            self.playerView.removeGestureRecognizer(self.videoControlsTapGuesture!)
            self.videoControlsOverlayView.isHidden = true
            
        }, completion: { (finsihed) in
            if !self.isPlaying {
//                self.setupPlayerView()
            }
        })
    }
    
    private func setupPlayerView() {
        view.addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playerView.heightAnchor.constraint(equalTo: playerView.widthAnchor, multiplier: 9/16).isActive = true
        
        playerView.layoutIfNeeded()
        
        playerView.backgroundColor = .black
        
        configurePlayer()
    }
    
    private func configurePlayer() {
        if let videoURL = videoURL {
            if let player = player {
                let currentItem = AVPlayerItem(url: videoURL)
                player.replaceCurrentItem(with: currentItem)
            } else {
                player = AVPlayer(url: videoURL)
                playerLayer = AVPlayerLayer(player: player)
                playerView.layer.addSublayer(playerLayer!)
                playerLayer!.frame = playerView.bounds
                player?.play()
                isPlaying = true
                playPauseButton.isSelected = isPlaying
                setupVideoControls()
            }
        }
    }
    
    private func setupVideoControls() {
        videoControlsOverlayView.backgroundColor = UIColor.init(white: 0.3, alpha: 0.5)
        playerView.addSubview(videoControlsOverlayView)
        videoControlsOverlayView.isHidden = true
        videoControlsOverlayView.translatesAutoresizingMaskIntoConstraints = false
        videoControlsOverlayView.topAnchor.constraint(equalTo: playerView.topAnchor).isActive = true
        videoControlsOverlayView.leadingAnchor.constraint(equalTo: playerView.leadingAnchor).isActive = true
        videoControlsOverlayView.trailingAnchor.constraint(equalTo: playerView.trailingAnchor).isActive = true
        videoControlsOverlayView.bottomAnchor.constraint(equalTo: playerView.bottomAnchor).isActive = true
        videoControlsTapGuesture = UITapGestureRecognizer(target: self, action: #selector(handleControlsTapped))
        playerView.addGestureRecognizer(videoControlsTapGuesture!)
        setupPlayButton()
        
    }
    
    @objc private func handleControlsTapped() {
        videoControlsOverlayView.isHidden.toggle()
    }
    
    private func setupPlayButton() {
        playPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .selected)
        playPauseButton.tintColor = .white
        playPauseButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        videoControlsOverlayView.addSubview(playPauseButton)
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        playPauseButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        playPauseButton.centerXAnchor.constraint(equalTo: videoControlsOverlayView.centerXAnchor).isActive = true
        playPauseButton.centerYAnchor.constraint(equalTo: videoControlsOverlayView.centerYAnchor).isActive = true

    }
    
    @objc private func playTapped() {
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
        
        playPauseButton.isSelected.toggle()
        isPlaying.toggle()
    }
}
