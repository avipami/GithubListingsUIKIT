//
//  CellView.swift
//  GithubListingsUIKit
//
//  Created by Vincent Palma
//

import Foundation
import UIKit



class CellView: UIView {
    
    private let backgroundRoundedView: UIView = {
        let view = UIView()
        view.backgroundColor = .gitHubBackground
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let repoNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.forward.circle.fill")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 16.0, height: 10)
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
    }
    
    private func setupView() {
        addSubview(backgroundRoundedView)
        addSubview(repoNameLabel)
        addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            backgroundRoundedView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            backgroundRoundedView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            backgroundRoundedView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backgroundRoundedView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            repoNameLabel.leadingAnchor.constraint(equalTo: backgroundRoundedView.leadingAnchor, constant: 16),
            repoNameLabel.centerYAnchor.constraint(equalTo: backgroundRoundedView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            chevronImageView.trailingAnchor.constraint(equalTo: backgroundRoundedView.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: backgroundRoundedView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 30),
            chevronImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configure(with item: Repository) {
        repoNameLabel.text = item.repoName
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: backgroundRoundedView.bounds, cornerRadius: 15).cgPath
    }
}
