//
//  ExtensionUINavigationController.swift
//  Notes
//
//  Created by Kirill on 28.09.2023.
//

import UIKit



extension UINavigationController {
    
    // Настройка цвета navigation bar
    func setUpColors(backgroundColor: UIColor, textColor: UIColor) -> Void {
        self.navigationBar.tintColor = textColor
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: textColor]
        appearance.titleTextAttributes = [.foregroundColor: textColor]
        appearance.backgroundColor = backgroundColor
        self.navigationBar.scrollEdgeAppearance = appearance
        self.navigationBar.standardAppearance = appearance
    }
    
}
