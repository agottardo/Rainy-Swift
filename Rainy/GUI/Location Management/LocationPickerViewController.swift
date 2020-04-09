//
//  LocationPickerViewController.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-08.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import CoreLocation
import UIKit

class LocationPickerViewModel {
    var geoCoder: CLGeocoder
    var locations: [Location] = []

    init() {
        geoCoder = CLGeocoder()
    }

    func search(placemarkKeyword: String,
                completion: @escaping (Result<[Location], NSError>) -> Void) {
        geoCoder.geocodeAddressString(placemarkKeyword) { placemarks, error in
            if let error = error {
                Log.warning("CLGeocoder error: \(error)")
                // completion(.failure(error as NSError))
                return
            }

            guard let placemarks = placemarks else {
                Log.debug("No placemark results found.")
                self.locations = []
                completion(.success([]))
                return
            }

            let locations: [Location] = placemarks.compactMap {
                guard let coordinate = $0.location?.coordinate else {
                    Log.debug("Skipping placemark \($0) with no coordinates.")
                    return nil
                }
                return Location(placemark: $0, coordinate: coordinate)
            }
            self.locations = locations
            completion(.success(locations))
        }
    }
}

class LocationPickerViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var viewModel = LocationPickerViewModel()

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
}

extension LocationPickerViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        guard let keyword = searchBar.text?.nilIfEmpty else {
            return
        }

        Log.debug("Searching for: \(keyword)")
        viewModel.search(placemarkKeyword: keyword, completion: { result in
            switch result {
            case .success:
                self.tableView.reloadData()

            case let .failure(error):
                let alert = UIAlertController(title: "Could not search for locations.", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(.init(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
}
