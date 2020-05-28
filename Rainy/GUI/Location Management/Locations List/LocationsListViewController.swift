//
//  LocationsListViewController.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-08.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import MBProgressHUD
import UIKit

final class LocationsListViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var searchController: UISearchController!
    lazy var viewModel: LocationsListViewModel! = LocationsListViewModel()
    lazy var locationBrain = LocationBrain(delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
        setupBarItems()
    }

    private func setupBarItems() {
        let editButton = UIBarButtonItem(image: UIImage(systemName: "location"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(didPressLocationButton))
        navigationItem.leftBarButtonItem = editButton
    }

    private func setupSearchController() {
        let resultsVC = StoryboardScene.Locations.locationPicker.instantiate()
        resultsVC.delegate = self
        searchController = UISearchController(searchResultsController: resultsVC)
        searchController.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.delegate = resultsVC
        searchController.searchBar.placeholder = "Add a Location"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LocationTableViewCell.self)
    }

    @objc private func didPressLocationButton() {
        MBProgressHUD.showAdded(to: view, animated: true)
        locationBrain.start()
    }
}

extension LocationsListViewController: LocationPickerDelegate {
    func didPickLocation(location _: Location) {
        searchController.searchBar.text = nil
        searchController.dismiss(animated: true) { [weak self] in
            self?.tableView.reloadData()
            self?.dismiss(animated: true, completion: nil)
        }
    }
}

extension LocationsListViewController: UITableViewDelegate {}

extension LocationsListViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        guard !searchController.isActive else {
            // Hide all rows while the search controller is active.
            return 0
        }

        return viewModel.locations.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LocationTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        guard let location = viewModel.locations[safe: indexPath.row] else {
            assertionFailure()
            return cell
        }
        cell.configure(for: location)
        if location == viewModel.locationsManager.currentLocation {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }

    func tableView(_: UITableView, editingStyleForRowAt _: IndexPath) -> UITableViewCell.EditingStyle {
        guard viewModel.locations.count > 1 else {
            return .none
        }
        return .delete
    }

    func tableView(_: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            Log.error("Unhandled editingStyle: \(editingStyle)")
            return
        }
        viewModel.locationsManager.deleteLocation(at: indexPath.row)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        Vibration.selectionChanged()
        if let currentLocation = viewModel.locationsManager.currentLocation,
            let currentLocationIndex = viewModel.locations.firstIndex(of: currentLocation) {
            let previousCheckmarkIndexPath = IndexPath(row: currentLocationIndex, section: 0)
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [previousCheckmarkIndexPath], with: .fade)
        } else {
            self.tableView.beginUpdates()
        }

        viewModel.locationsManager.currentLocation = viewModel.locations[safe: indexPath.row]
        self.tableView.reloadRows(at: [indexPath], with: .fade)
        self.tableView.endUpdates()

        dismiss(animated: true, completion: nil)
    }
}

extension LocationsListViewController: UISearchBarDelegate {}

extension LocationsListViewController: UISearchControllerDelegate {
    func didPresentSearchController(_: UISearchController) {
        tableView.reloadData()
    }

    func didDismissSearchController(_: UISearchController) {
        tableView.reloadData()
    }
}

extension LocationsListViewController: LocationBrainDelegate {
    func didFetchLocation(location: Location) {
        MBProgressHUD.hide(for: view, animated: true)
        viewModel.locationsManager.locations.append(location)
        viewModel.locationsManager.currentLocation = location
        dismiss(animated: true, completion: nil)
    }

    func didErrorOccur(error: RainyError) {
        Log.error(error.localizedDescription)
        MBProgressHUD.hide(for: view, animated: true)
        let alert = UIAlertController(title: "Could not fetch current location.",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(.init(title: "Dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
