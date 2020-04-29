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
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(WorkoutFeedCell.self, forCellWithReuseIdentifier: "FeedCell")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playerVC = PlayerViewController()
        self.navigationController?.addChild(playerVC)
        
        self.navigationController?.view.addSubview(playerVC.view)
        playerVC.didMove(toParent: self.navigationController)
        playerVC.showPlayerFullScreen()
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
