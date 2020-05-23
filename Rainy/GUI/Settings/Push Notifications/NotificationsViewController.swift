//
//  NotificationsViewController.swift
//  Rainy
//
//  Created by Andrea Gottardo on 2020-05-09.
//  Copyright © 2020 Andrea Gottardo. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {
    var visibleSections: [Section] {
        Section.allCases
    }

    var visibleEnableCells: [EnableCell] {
        EnableCell.allCases
    }

    var visibleNotificationCells: [NotificationCell] {
        NotificationCell.allCases
    }

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        let options: UNAuthorizationOptions = [
            .alert,
            .badge,
            .criticalAlert,
            .providesAppNotificationSettings,
            .sound,
        ]
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: options) { didAuthorize, error in
            DispatchQueue.main.async {
                if let error = error {
                    Log.error(error.localizedDescription)
                    UIAlertController.present(withError: .couldNotRegisterForPushNotifications, inController: self)
                    return
                }

                guard didAuthorize else {
                    Log.warning("Did not authorize push notifications.")
                    UIAlertController.present(withError: .systemNotificationsDisabled, inController: self)
                    return
                }

                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    private func setupTableView() {
        tableView.register(LabelTableViewCell.self)
        tableView.register(SwitchTableViewCell.self)
    }
}

extension NotificationsViewController: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        visibleSections.count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = visibleSections[safe: section] else {
            return 0
        }

        switch section {
        case .enableAndLocation:
            return visibleEnableCells.count

        case .notifications:
            return visibleNotificationCells.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SwitchTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)

        guard let section = visibleSections[safe: indexPath.section] else {
            return cell
        }

        switch section {
        case .enableAndLocation:
            guard let cellEnum = visibleEnableCells[safe: indexPath.row] else {
                return cell
            }
            switch cellEnum {
            case .enable:
                cell.configure(title: cellEnum.localizedString,
                               description: nil,
                               isOn: SettingsManager.shared.notificationsEnabled)

            case .location:
                let cell: LabelTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configure(title: cellEnum.localizedString, description: LocationsManager.shared.currentLocation?.displayName)
                return cell
            }

        case .notifications:
            guard let cellEnum = visibleNotificationCells[safe: indexPath.row] else {
                return cell
            }
            cell.configure(title: cellEnum.localizedString, description: cellEnum.longDescription, isOn: true) // TODO:
        }

        return cell
    }

    func tableView(_: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let section = visibleSections[safe: section],
            section == .notifications else {
            return nil
        }
        return "Warning: Rainy notifications are and should not be considered a replacement to the weather alert services that might be provided in your area by local authorities. Do not rely on this service for emergencies, as its accuracy and reliability cannot be guaranteed."
    }
}

extension NotificationsViewController: UITableViewDelegate {}
