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
        navBarAppearance.backgroundColor = .white
        navigationBar.prefersLargeTitles = true
        navigationBar.standardAppearance = navBarAppearance
        navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationBar.compactAppearance = navBarAppearance
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "logo-clamtown-crossfit")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        navigationBar.addSubview(logoImageView)
        
        navigationItem.titleView = logoImageView
//        self.navigationItem.titleView = logoImageView
//        navigationBar.addSubview(logoImageView)
//        logoImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        logoImageView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 16).isActive = true
        logoImageView.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -60).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -8).isActive = true
        
    }
    
    
    
}
