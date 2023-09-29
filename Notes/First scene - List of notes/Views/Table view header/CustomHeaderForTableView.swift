//
//  CustomHeaderForTableView.swift
//  Notes
//
//  Created by Kirill on 26.09.2023.
//

import UIKit



// MARK: - CustomHeaderForTableView
final class CustomHeaderForTableView: UIView {
    
    // MARK: Свойства
    let titleLabel = UILabel()
    
    // MARK: Инициализаторы
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




// MARK: - Интерфейс
extension CustomHeaderForTableView {
    
    // MARK: Установка текста заголовка для хэдера
    func setTitle(text: String) -> Void {
        self.titleLabel.text = text
    }
    
}



// MARK: - Приватные методы для настройки UI
extension CustomHeaderForTableView {
    
    // MARK: Настройка объекта CustomHeaderForTableView
    private func setUpSelf() -> Void {
        self.setUpTitleLabel()
        self.backgroundColor = AppColors.listOfNotesViewColor.getColor()
    }
    
    // MARK: Настройка метки с заголовком
    private func setUpTitleLabel() -> Void {
        self.addSubview(self.titleLabel)
        self.addConstraintsToTitleLabel()
        self.titleLabel.backgroundColor = AppColors.listOfNotesViewColor.getColor()
        self.titleLabel.textColor = AppColors.listOfNotesViewTextColor.getColor()
        self.titleLabel.font = .systemFont(ofSize: 22, weight: .semibold)
    }
    
    private func addConstraintsToTitleLabel() -> Void {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
        ])
    }
    
}
