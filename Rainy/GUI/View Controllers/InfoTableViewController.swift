//
//  InfoTableViewController.swift
//  Created by Andrea Gottardo on 11/11/17.
//

import UIKit
import SafariServices

protocol InfoTableViewControllerDelegate: class {
    func didChangeTempUnitSetting(toUnit unit: TempUnit)
}

/**
 Provides a view for settings and information regarding the app.
 */
class InfoTableViewController: UITableViewController {
    struct Constants {
        static let masterRowHeight: CGFloat = 155.0
        static let otherRowsHeight: CGFloat = 44.0
    }
    
    enum Row: Int, CaseIterable {
        case master
        case units
        case darksky
        case aboutme
        
        var height: CGFloat {
            switch self {
            case .master:
                return Constants.masterRowHeight
                
            case .units, .darksky, .aboutme:
                return Constants.otherRowsHeight
            }
        }
    }
    
    var visibleRows: [Row] = Row.allCases
    /// Allows the user to pick between Celsius and Fahrenheit.
    @IBOutlet weak var tempUnitsControl: UISegmentedControl!
    /// Main view controller delegate
    weak var delegate: InfoTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGUI()
    }
    
    /// Lets the main view controller subscribe to unit changes updates.
    ///
    /// - Parameter delegate: main view controller
    func setDelegate(_ delegate: InfoTableViewControllerDelegate) {
        self.delegate = delegate
    }

    /// Sets the correct font types and sizes on the GUI elements.
    private func setupGUI() {
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.font: UIFont(name: "StagSans-Book", size: 20)!]
        let font = UIFont.init(name: "StagSans-Book", size: 13)
        tempUnitsControl.setTitleTextAttributes([NSAttributedString.Key.font: font!],
                                                for: .normal)
        tempUnitsControl.selectedSegmentIndex = TempUnitCoordinator.getCurrentTempUnit().rawValue
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.allCases.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.visibleRows[indexPath.row].height
    }

    @IBAction func didPressDoneButton(_ sender: Any) {
        dismiss(animated: true) {}
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = self.visibleRows[indexPath.row]
        
        switch row {
        case .darksky:
            presentSafariVCWithURL(url: "https://darksky.net/dev")
            
        case .aboutme:
            presentSafariVCWithURL(url: "https://gottardo.me/rainy")
            
        case .master, .units:
            break
        }
    }

    /**
     Opens a Safari View Controller with the given URL.
     - Parameter url: the URL to display in the Safari view controller
    */
    private func presentSafariVCWithURL(url: String) {
        let svc = SFSafariViewController(url: URL(string: url)!)
        self.present(svc, animated: true, completion: nil)
    }

    @IBAction func didChangeTempUnits(_ sender: Any) {
        guard let newUnit = TempUnit(rawValue: tempUnitsControl.selectedSegmentIndex) else {
            NSLog("Failed to determine newly selected temperature unit.")
            return
        }
        TempUnitCoordinator.setCurrentTempUnit(newValue: newUnit)
        self.delegate?.didChangeTempUnitSetting(toUnit: newUnit)
    }

}
