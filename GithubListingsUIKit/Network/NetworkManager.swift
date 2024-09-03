//
//  NetworkManafer.swift
//  GithubListingsUIKit
//
//  Created by Vincent Palma on 2024-08-07.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com/search/repositories?q=stars:>1&sort=stars"
    
    private init() {}
    
    func fetchRepos(page: Int, completion: @escaping (Result<[Repository], Error>) -> Void) {
        let urlString = "\(baseURL)&page=\(page)"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Items.self, from: data)
                completion(.success(response.items))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
