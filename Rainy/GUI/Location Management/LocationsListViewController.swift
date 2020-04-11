//
//  LocationsListViewController.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-08.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import UIKit

class LocationsListViewModel {
    var locationsManager: LocationsManager

    var locations: [Location] {
        LocationsManager.shared.locations
    }

    init(locationsManager: LocationsManager = .shared) {
        self.locationsManager = locationsManager
    }
}

protocol LocationsListDelegate: AnyObject {
    func currentLocationWasChanged()
}

class LocationsListViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var searchController: UISearchController!
    lazy var viewModel: LocationsListViewModel! = LocationsListViewModel()
    weak var delegate: LocationsListDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
    }

    private func setupSearchController() {
        let resultsVC = StoryboardScene.Locations.locationPicker.instantiate()
        resultsVC.delegate = self
        searchController = UISearchController(searchResultsController: resultsVC)
        searchController.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.delegate = resultsVC
        searchController.searchBar.placeholder = "Add Locations"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LocationTableViewCell.self)
    }
}

extension LocationsListViewController: LocationPickerDelegate {
    func didPickLocation(location _: Location) {
        searchController.searchBar.text = nil
        searchController.dismiss(animated: true) { [weak self] in
            self?.tableView.reloadData()
            self?.delegate?.currentLocationWasChanged()
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

    func tableView(_: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: nil
        ) { [weak self] _, _, completion in
            guard let self = self else { return }
            self.tableView.beginUpdates()
            self.viewModel.locationsManager.locations.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .left)
            completion(true)
            self.tableView.endUpdates()
        }
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

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

        delegate?.currentLocationWasChanged()
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
