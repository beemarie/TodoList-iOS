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
            return UIColor(red: 47, green: 73, blue: 98, opacity: 1)
        }
    }

    var secondaryColor: UIColor {
        switch self {
        case .Light:
            return UIColor.white()
        case .Dark:
            return UIColor(red: 21, green: 35, blue: 51, opacity: 1)
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

    var navBarColor: UIColor {
        switch self {
        case .Light:
            return UIColor(red: 247, green: 247, blue: 247, opacity: 0.82)
        case .Dark:
            return UIColor(red: 18, green: 38, blue: 57, opacity: 1)
        }
    }
}

let selectedTheme = "Selected Theme"

struct ThemeManager {

    static let accessoryColor = UIColor(red: 15, green: 155, blue: 228, opacity: 1)

    static let placeHolderColor = UIColor(red: 189, green: 189, blue: 189, opacity: 0.5)

    static func currentTheme() -> Theme {
        if let storedTheme = NSUserDefaults.standard().object(forKey: selectedTheme) as? String {
            return Theme(rawValue: storedTheme)!
        } else {
            return .Dark
        }
    }

    static func switchTheme() {
        currentTheme().rawValue == "Dark" ? applyTheme(theme: .Light) : applyTheme(theme: .Dark)
    }

    static func applyTheme(theme: Theme) {
        NSUserDefaults.standard().set(theme.rawValue, forKey: selectedTheme)
        NSUserDefaults.standard().synchronize()

        // Setup Navigation Bar
        UINavigationBar.appearance().barTintColor = theme.navBarColor
        UINavigationBar.appearance().tintColor = accessoryColor
        UINavigationBar.appearance().titleTextAttributes =
            [ NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 17)!,
              NSForegroundColorAttributeName: accessoryColor]
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

    static func gradientLayer(layer: CAGradientLayer?, view: UIView)
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

            return gradientLayer
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, opacity: Double) {
        self.init(red  : CGFloat(red)/255,
                  green: CGFloat(green)/255,
                  blue : CGFloat(blue)/255,
                  alpha: CGFloat(opacity))
    }
}
