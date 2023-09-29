//
//  CustomKeyboardDelegate.swift
//  Notes
//
//  Created by Kirill on 28.09.2023.
//

import Foundation



@objc protocol CustomKeyboardDelegate: AnyObject {
    
    // Обработчик нажатия на кнопку boldFontButton объекта CustomKeyboard
    @objc func boldFontButtonHandler() -> Void
    
    // Обработчик нажатия на кнопку italicFontButton объекта CustomKeyboard
    @objc func italicFontButtonHandler() -> Void
    
    // Обработчик нажатия на кнопку underlineFontButton объекта CustomKeyboard
    @objc func underlineFontButtonHandler() -> Void
    
}
