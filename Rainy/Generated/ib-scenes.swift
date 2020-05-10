// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Storyboard Scenes

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
    internal enum LaunchScreen: StoryboardType {
        internal static let storyboardName = "LaunchScreen"

        internal static let initialScene = InitialSceneType<UIKit.UIViewController>(storyboard: LaunchScreen.self)
    }

    internal enum Locations: StoryboardType {
        internal static let storyboardName = "Locations"

        internal static let locationPicker = SceneType<Rainy.LocationPickerViewController>(storyboard: Locations.self, identifier: "locationPicker")

        internal static let locationsList = SceneType<Rainy.LocationsListViewController>(storyboard: Locations.self, identifier: "locationsList")
    }

    internal enum Main: StoryboardType {
        internal static let storyboardName = "Main"

        internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: Main.self)

        internal static let hourlyDetail = SceneType<Rainy.HourlyDetailViewController>(storyboard: Main.self, identifier: "hourlyDetail")

        internal static let themePicker = SceneType<Rainy.ThemePickerViewController>(storyboard: Main.self, identifier: "themePicker")
    }

    internal enum PushNotifications: StoryboardType {
        internal static let storyboardName = "PushNotifications"

        internal static let notificationsHome = SceneType<Rainy.NotificationsViewController>(storyboard: PushNotifications.self, identifier: "notificationsHome")
    }
}

// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

internal protocol StoryboardType {
    static var storyboardName: String { get }
}

internal extension StoryboardType {
    static var storyboard: UIStoryboard {
        let name = storyboardName
        return UIStoryboard(name: name, bundle: Bundle(for: BundleToken.self))
    }
}

internal struct SceneType<T: UIViewController> {
    internal let storyboard: StoryboardType.Type
    internal let identifier: String

    internal func instantiate() -> T {
        let identifier = self.identifier
        guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
        }
        return controller
    }
}

internal struct InitialSceneType<T: UIViewController> {
    internal let storyboard: StoryboardType.Type

    internal func instantiate() -> T {
        guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
            fatalError("ViewController is not of the expected class \(T.self).")
        }
        return controller
    }
}

private final class BundleToken {}
