//
//  InfoTableViewController.swift
//  Created by Andrea Gottardo on 11/11/17.
//

import UIKit
import SafariServices

/**
 Provides a view for settings and information
 regarding the app.
 */
class InfoTableViewController: UITableViewController {
    
    /**
     Allows the user to pick between Celsius and Fahrenheit.
     */
    @IBOutlet weak var tempUnitsControl: UISegmentedControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGUI()
        
    }

    /**
     Sets the correct font types and sizes on the GUI elements.
     */
    private func setupGUI() {
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.font: UIFont(name: "StagSans-Book", size: 20)!]
        let font = UIFont.init(name: "StagSans-Book", size: 13)
        tempUnitsControl.setTitleTextAttributes([NSAttributedString.Key.font: font!],
                                                for: .normal)
    }
    
    /**
     Sets the value of the UI controls to their current value.
     */
    private func setupControls() {
        if UserDefaults.standard.bool(forKey: "fahren") {
            tempUnitsControl.selectedSegmentIndex = 1
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 155
        } else {
            return 44
        }
    }

    @IBAction func didPressDoneButton(_ sender: Any) {
        dismiss(animated: true) {}
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 2) {
            presentSafariVCWithURL(url: "https://darksky.net/dev")
        } else if (indexPath.row == 3) {
            presentSafariVCWithURL(url: "https://gottardo.me/rainy")
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
        if (tempUnitsControl.selectedSegmentIndex == 0) {
            // Celsius was selected
            UserDefaults.standard.set(false, forKey: "fahren")
        } else if (tempUnitsControl.selectedSegmentIndex == 1) {
            // Fahrenheit was selected
            UserDefaults.standard.set(true, forKey: "fahren")
        }
        UserDefaults.standard.synchronize()
    }
    

}
