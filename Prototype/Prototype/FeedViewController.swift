//
//  FeedViewControllerTableViewController.swift
//  Prototype
//
//  Created by Shreya Pallan on 15/06/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import UIKit

class FeedViewController: UITableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "FeedImageCell")!
    }
}
