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
        static let stagSans = UIFont(name: "StagSans-Semibold", size: 20.0)!
    }
    
    var viewModel: HomeTableViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = HomeTableViewModel(delegate: self)
        
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.font: Constants.stagSans]

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(startRefresh), for: .valueChanged)
        self.refreshControl?.beginRefreshing()
        
        self.startRefresh()
    }
    
    @objc private func startRefresh() {
        self.viewModel.startFetching()
    }

    // MARK: - Table view data source

    override func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        guard let wu = self.viewModel.latestWU,
            let hourlyData = wu.hourly?.data else {
            return 1
        }

        return 1 + hourlyData.count
    }

    /**
     Creates a cell for the hourly weather information.
     */
    private func newHourlyCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hourlyStubCell", for: indexPath) as! HourlyStubTableViewCell
        guard let wu = self.viewModel.latestWU,
            let hourlyData = wu.hourly?.data else {
            return cell
        }
        let hourly = hourlyData[indexPath.row - 1]

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h a"
        if let time = hourly.time {
            let hourStr = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(time)))
            cell.timeLabel.text = hourStr
        }

        if let temperature = hourly.temperature {
            switch TempUnitCoordinator.getCurrentTempUnit() {
            case .celsius:
                cell.temperatureLabel.text = String(lround(0.55555 * (temperature - 32))) + "°"
            case .fahrenheit:
                cell.temperatureLabel.text = String(lround(temperature)) + "°"
            }
        }

        if let summary = hourly.summary {
            cell.conditionLabel.isHidden = false
            cell.conditionLabel.text = summary
        } else {
            cell.conditionLabel.isHidden = true
        }

        if let precipProbability = hourly.precipProbability,
            let precipIntensity = hourly.precipIntensity {
            var newFrame = cell.rainBox.frame
            newFrame.size.width = CGFloat(10 + 20 * precipProbability * 100 * precipIntensity)
            cell.rainBox.frame = newFrame
        }

        return cell
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // Assistant message at top.
            let cell: InsightTableViewCell = tableView.dequeueReusableCell(withIdentifier: "welcomeCell", for: indexPath) as! InsightTableViewCell
            cell.insightLabel.text = self.viewModel.insight
            return cell
        } else {
            return newHourlyCell(indexPath)
        }
    }

    override func tableView(_: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: - View model delegate
    
    func didStartFetchingData() {
        DispatchQueue.main.async {
            self.refreshControl?.beginRefreshing()
        }
    }
    
    func didEndFetchingData() {
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func didChangeStatus(newStatus: FetchStatus) {
        DispatchQueue.main.async {
            self.refreshControl?.attributedTitle = NSAttributedString(string: newStatus.localizedString,
                                                                                attributes: [NSAttributedString.Key.font: Constants.stagSans])
        }
    }
    
    func didOccurError(error: NSError) {
        let controller: UIAlertController = UIAlertController(title: "An error occurred ☹️",
                                                              message: error.localizedDescription,
                                                              preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(controller, animated: true)
    }

    /// Called by the LocationBrain if a error verifies while fetching the user location.
    func locationErrorOccurred() {
        let controller: UIAlertController = UIAlertController(title: "Unable to obtain your location ☹️",
                                                              message: NSLocalizedString("Rainy can't download the latest weather data because you denied Rainy access to your location. You cannot use Rainy until you have enabled Location Services. Go to the Settings app and enable Location for Rainy, then come back here to get your weather.", comment: ""),
                                                              preferredStyle: .actionSheet)
        let goToLocs = UIAlertAction(title: "Take me there!", style: .default) { _ in
            guard let urlGeneral = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            UIApplication.shared.open(urlGeneral)
        }
        controller.addAction(goToLocs)
        present(controller, animated: true, completion: nil)
    }
    
    /// Allows the user to share the current weather conditions by means of a
    /// text snippet, shared with the UIActivityViewController API.
    @IBAction func didPressShareButton(_: Any) {
        let contr = UIActivityViewController(activityItems: [self.viewModel?.insight as Any], applicationActivities: nil)
        present(contr, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        guard let navVC = segue.destination as? UINavigationController,
            let settingsVC = navVC.viewControllers.first as? InfoTableViewController else {
            return
        }
        settingsVC.setDelegate(self)
    }
}

extension HomeTableViewController: InfoTableViewControllerDelegate {
    func didChangeTempUnitSetting(toUnit _: TempUnit) {
        tableView.reloadData()
    }
}

