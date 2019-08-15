//
//  HomeTableViewController.swift
//  
//
//  Created by Andrea Gottardo on 10/11/17.
//

import UIKit
import CoreLocation

class HomeTableViewController: UITableViewController {
    struct Constants {
        static let stagSans = UIFont(name: "StagSans-Semibold", size: 20.0)!
    }

    let provider: Provider = DarkSkyProvider()
    var locBrain: LocationBrain!
    var latestWU: WeatherUpdate?
    var localityName: String?
    var insight = "Welcome back. Please wait while I fetch your weather..."

    override func viewDidLoad() {
        super.viewDidLoad()
        self.locBrain = LocationBrain(delegate: self)
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.font: Constants.stagSans]
        
        startRefresh()
        self.refreshControl?.addTarget(self, action: #selector(startRefresh), for: .valueChanged)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let wu = self.latestWU,
            let hourlyData = wu.hourly?.data else {
            return 1
        }
        
        return 1 + hourlyData.count
    }

    /**
    Creates a cell for the hourly weather information.
    */
    private func newHourlyCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "hourlyStubCell", for: indexPath) as! HourlyStubTableViewCell
        guard let wu = self.latestWU,
            let hourlyData = wu.hourly?.data else {
                return cell
        }
        let hourly = hourlyData[indexPath.row-1]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h a"
        if let time = hourly.time {
            let hourStr = dateFormatter.string(from: Date.init(timeIntervalSince1970: TimeInterval(time)))
            cell.timeLabel.text = hourStr
        }
        
        if let temperature = hourly.temperature {
            switch TempUnitCoordinator.getCurrentTempUnit() {
            case .celsius:
                cell.temperatureLabel.text = String(lround(0.55555*((temperature)-32))) + "°"
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
            cell.insightLabel.text = insight
            return cell
        } else {
            return newHourlyCell(indexPath)
        }
    }

    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 115
        } else {
            return 51
        }
    }

    /**
    Returns a String with the given Double temperature.
     - Todo: this expects the API to always return a temperature
     expressed in Fahrenheit, just like DarkSky.net does. We gotta abstract
     this.
    */
    private func tempToString(temp: Double) -> String {
        switch TempUnitCoordinator.getCurrentTempUnit() {
        case .celsius:
            return String(lround(0.55555*((temp)-32))) + "°"
        case .fahrenheit:
            return String(lround(temp)) + "°"
        }
    }

    /**
    Produces a human-readable message describing the current
    weather conditions.
     */
    private func generateWeatherInsight() {
        guard let wu = self.latestWU,
            let temperature = wu.currently?.temperature,
            let summary = wu.currently?.summary else {
                return
        }

        let temperatureString = tempToString(temp: temperature)
        
        if let localityName = self.localityName {
            self.insight = "It's \(temperatureString) and \(summary.lowercased()) in \(localityName).\n"
        } else {
            self.insight = "It's \(temperatureString) and \(summary.lowercased()).\n"
        }

        // The two variables here contain the precipitation amount expected
        // in the next 18 hours, and in the next 6 hours (close).
        var totalRainSum = 0.0
        var totalRainSumClose = 0.0
        var counter = 0
        while counter < 18 {
            guard let hourlyData = wu.hourly?.data?[counter] else {
                continue
            }
            
            totalRainSum += hourlyData.precipIntensity ?? 0.0
            counter += 1
        }
        counter = 0
        while counter < 6 {
            guard let hourlyData = wu.hourly?.data?[counter] else {
                continue
            }
            
            totalRainSumClose += hourlyData.precipIntensity ?? 0.0
            counter += 1
        }

        if totalRainSumClose > 0.20 {
            self.insight += "Rain everywhere... so depressing! 😭"
        } else if totalRainSum > 0.20 {
            self.insight += "Remember the umbrella. It's going to rain soon. ☹️"
        } else {
            self.insight += "Awesome! No rain expected any time soon. 😎"
        }
    }

    /**
     Allows the user to share the current weather conditions by means of a
     text snippet, shared with the UIActivityViewController API.
    */
    @IBAction func didPressShareButton(_ sender: Any) {
        let contr = UIActivityViewController(activityItems: [self.insight], applicationActivities: nil)
        self.present(contr, animated: true)
    }

    // MARK: - Communication with model

    @objc private func startRefresh() {
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Fetching weather information...",
                                                                  attributes: [NSAttributedString.Key.font: Constants.stagSans])
        self.refreshControl?.beginRefreshing()
        locBrain.start()
    }

    private func presentNewData(wu: WeatherUpdate) {
        self.latestWU = wu
        self.generateWeatherInsight()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh! 😍", attributes: [NSAttributedString.Key.font: Constants.stagSans])
        }
    }

    /**
     Called by the LocationBrainDelegate once the user location has been found.
    */
    func newLocationAvailable(location: CLLocationCoordinate2D) {
        let font = UIFont(name: "StagSans-Book", size: 12.0)
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Fetching the latest weather information...", attributes: [NSAttributedString.Key.font: font!])

        provider.getWeatherDataForCoordinates(coordinates: location) { result in
            
            switch result {
            case .success(let weatherUpdate):
                self.presentNewData(wu: weatherUpdate)
                
            case .failure(let error):
                let alert = UIAlertController(title: "An error occurred.",
                                              message: "Sorry, we had a problem fetching your weather: " + error.localizedDescription,
                                              preferredStyle: .alert)
                self.present(alert, animated: true)
            }
            
        }
    }

    /**
     Called by the LocationBrain if a error verifies while fetching the user
     location.
     - Todo: implement fallbacks on earlier iOS versions.
     */
    func locationErrorOccurred() {
        let controller: UIAlertController = UIAlertController(title: "Unable to obtain your location ☹️",
                                                              message: NSLocalizedString("Rainy can't download the latest weather data because you denied Rainy access to your location. You cannot use Rainy until you have enabled Location Services. Go to the Settings app and enable Location for Rainy, then come back here to get your weather.", comment: ""),
                                                              preferredStyle: .actionSheet)
        let goToLocs = UIAlertAction(title: "Take me there!", style: .default) { (_) in
            guard let urlGeneral = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            UIApplication.shared.open(urlGeneral)
        }
        controller.addAction(goToLocs)
        present(controller, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navVC = segue.destination as? UINavigationController,
            let settingsVC = navVC.viewControllers.first as? InfoTableViewController else {
            return
        }
        settingsVC.setDelegate(self)
    }
}

extension HomeTableViewController: InfoTableViewControllerDelegate {
    func didChangeTempUnitSetting(toUnit unit: TempUnit) {
        self.tableView.reloadData()
    }
}

extension HomeTableViewController: LocationBrainDelegate {
    func didFetchLocation(location: CLLocationCoordinate2D, name: String?) {
        NSLog("Got a location!")
        self.newLocationAvailable(location: location)
        self.localityName = name
    }
    
    func didErrorOccur(error: NSError) {
        let alert = UIAlertController(title: "A location error did occur", message: error.localizedDescription, preferredStyle: .alert)
        self.present(alert, animated: true)
    }
    
    
}
