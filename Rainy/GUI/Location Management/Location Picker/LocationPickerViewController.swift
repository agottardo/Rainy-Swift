//
//  LocationPickerViewController.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-08.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import CoreLocation
import MBProgressHUD
import UIKit

/// Used by objects that receive location changes updates.
protocol LocationPickerDelegate: AnyObject {
    func didPickLocation(location: Location)
}

final class LocationPickerViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var viewModel = LocationPickerViewModel()
    weak var delegate: LocationPickerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        tableView.register(LocationTableViewCell.self)
    }
}

extension LocationPickerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.locations.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LocationTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        guard let location = viewModel.locations[safe: indexPath.row] else {
            return cell
        }
        cell.configure(for: location)
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
            dismiss(animated: true, completion: nil)
        }

        guard let location = viewModel.locations[safe: indexPath.row] else {
            assertionFailure()
            return
        }

        viewModel.locationsManager.locations.append(location)
        viewModel.locationsManager.currentLocation = location
        delegate?.didPickLocation(location: location)
    }
}

extension LocationPickerViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        MBProgressHUD.showAdded(to: view, animated: true)
        searchBar.resignFirstResponder()

        guard let keyword = searchBar.text?.nilIfEmpty else {
            return
        }

        Log.debug("Searching for: \(keyword)")
        viewModel.search(placemarkKeyword: keyword, completion: { [weak self] result in
            guard let self = self else { return }
            MBProgressHUD.hide(for: self.view, animated: true)
            switch result {
            case .success:
                self.tableView.reloadData()

            case let .failure(error):
                let alert = UIAlertController(title: "Location Search Failed", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(.init(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
}
