//
//  LocationsListViewController.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-08.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import UIKit

class LocationsListViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
    }

    private func setupSearchController() {
        let resultsVC = StoryboardScene.Locations.locationPicker.instantiate()
        searchController = UISearchController(searchResultsController: resultsVC)
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.delegate = resultsVC
        searchController.searchBar.placeholder = "Add Locations"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension LocationsListViewController: UITableViewDelegate {}

extension LocationsListViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        LocationsManager.shared.locations.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = LocationsManager.shared.locations[safe: indexPath.row]?.displayName
        return cell
    }
}

extension LocationsListViewController: UISearchControllerDelegate {}

extension LocationsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for _: UISearchController) {
        Log.debug("test")
    }
}

extension LocationsListViewController: UISearchBarDelegate {}
