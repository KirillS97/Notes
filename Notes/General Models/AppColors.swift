//
//  AppColors.swift
//  Notes
//
//  Created by Kirill on 25.09.2023.
//

import UIKit



enum AppColors {
    case listOfNotesViewColor
    case listOfNotesViewTextColor
    case listOfNotesSearchTextFieldColor
    case noteCellColor
    case cellMainTextColor
    case cellAdditionalTextColor
    case noteViewColor
    case noteViewTextColor
}



extension AppColors {
    
    func getColor() -> UIColor {
        switch self {
        case .listOfNotesViewColor           : return UIColor(red: 3/255, green: 10/255, blue: 26/255, alpha: 1)
        case .noteCellColor                  : return UIColor(red: 68/255, green: 70/255, blue: 71/255, alpha: 1)
        case .listOfNotesViewTextColor       : return UIColor.white
        case .listOfNotesSearchTextFieldColor: return UIColor.systemGray
        case .cellMainTextColor              : return UIColor.white
        case .cellAdditionalTextColor        : return UIColor.systemGray5
        case .noteViewColor                  : return UIColor(red: 3/255, green: 10/255, blue: 26/255, alpha: 1)
        case .noteViewTextColor              : return UIColor.white
        }
    }
    
}
