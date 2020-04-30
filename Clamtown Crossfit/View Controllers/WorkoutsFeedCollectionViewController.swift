//
//  WorkoutsFeedCollectionViewController.swift
//  Clamtown Crossfit
//
//  Created by scott harris on 4/27/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import UIKit

class WorkoutsFeedCollectionViewController: UICollectionViewController {
    
    let cellCount = 5
    var playerViewController: PlayerViewController?
    let workoutController = WorkoutController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(WorkoutFeedCell.self, forCellWithReuseIdentifier: "FeedCell")
        workoutController.getAllWorkouts {
            DispatchQueue.main.async {
               self.collectionView.reloadData()
            }
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workoutController.workouts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as? WorkoutFeedCell else { return WorkoutFeedCell() }
        
        let workout = workoutController.workouts[indexPath.item]
        FireBaseAPIClient.shared.fetchImage(at: workout.coach.profileImgURL) { (data) in
            if let data = data {
                DispatchQueue.main.async {
                    cell.coachImageView.image = UIImage(data: data)
                }
            }
        }
        FireBaseAPIClient.shared.fetchImage(at: workout.thumbnailURL) { (data) in
            if let data = data {
                DispatchQueue.main.async {
                    cell.playerPreviewView.image = UIImage(data: data)
                }
            }
        }
        
        cell.subtitleLabel.text = "Coach: \(workout.coach.name)"
        cell.titleLabel.text = workout.title
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let playerVC = playerViewController {
            let videoURL = workoutController.workouts[indexPath.item].videoURL
            playerVC.videoURL = videoURL
        } else {
            playerViewController = PlayerViewController()
            self.navigationController?.addChild(playerViewController!)
            
            self.navigationController?.view.addSubview(playerViewController!.view)
            playerViewController!.didMove(toParent: self.navigationController)
            
            let videoURL = workoutController.workouts[indexPath.item].videoURL
            playerViewController!.videoURL = videoURL
        }
    }
}

extension WorkoutsFeedCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 4
        
        return CGSize(width: width, height: width - 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}
