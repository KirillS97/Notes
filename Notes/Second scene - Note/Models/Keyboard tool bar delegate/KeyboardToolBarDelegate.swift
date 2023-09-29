//
//  KeyboardToolBarDelegate.swift
//  Notes
//
//  Created by Kirill on 28.09.2023.
//

import Foundation



@objc protocol KeyboardToolBarDelegate: AnyObject {
    
    // Обработчик нажатия на кнопку keyBoardDoneButton объекта KeyboardToolBar
    @objc func keyBoardDoneButtonHandler() -> Void
    
    // Обработчик нажатия на кнопку addImageButto объекта KeyboardToolBar
    @objc func addImageButtonHandler() -> Void
    
    // Обработчик нажатия на кнопку changeKeyboardButton объекта KeyboardToolBar
    @objc func changeKeyboardButtonHandler() -> Void
}
