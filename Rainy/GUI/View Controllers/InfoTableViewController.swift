//
//  InfoTableViewController.swift
//  Created by Andrea Gottardo on 11/11/17.
//

import SafariServices
import Sentry
import UIKit

protocol InfoTableViewControllerDelegate: AnyObject {
    func didChangeTempUnitSetting(toUnit unit: TempUnit)
}

class InfoTableViewModel {
    let settingsManager: SettingsManager

    init(settingsManager: SettingsManager = .shared) {
        self.settingsManager = settingsManager
    }
}

/**
 Provides a view for settings and information regarding the app.
 */
class InfoTableViewController: UITableViewController {
    enum Section: Int, CaseIterable {
        case general
        case diagnostics
    }

    enum GeneralRow: Int, CaseIterable {
        case master
        case units
        case darksky
        case aboutme
    }

    enum DiagnosticsRow: Int, CaseIterable {
        case enable
    }

    var visibleSections: [Section] {
        Section.allCases
    }

    var visibleGeneralRows: [GeneralRow] {
        GeneralRow.allCases
    }

    var visibleDiagnosticsRows: [DiagnosticsRow] {
        DiagnosticsRow.allCases
    }

    /// Allows the user to pick between Celsius and Fahrenheit.
    @IBOutlet var tempUnitsControl: UISegmentedControl!
    @IBOutlet var diagnosticsSwitch: UISwitch!

    lazy var viewModel = InfoTableViewModel()
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
        tempUnitsControl.selectedSegmentIndex = viewModel.settingsManager.temperatureUnit.rawValue
        diagnosticsSwitch.isOn = viewModel.settingsManager.diagnosticsEnabled
    }

    // MARK: - Table view data source

    override func numberOfSections(in _: UITableView) -> Int {
        visibleSections.count
    }

    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = visibleSections[safe: section] else {
            return 0
        }
        switch section {
        case .general:
            return visibleGeneralRows.count

        case .diagnostics:
            return visibleDiagnosticsRows.count
        }
    }

    override func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    @IBAction func didPressDoneButton(_: Any) {
        dismiss(animated: true) {}
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = visibleGeneralRows[indexPath.row]

        switch row {
        case .darksky:
            presentSafariVCWithURL(urlString: "https://darksky.net/dev")

        case .aboutme:
            presentSafariVCWithURL(urlString: "https://gottardo.me/")

        case .master, .units:
            break
        }
    }

    /**
     Opens a Safari View Controller with the given URL.
     - Parameter url: the URL to display in the Safari view controller
     */
    private func presentSafariVCWithURL(urlString: String) {
        guard let url = URL(string: urlString) else {
            Log.error("Passed an invalid URL: \(urlString)")
            return
        }
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }

    @IBAction func didChangeTempUnits(_: Any) {
        guard let newUnit = TempUnit(rawValue: tempUnitsControl.selectedSegmentIndex) else {
            Log.error("Failed to determine newly selected temperature unit.")
            return
        }
        viewModel.settingsManager.temperatureUnit = newUnit
        delegate?.didChangeTempUnitSetting(toUnit: newUnit)
    }

    @IBAction func didChangeDiagnosticsSwitch(_ sender: Any) {
        guard let switchControl = sender as? UISwitch else {
            Log.error("Switch outlet mismatched type.")
            return
        }
        viewModel.settingsManager.diagnosticsEnabled = switchControl.isOn
        Client.shared?.enabled = switchControl.isOn as NSNumber
    }
}
