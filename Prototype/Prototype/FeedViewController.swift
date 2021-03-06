//
//  FeedViewControllerTableViewController.swift
//  Prototype
//
//  Created by Shreya Pallan on 15/06/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import UIKit

struct FeedImageViewModel {
    let description: String?
    let location: String?
    let imageName: String
}

class FeedViewController: UITableViewController {
    
    private let feed = FeedImageViewModel.prototypeFeed
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedImageCell")! as! FeedImageCell
        let model = feed[indexPath.row]
        cell.configure(with: model)
        return cell
    }
}


extension FeedImageCell {
    
    func configure(with model: FeedImageViewModel) {
        locationLabel.text = model.location
        locationContainer.isHidden = model.location == nil
        descriptionLabel.text = model.description
        descriptionLabel.isHidden = model.description == nil
//        feedImageView.image = UIImage(named: model.imageName)
        
        fadeIn(UIImage(named: model.imageName))
    }
}
