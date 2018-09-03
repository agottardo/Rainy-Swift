//
//  HomeTableViewController.swift
//  
//
//  Created by Andrea Gottardo on 10/11/17.
//

import UIKit
import CoreLocation

class HomeTableViewController: UITableViewController {

    let provider : Provider = DarkSkyProvider()
    let locBrain = LocationBrain()
    var latestWU : WeatherUpdate?
    var insight  = "Welcome back. Please wait while I fetch your weather..."
    let stagSans = UIFont(name: "StagSans-Semibold", size: 20.0)
    
    override func viewDidAppear(_ animated: Bool) {
        self.refreshControl?.beginRefreshing()
        startRefresh()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locBrain.callbackHome = self
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.font: stagSans!]
        self.refreshControl?.beginRefreshing()
        startRefresh()
        self.refreshControl?.addTarget(self, action: #selector(startRefresh), for: .valueChanged)
    }

    func presentNewData(wu: WeatherUpdate) {
        latestWU = wu
        insight = weatherInsight()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh! 😍", attributes: [NSAttributedString.Key.font:self.stagSans!])
        }
    }

    @objc private func startRefresh() {
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Finding your location...", attributes: [NSAttributedString.Key.font:stagSans!])
        locBrain.start()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (latestWU != nil) {
            return 1 + latestWU!.hourlyStubs.count
        } else {
            return 1
        }
    }
    
    /**
    Creates a cell for the hourly weather information.
    */
    fileprivate func newHourlyCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell : HourlyStubTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "hourlyStubCell", for: indexPath) as! HourlyStubTableViewCell
        let hourlyStub = latestWU!.hourlyStubs[indexPath.row-1]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h a"
        let hourStr = dateFormatter.string(from: (hourlyStub.time))
        cell.timeLabel.text = hourStr
        if (UserDefaults.standard.bool(forKey: "fahren")) {
            // Fahrenheit selected
            cell.temperatureLabel.text = String(lround(hourlyStub.temperature)) + "°"
        } else {
            // Celsius selected
            cell.temperatureLabel.text = String(lround(0.55555*((hourlyStub.temperature)-32))) + "°"
        }
        cell.conditionLabel.text = hourlyStub.hourSummary
        var newFrame = cell.rainBox.frame;
        newFrame.size.width = CGFloat(10 + 20 * hourlyStub.precipProbability * 100 * hourlyStub.precipIntensity);
        cell.rainBox.frame = newFrame
        return cell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            // Assistant message at top.
            let cell : InsightTableViewCell = tableView.dequeueReusableCell(withIdentifier: "welcomeCell", for: indexPath) as! InsightTableViewCell
            cell.insightLabel.text = insight
            return cell
        } else {
            return newHourlyCell(indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 115
        } else {
            return 51
        }
    }
    
    func tempToString(temp: Double) -> String {
        if (UserDefaults.standard.bool(forKey: "fahren")) {
            // fahrenheit selected
            return String(lround(temp)) + "°"
        } else {
            // celsius selected
            return String(lround(0.55555*((temp)-32))) + "°"
        }
    }
    
    func weatherInsight() -> String {
        
        var sharedMessage = "Now: " + tempToString(temp: latestWU!.currentTemperature) + " - " + latestWU!.currentCondition + "\n"
        
        var totalRainSum = 0.0
        var totalRainSumClose = 0.0
        var counter = 0
        while (counter < 18) {
            totalRainSum+=latestWU!.hourlyStubs[counter].precipIntensity
            counter = counter + 1
        }
        counter = 0
        while (counter < 6) {
            totalRainSumClose+=latestWU!.hourlyStubs[counter].precipIntensity
            counter = counter + 1
        }
        if (totalRainSumClose > 0.20) {
            sharedMessage = sharedMessage + "Rain everywhere... so depressing! 😭"
        } else if (totalRainSum > 0.20) {
            sharedMessage = sharedMessage + "Remember the umbrella. It's going to rain soon. ☹️"
        } else {
            sharedMessage = sharedMessage + "Awesome! No rain expected any time soon. 😎"
        }
        return sharedMessage
    }

    @IBAction func didPressShareButton(_ sender: Any) {
        let contr = UIActivityViewController(activityItems: [weatherInsight()], applicationActivities: nil)
        present(contr, animated: true) { }
    }
    
    func newLocationAvailable(location: CLLocation) {
        let font = UIFont(name: "StagSans-Book", size:12.0)
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Fetching the latest weather information...", attributes: [NSAttributedString.Key.font:font!])
        let handler : (WeatherUpdate?, ProviderError?) -> Void = {
            if $1 != nil {
                let alert = UIAlertController(title: "Error", message: "Sorry, we had a problem fetching your weather.", preferredStyle: UIAlertController.Style.alert)
                self.present(alert, animated: true)
            } else {
                // Can safely force-unwrap here.
                self.presentNewData(wu: $0!)
            }
        }
        provider.getWeatherDataForCoordinates(coordinates: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), completion: handler)
    }
    
    func locationErrorOccurred() {
        let controller : UIAlertController = UIAlertController(title: "Unable to obtain your location ☹️", message: "Rainy can't download the latest weather data because you denied Rainy access to your location. You cannot use Rainy until you have enabled Location Services. Go to the Settings app and enable Location for Rainy, then come back here to get your weather.", preferredStyle: .actionSheet)
        let goToLocs = UIAlertAction(title: "Take me there!", style: .default) { (alertAction) in
            if !CLLocationManager.locationServicesEnabled() {
                if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION") {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                    } else {
                        // TODO: Fallback on earlier versions
                    }
                }
            } else {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                    } else {
                        // TODO: Fallback on earlier versions
                    }
                }
            }
        }
        controller.addAction(goToLocs)
        present(controller, animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
