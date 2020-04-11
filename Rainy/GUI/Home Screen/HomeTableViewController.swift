//
//  HomeTableViewController.swift
//
//
//  Created by Andrea Gottardo on 10/11/17.
//

import CoreLocation
import UIKit

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
        title = viewModel.locationsManager.currentLocation?.displayName ?? "Rainy"
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startRefresh()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showLocationPickerIfFirstStart()
    }

    private func setupTableView() {
        tableView.register(CurrentInfoTableViewCell.self)
        tableView.register(HourlyTableViewCell.self)
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
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in _: UITableView) -> Int {
        1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        guard viewModel.locationsManager.currentLocation != nil else {
            return 0
        }

        guard let wu = viewModel.latestWU,
            let hourlyData = wu.hourly?.data else {
            return 1
        }

        return 1 + hourlyData.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: CurrentInfoTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(with: viewModel.latestWU,
                           location: viewModel.locationsManager.currentLocation)
            return cell

        default:
            let cell: HourlyTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            guard let wu = viewModel.latestWU,
                let hourlyData = wu.hourly?.data else {
                Log.info("No hourly weather data available yet.")
                return cell
            }
            let currentData = hourlyData[indexPath.row - 1]
            cell.configure(using: currentData,
                           previous: hourlyData[safe: indexPath.row - 2],
                           timeFormatter: timeFormatter)
            cell.selectionStyle = .default
            return cell
        }
    }

    override func tableView(_: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row > 0 else {
            // Do not show trailing swipe action on the first cell.
            return nil
        }
        let detailsAction = UIContextualAction(
            style: .normal,
            title: nil
        ) { [weak self] _, _, completion in
            guard let self = self, let wu = self.viewModel.latestWU,
                let hourlyData = wu.hourly?.data else {
                Log.info("No hourly weather data to show.")
                return
            }

            let detailsVC = StoryboardScene.Main.hourlyDetail.instantiate()
            let data = hourlyData[indexPath.row - 1]
            detailsVC.viewModel = HourlyDetailViewModel(hourlyData: data)
            self.present(UINavigationController(rootViewController: detailsVC), animated: true, completion: nil)
            completion(true)
        }
        detailsAction.image = UIImage(systemName: "list.dash")
        detailsAction.backgroundColor = .systemOrange
        return UISwipeActionsConfiguration(actions: [detailsAction])
    }

    override func tableView(_: UITableView,
                            heightForRowAt _: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    // MARK: - View model delegate

    func didStartFetchingData() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.beginRefreshing()
        }
    }

    func didEndFetchingData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }

    func didChangeStatus(newStatus _: FetchStatus) {}

    func didOccurError(error: NSError) {
        DispatchQueue.main.async {
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
}

extension HomeTableViewController: SettingsViewControllerDelegate {
    func didChangeTempUnitSetting(toUnit _: TempUnit) {
        tableView.reloadData()
    }
}

extension HomeTableViewController: LocationsListDelegate {
    func currentLocationWasChanged() {
        title = viewModel.locationsManager.currentLocation?.displayName
        viewModel.startFetching()
    }
}
