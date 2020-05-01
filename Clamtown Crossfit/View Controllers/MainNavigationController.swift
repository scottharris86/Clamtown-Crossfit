//
//  MainNavigationController.swift
//  Clamtown Crossfit
//
//  Created by scott harris on 4/27/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    let navBarAppearance = UINavigationBarAppearance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .systemGray6
        navigationBar.prefersLargeTitles = true
        navigationBar.standardAppearance = navBarAppearance
        navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationBar.compactAppearance = navBarAppearance
        let logoImageView = UIImageView()
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = UIImage(named: "logo-clamtown-crossfit")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        navigationBar.addSubview(logoImageView)
        
        navigationItem.titleView = logoImageView
        logoImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        logoImageView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: -70).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -8).isActive = true
        
    }
    
    
    
}
