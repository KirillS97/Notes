//
//  NoteView.swift
//  Notes
//
//  Created by Kirill on 25.09.2023.
//

import UIKit



// MARK: - NoteView
final class NoteView: UIView {
    
    // MARK: Свойства
    let textView = UITextView()
    
    // MARK: Инициализаторы
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.setUpSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




// MARK: - Приватные методы для настройки UI
extension NoteView {
    
    // MARK: Настройка объекта NoteView
    private func setUpSelf() -> Void {
        self.setUpBackgroundColor()
        self.setUpTextView()
    }
    
    // MARK: Настройка цвета
    private func setUpBackgroundColor() -> Void {
        self.backgroundColor = AppColors.noteViewColor.getColor()
    }
    
    // MARK: Настройка UITextView
    private func setUpTextView() -> Void {
        self.addSubview(self.textView)
        self.addConstraintsToTextView()
        self.textView.font = AppFonts.regular.getFont()
        self.textView.textColor = AppColors.noteViewTextColor.getColor()
        self.textView.backgroundColor = .none
    }
    
    private func addConstraintsToTextView() -> Void {
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.textView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.textView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.textView.bottomAnchor.constraint(equalTo: self.keyboardLayoutGuide.topAnchor),
            self.textView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
}
