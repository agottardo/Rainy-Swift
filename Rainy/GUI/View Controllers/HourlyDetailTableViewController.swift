//
//  HourlyDetailTableViewController.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-04-06.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import UIKit

class HourlyDetailViewModel {
    enum Row: Int, CaseIterable {
        case precipitationIntensity
        case precipitationProbability
        case precipitationType
        case feelsLike
        case dewPoint
        case humidity
        case pressure
        case windSpeed
        case windGust
        case windBearing
        case cloudCover
        case uvIndex
        case visibility
        case ozone

        var localizedString: String {
            switch self {
            case .precipitationIntensity:
                return "Precipitation Intensity"
            case .precipitationProbability:
                return "Precipitation Probability"
            case .precipitationType:
                return "Precipitation Type"
            case .feelsLike:
                return "Feels Like"
            case .dewPoint:
                return "Dew Point"
            case .humidity:
                return "Humidity"
            case .pressure:
                return "Pressure"
            case .windSpeed:
                return "Wind Speed"
            case .windGust:
                return "Wind Gust"
            case .windBearing:
                return "Wind Bearing"
            case .cloudCover:
                return "Cloud Cover"
            case .uvIndex:
                return "UV Index"
            case .visibility:
                return "Visibility"
            case .ozone:
                return "Ozone"
            }
        }
    }

    public var visibleRows: [Row] {
        Row.allCases
    }

    public let hourlyData: HourCondition

    init(hourlyData: HourCondition) {
        self.hourlyData = hourlyData
    }
}

class HourlyDetailViewController: UIViewController {
    @IBOutlet var icon: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var conditionLabel: UILabel!
    @IBOutlet var tableView: UITableView!

    var viewModel: HourlyDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.reloadData()
    }
}

extension HourlyDetailViewController: UITableViewDataSource {
    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = viewModel.visibleRows[safe: indexPath.row] else {
            return UITableViewCell()
        }
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = row.localizedString
        return cell
    }

    // MARK: - Table view data source

    func numberOfSections(in _: UITableView) -> Int {
        1
    }

    func tableView(_: UITableView, titleForHeaderInSection _: Int) -> String? {
        "Conditions at TODO"
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.visibleRows.count
    }
}
