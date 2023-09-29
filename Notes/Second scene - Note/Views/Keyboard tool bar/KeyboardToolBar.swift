//
//  KeyboardToolBar.swift
//  Notes
//
//  Created by Kirill on 28.09.2023.
//

import UIKit



// MARK: - KeyboardToolBar
final class KeyboardToolBar: UIToolbar {
    
    // MARK: Свойства
    private (set) var doneButton           = UIBarButtonItem()
    private (set) var addImageButton       = UIBarButtonItem()
    private (set) var changeKeyboardButton = UIBarButtonItem()
    private (set) var flexSpaceButton      = UIBarButtonItem()
    
    let keyboardDelegate: KeyboardToolBarDelegate
    
    // MARK: Инициализаторы
    init(keyboardDelegate: KeyboardToolBarDelegate) {
        self.keyboardDelegate = keyboardDelegate
        super.init(frame: CGRect(x: 0, y: 0, width: 1000, height: 44))
        self.setUpSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



// MARK: - Приватные методы для настройки UI
extension KeyboardToolBar {
    
    // MARK: Настройка объекта KeyboardToolBar
    private func setUpSelf() -> Void {
        self.setUpDoneButton()
        self.setUpAddImageButton()
        self.setUpChangeKeyboardButton()
        self.setUpFlexSpaceButton()
        self.setItems([addImageButton, changeKeyboardButton, flexSpaceButton, doneButton], animated: false)
    }
    
    // MARK: Настройка кнопки doneButton
    private func setUpDoneButton() -> Void {
        self.doneButton = UIBarButtonItem(title: "Готово",
                                          style: .done,
                                          target: keyboardDelegate,
                                          action: #selector(keyboardDelegate.keyBoardDoneButtonHandler))
    }
    
    // MARK: Настройка кнопки addImageButton
    private func setUpAddImageButton() -> Void {
        self.addImageButton = UIBarButtonItem(image: UIImage(systemName: "photo"),
                                              style: .plain,
                                              target: keyboardDelegate,
                                              action: #selector(keyboardDelegate.addImageButtonHandler))
    }
    
    // MARK: Настройка кнопки changeKeyboardButton
    private func setUpChangeKeyboardButton() -> Void {
        self.changeKeyboardButton = UIBarButtonItem(image: UIImage(),
                                                    style: .plain,
                                                    target: keyboardDelegate,
                                                    action: #selector(keyboardDelegate.changeKeyboardButtonHandler))
    }
    
    // MARK: Настройка пустой кнопки flexSpaceButton
    private func setUpFlexSpaceButton() -> Void {
        self.flexSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                               target: nil,
                                               action: nil)
    }
    
}



// MARK: - Интерфейс
extension KeyboardToolBar {
    
    // MARK: Установка изображения для кнопки changeKeyboardButton при переключении на кастомную клавиатуру
    func setImageToKeyboardChangeButtonForDefaultKeyboard() -> Void {
        self.changeKeyboardButton.image = UIImage(systemName: "bold.italic.underline")
    }
    
    // MARK: Установка изображения для кнопки changeKeyboardButton при переключении на дефолтную клавиатуру
    func setImageToKeyboardChangeButtonForCustomKeyboard() -> Void {
        self.changeKeyboardButton.image = UIImage(systemName: "keyboard")
    }
    
}
