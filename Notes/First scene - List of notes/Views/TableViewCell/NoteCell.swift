//
//  NoteCell.swift
//  Notes
//
//  Created by Kirill on 25.09.2023.
//

import UIKit



// MARK: - NoteCell
final class NoteCell: UITableViewCell {
    
    // MARK: Свойства класса
    static let reuseId = "NoteCell"
    
    // MARK: Свойства объектов класса
    private let mainLabel     = UILabel()
    private let dateLabel     = UILabel()
    private let verticalStack = UIStackView()
    
    // MARK: Инициализаторы
    init() {
        super.init(style: .default, reuseIdentifier: NoteCell.reuseId)
        self.setUpSelf()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



// MARK: - Интерфйес
extension NoteCell {
    
    // MARK: Установка текста метки с основным текстом
    func setMainLabelText(text: String) -> Void {
        self.mainLabel.text = text
    }
    
    // MARK: Установка текста метки с датой последнего редакирования
    func setDateLabelText(date: Date) -> Void {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        self.dateLabel.text = dateFormatter.string(from: date)
    }
    
}



// MARK: - Приватные методы для настройки UI

extension NoteCell {
    
    // MARK: Настройка объекта NoteCell
    private func setUpSelf() -> Void {
        self.setUpBackgroundColor()
        self.selectedBackgroundView = UIView()
        self.setUpAccessoryView()
        
        self.setUpMainLabel()
        self.setUpDateLabel()
        self.setUpVerticalStack()
        self.setUpVerticalStack()
    }
    
    // MARK: Настройка аксессуров ячейки
    private func setUpAccessoryView() -> Void {
        let image = UIImage(systemName: "chevron.right")
        let imageView = UIImageView(image: image)
        imageView.tintColor = AppColors.listOfNotesViewTextColor.getColor()
        self.accessoryView = imageView
    }
    
    // MARK: Настройка цвета
    private func setUpBackgroundColor() -> Void {
        self.backgroundColor = AppColors.listOfNotesViewColor.getColor()
    }
    
    // MARK: Метод для настройки меток
    private func setUpLabel(label: UILabel, color: UIColor, font: UIFont) -> Void {
        label.textColor = color
        label.font = font
    }
    
    // MARK: Настройка метки с основным текстом
    private func setUpMainLabel() -> Void {
        let mainLabelFont = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        self.setUpLabel(label: self.mainLabel,
                        color: AppColors.cellMainTextColor.getColor(),
                        font: mainLabelFont)
    }
    
    // MARK: Настройка метки с датой последнего редактирования
    private func setUpDateLabel() -> Void {
        let dateLabelFont = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.setUpLabel(label: self.dateLabel,
                        color: AppColors.cellAdditionalTextColor.getColor(),
                        font: dateLabelFont)
    }
    
    // MARK: Настройка стека, содержащего метки
    private func setUpVerticalStack() -> Void {
        self.addSubview(self.verticalStack)
        self.addConstraintsToVerticalStack()
        self.verticalStack.addArrangedSubview(self.mainLabel)
        self.verticalStack.addArrangedSubview(self.dateLabel)
        self.verticalStack.axis = .vertical
        self.verticalStack.spacing = 5
        self.verticalStack.isLayoutMarginsRelativeArrangement = true
        self.verticalStack.layoutMargins = .init(top: 10, left: 15, bottom: 10, right: 40)
        self.verticalStack.backgroundColor = AppColors.noteCellColor.getColor()
        self.verticalStack.layer.cornerRadius = 15
    }
    
    private func addConstraintsToVerticalStack() -> Void {
        self.verticalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.verticalStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            self.verticalStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.verticalStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            self.verticalStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }

}
