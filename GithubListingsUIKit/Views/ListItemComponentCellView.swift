//
//  ListItemComponentCellView.swift
//  GithubListingsUIKit
//
//  Created by Vincent Palma on 2024-09-03.
//

import Foundation
import UIKit

class ListItemComponentCellView: UITableViewCell {
    
    private let cellView: CellView = {
        let view = CellView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(cellView)
        
        //Changable spacing in tableviewcontroller with constraints
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 12),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configure(with item: Repository) {
        cellView.configure(with: item)
    }
}
