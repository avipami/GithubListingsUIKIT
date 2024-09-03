//
//  ReposViewController.swift
//  GithubListingsUIKit
//
//  Created by Vincent Palma
//

import Foundation
import UIKit

class ReposViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    var repos: [Repository] = []
    var currentPage = 1
    var isLoading = false
    var hasMoreData = true
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchRepos(page: currentPage)
    }
    
    @objc func didPullToRefresh() {
        fetchRepos(refresh: true)
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
    
    private func hideTopNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    private func setup() {
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .gitHubBackground
        tableView.frame = view.bounds
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(refreshControl)
        tableView.register(ListItemComponentCellView.self, forCellReuseIdentifier: "ListItemComponentCell")
        
        view.addSubview(tableView)
        
        hideTopNavigationBar()
        
        let topLabel: UILabel = {
            let label = UILabel()
            label.text = "Top Trending Repos"
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let safeAreaBackgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(.gitHubBackground)
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOffset = CGSize(width: 2, height: 2)
            view.layer.shadowRadius = 4.0
            view.layer.shadowOpacity = 0.3
            view.layer.masksToBounds = false
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        view.addSubview(safeAreaBackgroundView)
        view.addSubview(topLabel)
        
        
        NSLayoutConstraint.activate([
            safeAreaBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            safeAreaBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            safeAreaBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            safeAreaBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            topLabel.bottomAnchor.constraint(equalTo: safeAreaBackgroundView.bottomAnchor),
            topLabel.heightAnchor.constraint(equalToConstant: 32),
            topLabel.centerXAnchor.constraint(equalTo: safeAreaBackgroundView.centerXAnchor),
        ])
    }
    
    func fetchRepos(page: Int = 1, refresh: Bool = false) {
        guard !isLoading else { return }
        
        isLoading = true
        NetworkManager.shared.fetchRepos(page: page) { [weak self] result in
            self?.handleFetchResult(result, refresh: refresh)
        }
    }
    
    private func handleFetchResult(_ result: Result<[Repository], Error>, refresh: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.isLoading = false
            
            switch result {
            case .success(let repos):
                self.updateRepos(repos, refresh: refresh)
            case .failure(let error):
                self.handleError(error)
            }
            
            if self.tableView.refreshControl?.isRefreshing == true {
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    private func updateRepos(_ repos: [Repository], refresh: Bool) {
        if refresh {
            self.repos.removeAll()
            self.repos.append(contentsOf: repos)
        } else {
            self.repos.append(contentsOf: repos)
        }
        self.tableView.reloadData()
    }
    
    private func handleError(_ error: Error) {
        print("Error fetching repos: \(error)")
        
        let alert = UIAlertController(title: "Error", message: "Failed to fetch repos. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemComponentCell", for: indexPath) as? ListItemComponentCellView else {
            return UITableViewCell()
        }
        
        let repo = repos[indexPath.row]
        cell.configure(with: repo)
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectedBackgroundView
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedRepo = repos[indexPath.row]
        let cardVC = CardViewController()
        cardVC.item = selectedRepo
        
        navigationController?.pushViewController(cardVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight * 2 && !isLoading && hasMoreData {
            currentPage += 1
            fetchRepos(page: currentPage)
        }
    }
}

