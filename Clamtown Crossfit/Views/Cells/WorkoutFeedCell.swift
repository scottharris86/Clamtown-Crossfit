//
//  WorkoutFeedCell.swift
//  Clamtown Crossfit
//
//  Created by scott harris on 4/27/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import UIKit

class WorkoutFeedCell: UICollectionViewCell {
    let playerPreviewView = UIImageView()
    let coachImageView = UIImageView()
    let dateLabel = UILabel()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Create Cell Programmatically Only")
    }
    
    private func setupSubviews() {
        configurePlayerView()
        configureCoachImageAvatar()
        configureSeparatorViewConstraints()
        configureTitleLabel()
        configureSubtitleLabel()
        
    }
    
    private func configurePlayerView() {
        playerPreviewView.image = UIImage(named: "bobs_video_thumbnail")
        contentView.addSubview(playerPreviewView)
        playerPreviewView.translatesAutoresizingMaskIntoConstraints = false
        playerPreviewView.contentMode = .scaleToFill
        playerPreviewView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        playerPreviewView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        playerPreviewView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        playerPreviewView.heightAnchor.constraint(equalTo: playerPreviewView.widthAnchor, multiplier: 9.0/16.0).isActive = true

    }
    
    private func configureCoachImageAvatar() {
        coachImageView.contentMode = .scaleAspectFill
        coachImageView.image = UIImage(named: "sara")?.withRenderingMode(.alwaysOriginal)
        contentView.addSubview(coachImageView)
        coachImageView.translatesAutoresizingMaskIntoConstraints = false
        coachImageView.topAnchor.constraint(equalTo: playerPreviewView.bottomAnchor, constant: 16).isActive = true
        coachImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        coachImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        coachImageView.heightAnchor.constraint(equalTo: coachImageView.widthAnchor).isActive = true
        coachImageView.layer.cornerRadius = 22
        coachImageView.layer.masksToBounds = true
        
    }
    
    private func configureSeparatorViewConstraints() {
        addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
    }
    
    private func configureTitleLabel() {
        addSubview(titleLabel)
        titleLabel.text = "CLAMTOWN HOME WORKOUT - 4/26"
        titleLabel.font = .systemFont(ofSize: 15)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: coachImageView.trailingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: coachImageView.centerYAnchor).isActive = true
        
    }
    
    private func configureSubtitleLabel() {
        addSubview(subtitleLabel)
        subtitleLabel.text = "Coach: Sarah                     Time: 30:00"
        subtitleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        subtitleLabel.textColor = UIColor.init(white: 0.5, alpha: 0.7)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
    }
    
    
    
}
