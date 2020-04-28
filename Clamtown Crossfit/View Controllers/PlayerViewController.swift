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
    
    var tapGesture: UITapGestureRecognizer?
    var isMinimized: Bool = true
    var player: AVPlayer?
    var isPlaying: Bool = false
    let playerView = UIView()
    var playerLayer: AVPlayerLayer?
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapped))
        view.addGestureRecognizer(tapGesture!)
    }
    
    func showPlayerFullScreen() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            guard let parent = self.parent else { return }
            self.view.frame = CGRect(x: 0, y: parent.view.safeAreaInsets.top, width: parent.view.frame.width, height: (parent.view.frame.height - parent.view.safeAreaInsets.top))
            let width = self.view.frame.width
            let height = width * 9 / 16
            let frame = CGRect(x: 0, y: 0, width: width, height: height)
            self.playerView.frame = frame
            self.playerLayer?.frame = frame
            
        }, completion: {(finished) in
            if !self.isPlaying {
               self.setupPlayerView()
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
            self.playerView.frame = playerFrame
            self.playerLayer?.frame = playerFrame
            
        }, completion: { (finsihed) in
            if !self.isPlaying {
                self.setupPlayerView()
            }
        })
    }
    
    private func setupPlayerView() {
        let urlHelper = FileURL()
        let videoURL = urlHelper.resourcesDirectory
        if let videoURL = videoURL {
            player = AVPlayer(url: videoURL)
            let width = self.view.frame.width
            let height = self.view.frame.height
            let frame = CGRect(x: 0, y: 0, width: width, height: height)
            view.insertSubview(playerView, at: 0)
//            view.addSubview(playerView)
            playerView.frame = frame
            playerView.backgroundColor = .black
            playerLayer = AVPlayerLayer(player: player)
            playerView.layer.addSublayer(playerLayer!)
            playerLayer!.frame = frame
            player?.play()
            isPlaying = true
            
        }
    }
}
