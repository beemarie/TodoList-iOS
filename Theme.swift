/**
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation
import UIKit

enum Theme: String {
    case Light, Dark

    var mainColor: UIColor {
        switch self {
        case .Light:
            return UIColor.white()
        case .Dark:
            let red: CGFloat = 47.0 / 255.0
            let green: CGFloat = 73.0 / 255.0
            let blue: CGFloat = 98.0 / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }

    var secondaryColor: UIColor {
        switch self {
        case .Light:
            return UIColor.white()
        case .Dark:
            let red: CGFloat = 21.0 / 255.0
            let green: CGFloat = 35.0 / 255.0
            let blue: CGFloat = 51.0 / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }

    var fontColor: UIColor {
        switch self {
        case .Light:
            return UIColor.black()
        case .Dark:
            return UIColor.white()
        }
    }

    var accessoryColor: UIColor {
        switch self {
        case .Light:
            let red: CGFloat = 15.0 / 255.0
            let green: CGFloat = 155.0 / 255.0
            let blue: CGFloat = 228.0 / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        case .Dark:
            let red: CGFloat = 15.0 / 255.0
            let green: CGFloat = 155.0 / 255.0
            let blue: CGFloat = 228.0 / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }

    var navBarColor: UIColor {
        switch self {
        case .Light:
            let red: CGFloat = 247.0 / 255.0
            let green: CGFloat = 247.0 / 255.0
            let blue: CGFloat = 247.0 / 255.0
            let alpha: CGFloat = 0.82
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        case .Dark:
            let red: CGFloat = 18.0 / 255.0
            let green: CGFloat = 38.0 / 255.0
            let blue: CGFloat = 57.0 / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }

    var checkmarkColor: String {
        switch self {
        case .Light:
            return "blue_checkmark"
        case .Dark:
            return "clear_checkmark"
        }
    }
}

let selectedTheme = "Selected Theme"

struct ThemeManager {

    static func currentTheme() -> Theme {
        if let storedTheme = NSUserDefaults.standard().object(forKey: selectedTheme) as? String {
            return Theme(rawValue: storedTheme)!
        } else {
            return .Dark
        }
    }

    static func switchTheme() {
        if currentTheme().rawValue == "Dark" {
            applyTheme(theme: .Light)
        } else {
            applyTheme(theme: .Dark)
        }

    }
    static func applyTheme(theme: Theme) {
        NSUserDefaults.standard().set(theme.rawValue, forKey: selectedTheme)
        NSUserDefaults.standard().synchronize()

        // Setup Navigation Bar
        UINavigationBar.appearance().barTintColor = theme.navBarColor
        UINavigationBar.appearance().tintColor = theme.accessoryColor
        UINavigationBar.appearance().titleTextAttributes =
            [ NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 17)!,
              NSForegroundColorAttributeName: theme.accessoryColor]
    }

    static func gradientLayer(layer: CAGradientLayer?, view: UITableView)
        -> CAGradientLayer {

        var gradientLayer: CAGradientLayer

        if layer != nil {
            layer!.removeFromSuperlayer()
            gradientLayer = layer!
        } else {
            gradientLayer = CAGradientLayer()
        }
        gradientLayer.frame = view.frame
        gradientLayer.locations = [0.0, 1]
        gradientLayer.colors = [ ThemeManager.currentTheme().mainColor.cgColor,
                                 ThemeManager.currentTheme().secondaryColor.cgColor]

        view.layer.insertSublayer(gradientLayer, at: 0)

        let backgroundView = UIView(frame: view.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        view.backgroundView = backgroundView

        return gradientLayer
    }
}
