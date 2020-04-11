//
//  ThemePickerViewController.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-11.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import UIKit

class ThemePickerViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ThemePickerTableViewCell.self)
    }
}

extension ThemePickerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        Theme.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ThemePickerTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(with: Theme.allCases[indexPath.row])
        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        44
    }

    func tableView(_: UITableView, titleForHeaderInSection _: Int) -> String? {
        "Choose a theme"
    }

    func tableView(_: UITableView, titleForFooterInSection _: Int) -> String? {
        "Applying a theme may require force restarting the app."
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        Theme.current = Theme.allCases[indexPath.row]
        tableView.reloadData()
    }
}
