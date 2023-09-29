//
//  CustomSearchController.swift
//  Notes
//
//  Created by Kirill on 29.09.2023.
//

import UIKit



extension UISearchController {
    var isEmpty: Bool {
        guard let text = self.searchBar.text else { return false }
        return text.isEmpty
    }
}
