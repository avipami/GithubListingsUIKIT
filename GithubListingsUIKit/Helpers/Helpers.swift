//
//  Helpers.swift
//  GithubListingsUIKit
//
//  Created by Vincent Palma on 2024-08-14.
//

import Foundation
class Helpers {
    static let shared = Helpers()
    
    private init() { }
    
    func githubTimeConverter(inString dateString: String) -> String {
        //format: "yyyy-MM-dd'T'HH:mm:ssZ"
        let isoDateFormatter = ISO8601DateFormatter()
        guard let date = isoDateFormatter.date(from: dateString) else { return "Invalid Date" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: date)
    }
}
