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
    var panGuestureRecognizer: UIPanGestureRecognizer?
    var isMinimized: Bool = false
    var player: AVPlayer?
    var isPlaying: Bool = false
    let playerView = UIView()
    var playerLayer: AVPlayerLayer?
    let videoControlsOverlayView = UIView()
    let playPauseButton = UIButton()
    let currentTimeLabel = UILabel()
    let durationLabel = UILabel()
    let seekSlider = UISlider()
    var videoURL: URL? {
        didSet {
            configurePlayer()
        }
    }
    var timeObserverToken: Any?
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "m:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    var initialCenter = CGPoint()
    
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
            if let pan = self.panGuestureRecognizer {
                self.view.removeGestureRecognizer(pan)
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
            if let panGuestureRecognizer = self.panGuestureRecognizer {
                self.view.addGestureRecognizer(panGuestureRecognizer)
            } else {
                self.panGuestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan))
                self.view.addGestureRecognizer(self.panGuestureRecognizer!)
            }
            
            self.videoControlsOverlayView.isHidden = true
            
        }, completion: nil)
    }
    
    
    @objc private func handlePan(_ gestureRecognizer : UIPanGestureRecognizer) {
        guard gestureRecognizer.view != nil else {return}
        let piece = gestureRecognizer.view!
        // Get the changes in the X and Y directions relative to
        // the superview's coordinate space.
        let translation = gestureRecognizer.translation(in: piece.superview)
        if gestureRecognizer.state == .began {
            // Save the view's original position.
            self.initialCenter = piece.center
        }
        // Update the position for the .began, .changed, and .ended states
        if gestureRecognizer.state != .cancelled {
            // Add the X and Y translation to the view's original position.
            let newCenterX = initialCenter.x + translation.x
            let newCenter = CGPoint(x: newCenterX, y: initialCenter.y + translation.y)
            if let superview = piece.superview {
                if newCenterX > superview.bounds.maxX {
                    player?.pause()
                    player = nil
                    self.willMove(toParent: nil)
                    self.view.removeFromSuperview()
                    self.removeFromParent()
                    dismiss(animated: false, completion: nil)
                    return
                }
            }
            
            piece.center = newCenter
        }
        else {
            // On cancellation, return the piece to its original location.
            piece.center = initialCenter
        }
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
                player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
                addPeriodicTimeObserver()

            }
        }
    }
    
    private func addPeriodicTimeObserver() {
        // Invoke callback every half second
        let interval = CMTime(seconds: 0.5,
                              preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        // Add time observer. Invoke closure on the main queue.
        timeObserverToken =
            player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) {
                [weak self] time in
                // update player transport UI
                self?.currentTimeLabel.text = self?.convertTimeToString(time: time)
                let seconds = time.seconds
                self?.seekSlider.value = Float(seconds)
                
        }
    }
    
    private func convertTimeToString(time: CMTime) -> String? {
        let seconds = CMTimeGetSeconds(time)
        if !seconds.isNaN {
            let secondInterval = TimeInterval(seconds)
            let date = Date(timeIntervalSinceReferenceDate: secondInterval)
            return dateFormatter.string(from: date)
        }
        
        return nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // this is when the player is ready and rendering frames
        if keyPath == "currentItem.loadedTimeRanges" {
            isPlaying = true
            
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                
                if !seconds.isNaN {
                    seekSlider.maximumValue = Float(seconds)
                    seekSlider.minimumValue = 0
                }
                
                durationLabel.text = convertTimeToString(time: duration)
                
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
        setupSeekControls()
        
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
    
    private func setupSeekControls() {
        seekSlider.addTarget(self, action: #selector(seek), for: .valueChanged)
        durationLabel.font = .systemFont(ofSize: 14, weight: .bold)
        durationLabel.textColor = .white
        currentTimeLabel.font = .monospacedSystemFont(ofSize: 14, weight: .bold)
        currentTimeLabel.textColor = .white
        currentTimeLabel.text = "00:00"
        videoControlsOverlayView.addSubview(currentTimeLabel)
        videoControlsOverlayView.addSubview(durationLabel)
        videoControlsOverlayView.addSubview(seekSlider)
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        seekSlider.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.bottomAnchor.constraint(equalTo: videoControlsOverlayView.bottomAnchor, constant: -8).isActive = true
        durationLabel.trailingAnchor.constraint(equalTo: videoControlsOverlayView.trailingAnchor, constant: -8).isActive = true
        currentTimeLabel.bottomAnchor.constraint(equalTo: videoControlsOverlayView.bottomAnchor, constant: -8).isActive = true
        currentTimeLabel.leadingAnchor.constraint(equalTo: videoControlsOverlayView.leadingAnchor, constant: 8).isActive = true
        seekSlider.leadingAnchor.constraint(equalTo: currentTimeLabel.trailingAnchor, constant: 16).isActive = true
        seekSlider.trailingAnchor.constraint(equalTo: durationLabel.leadingAnchor, constant: -16).isActive = true
        seekSlider.bottomAnchor.constraint(equalTo: videoControlsOverlayView.bottomAnchor).isActive = true
        
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
    
    @objc private func seek() {
        let value = seekSlider.value
        
        let time = CMTime(seconds: Double(value), preferredTimescale: 1)
        
        player?.seek(to: time, completionHandler: { [weak self] (completedSeek) in
            self?.currentTimeLabel.text = self?.convertTimeToString(time: time)
        })
        
    }
}
