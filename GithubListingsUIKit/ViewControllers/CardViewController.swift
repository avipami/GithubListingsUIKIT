//
//  CardViewController.swift
//  GithubListingsUIKit
//
//  Created by Vincent Palma on 2024-08-14.
//

import Foundation
import UIKit

class CardViewController: UIViewController {
    
    var item: Repository!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "GitHubBackgroundColor")
        
        let containerView = UIStackView()
        containerView.axis = .vertical
        containerView.alignment = .center
        containerView.spacing = 0
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 75
        imageView.layer.shadowRadius = 30
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        loadImage(from: item.owner.avatarURL, into: imageView)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        containerView.addArrangedSubview(imageView)
        
        let repoNameLabel = UILabel()
        repoNameLabel.text = item.repoName
        repoNameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        repoNameLabel.textColor = .white
        containerView.addArrangedSubview(repoNameLabel)
        
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        spacerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        containerView.addArrangedSubview(spacerView)
        
        let usernameLabel = UILabel()
        usernameLabel.text = "Username: \(item.owner.ownerName)"
        usernameLabel.textColor = .white
        containerView.addArrangedSubview(usernameLabel)
        
        let createdLabel = UILabel()
        createdLabel.text = "Created: \(Helpers.shared.githubTimeConverter(inString: item.createdAt))"
        createdLabel.textColor = .white
        containerView.addArrangedSubview(createdLabel)
        
        let updatedLabel = UILabel()
        updatedLabel.text = "Updated: \(Helpers.shared.githubTimeConverter(inString: item.updatedAt))"
        updatedLabel.textColor = .white
        containerView.addArrangedSubview(updatedLabel)
        
        var languageLabel: UILabel {
            let languageLabel = UILabel()
            languageLabel.text = "Main Language: \(String(describing: item.language))"
            languageLabel.textColor = .white
            containerView.addArrangedSubview(languageLabel)
            return languageLabel
        }
        
        containerView.layoutMargins = UIEdgeInsets(top: 10, left: 50, bottom: 10, right: 50)
        containerView.isLayoutMarginsRelativeArrangement = true
        
        let repoButton = UIButton(type: .system)
        repoButton.setTitle("GitHub Repo", for: .normal)
        repoButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.cyan.cgColor, UIColor.purple.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        
        let gradientView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        gradientView.layer.insertSublayer(gradient, at: 0)
        gradientView.layer.cornerRadius = 10
        gradientView.layer.masksToBounds = true
        
        repoButton.frame = gradientView.bounds
        gradientView.addSubview(repoButton)
        containerView.addArrangedSubview(gradientView)
        
        repoButton.addTarget(self, action: #selector(repoButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func repoButtonTapped() {
        if let url = URL(string: item.url) {
            UIApplication.shared.open(url)
        }
    }
    
    private func loadImage(from urlString: String, into imageView: UIImageView) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
    }
}
