//
//  HomeTableViewController.swift
//  Rainy
//
//  Created by Andrea Gottardo on 10/11/17.
//  Copyright © 2017 Andrea Gottardo. All rights reserved.
//

import CoreLocation
import SafariServices
import UIKit

/// Home screen view controller.
class HomeTableViewController: UITableViewController, HomeTableViewModelDelegate {
    struct Constants {
        static let defaultFont = UIFont.systemFont(ofSize: 20.0)
    }

    var viewModel: HomeTableViewModel!

    @IBOutlet var locationsButton: UIBarButtonItem!

    lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeTableViewModel(delegate: self)
        title = viewModel.locationsManager.currentLocation?.displayName ?? "Welcome to Rainy"
        setupTableView()
        setupObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startRefresh()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showLocationPickerIfFirstStart()
    }

    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(currentLocationWasChanged), name: NotificationName.currentLocationDidChange.name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(themeWasChanged), name: NotificationName.themeDidChange.name, object: nil)
    }

    private func setupTableView() {
        tableView.register(FiveDaysTableViewCell.self)
        tableView.register(HourlyTableViewCell.self)
        tableView.register(WeatherAlertTableViewCell.self)
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(startRefresh), for: .valueChanged)
    }

    private func showLocationPickerIfFirstStart() {
        guard viewModel.locationsManager.currentLocation == nil else {
            return
        }
        Log.debug("Showing location picker on first launch.")
        let alert = UIAlertController(title: "Welcome to Rainy.",
                                      message: "To get started, we need to pick a location.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Let's do it!", style: .cancel) { [weak self] _ in
            self?.didPressLocationsButton(alert)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }

    @objc private func startRefresh() {
        viewModel.startFetching()
    }

    @IBAction func didPressLocationsButton(_: Any) {
        let vc = StoryboardScene.Locations.locationsList.instantiate()
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.visibleRows.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellEnum = viewModel.visibleRows[safe: indexPath.row] else {
            Log.error("No cell enum at \(indexPath)")
            return UITableViewCell()
        }
        switch cellEnum {
        case let .fourDays(dailyConditions):
            let cell: FiveDaysTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(with: dailyConditions,
                           location: viewModel.locationsManager.currentLocation)
            return cell

        case let .hourly(condition):
            let cell: HourlyTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            let previousData: HourCondition? = viewModel
                .visibleRows[safe: indexPath.row - 1]
                .flatMap {
                    switch $0 {
                    case let .hourly(condition):
                        return condition
                    default:
                        return nil
                    }
                }
            cell.configure(using: condition,
                           previous: previousData,
                           timeFormatter: timeFormatter)
            cell.selectionStyle = .default
            return cell

        case let .alert(alert):
            let cell: WeatherAlertTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(with: alert)
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
            return cell

        case .dayHeader:
            Log.error("Not implemented.")
            assertionFailure()
            return UITableViewCell()
        }
    }

    override func tableView(_: UITableView,
                            heightForRowAt _: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cellEnum = viewModel.visibleRows[safe: indexPath.row] else {
            return
        }
        switch cellEnum {
        case let .alert(alert):
            guard let url = alert.uri else {
                return
            }
            let svc = SFSafariViewController(url: url)
            svc.preferredBarTintColor = alert.severity.color
            svc.preferredControlTintColor = .label
            present(svc, animated: true, completion: nil)

        default:
            return
        }
    }

    // MARK: - View model delegate

    func didStartFetchingData() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.beginRefreshing()
        }
    }

    func didEndFetchingData() {
        DispatchQueue.main.async {
            Vibration.success()
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }

    func didOccurError(error: NSError) {
        DispatchQueue.main.async {
            Vibration.error()
            let controller: UIAlertController = UIAlertController(title: "An error occurred ☹️",
                                                                  message: error.localizedDescription,
                                                                  preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(controller, animated: true)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        guard let navVC = segue.destination as? UINavigationController,
            let settingsVC = navVC.viewControllers.first as? SettingsViewController else {
            return
        }
        settingsVC.setDelegate(self)
    }

    @objc func currentLocationWasChanged() {
        title = viewModel.locationsManager.currentLocation?.displayName
        viewModel.startFetching()
    }

    @objc func themeWasChanged() {
        tableView.reloadData()
    }
}

extension HomeTableViewController: SettingsViewControllerDelegate {
    func didChangeTempUnitSetting(toUnit _: TemperatureUnit) {
        tableView.reloadData()
    }
}
