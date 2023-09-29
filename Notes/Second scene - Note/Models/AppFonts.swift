//
//  AppFonts.swift
//  Notes
//
//  Created by Kirill on 27.09.2023.
//

import UIKit



enum AppFonts {
    case regular
    case bold
    case obliqueRegular
    case obliqueBold
}



extension AppFonts {
    func getFont() -> UIFont {
        switch self {
        case .regular        : return UIFont(name: "Helvetica", size: 20)!
        case .bold           : return UIFont(name: "Helvetica Bold", size: 20)!
        case .obliqueRegular : return UIFont(name: "Helvetica Oblique", size: 20)!
        case .obliqueBold    : return UIFont(name: "Helvetica Bold Oblique", size: 20)!
        }
    }
}



extension AppFonts {
    
    // Получение атрибутов для стандартного текста
    static func getRegularTextAttributes() ->[NSAttributedString.Key: Any] {
        let attributes: [NSAttributedString.Key: Any] = [.font: AppFonts.regular.getFont(),
                                                         .foregroundColor: AppColors.noteViewTextColor.getColor()]
        return attributes
    }
    
    // Получение атрибутов для жирного или не жирного текста
    static func getAttributesForBoldOrNoneBoldText(attributes: [NSAttributedString.Key: Any]) -> [NSAttributedString.Key: Any] {
        var newFont: UIFont!
        var changedAttributes = attributes
        
        if let font = attributes[.font] as? UIFont {
            switch font {
            case AppFonts.regular.getFont()       : newFont = AppFonts.bold.getFont()
            case AppFonts.bold.getFont()          : newFont = AppFonts.regular.getFont()
            case AppFonts.obliqueRegular.getFont(): newFont = AppFonts.obliqueBold.getFont()
            case AppFonts.obliqueBold.getFont()   : newFont = AppFonts.obliqueRegular.getFont()
            default                               : newFont = AppFonts.regular.getFont()
            }
        }
        
        changedAttributes[.font] = newFont
        return changedAttributes
    }
    
    // Получение атрибутов для наклонного или ненаклонного текста
    static func getAttributesForObliqueOrNoneObliqueText(attributes: [NSAttributedString.Key: Any]) -> [NSAttributedString.Key: Any] {
        var newFont: UIFont!
        var changedAttributes = attributes
        
        if let font = attributes[.font] as? UIFont {
            switch font {
            case AppFonts.regular.getFont()       : newFont = AppFonts.obliqueRegular.getFont()
            case AppFonts.bold.getFont()          : newFont = AppFonts.obliqueBold.getFont()
            case AppFonts.obliqueRegular.getFont(): newFont = AppFonts.regular.getFont()
            case AppFonts.obliqueBold.getFont()   : newFont = AppFonts.bold.getFont()
            default                               : newFont = AppFonts.obliqueRegular.getFont()
            }
        }
        
        changedAttributes[.font] = newFont
        return changedAttributes
    }
    
    // Получение атрибутов дляподчеркнутого или не подчеркнутного текста
    static func getAttributesForUnderlinedOrNoneUnderlinedText(attributes: [NSAttributedString.Key: Any]) -> [NSAttributedString.Key: Any] {
        var changedAttributes = attributes
        if attributes[.underlineStyle] == nil {
            changedAttributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
            changedAttributes[.underlineColor] = AppColors.noteViewTextColor.getColor()
        } else {
            changedAttributes.removeValue(forKey: .underlineStyle)
            changedAttributes.removeValue(forKey: .underlineColor)
        }
        return changedAttributes
    }
    
}
