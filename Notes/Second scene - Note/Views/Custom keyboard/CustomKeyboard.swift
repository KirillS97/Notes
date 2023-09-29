//
//  CustomKeyboard.swift
//  Notes
//
//  Created by Kirill on 27.09.2023.
//



import UIKit



// MARK: - CustomKeyboard
final class CustomKeyboard: UIView {
    
    // MARK: Свойства
    private let buttonsHeight: CGFloat = 35
    private let buttonsWidth : CGFloat = 70
    
    private let boldFontButton      = UIButton()
    private let italicFontButton    = UIButton()
    private let underlineFontButton = UIButton()
    private let horizontalStackView = UIStackView()
    
    private weak var delegate: (CustomKeyboardDelegate)?

    // MARK: Инициализаторы
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpSelf()
    }

    init(frame: CGRect, delegate: CustomKeyboardDelegate) {
        super.init(frame: frame)
        self.delegate = delegate
        setUpSelf()
    }

}



// MARK: - Приватные методы для настройки UI
extension CustomKeyboard {
    
    // MARK: Настройка объекта CustomKeyboard
    private func setUpSelf() {
        self.setUpBoldFontButton()
        self.setUpItalicFontButton()
        self.setUpIUnderlinedFontButton()
        self.setUpHorizontalStack()
    }
    
    // MARK: Метод для настройки всех кнопок
    private func setUpButton(button: UIButton, image: UIImage) -> Void {
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        let scale = image.size.height / (self.buttonsHeight * 0.8)
        let modifiedImage = UIImage(cgImage: image.cgImage!, scale: scale, orientation: .up)
        button.setImage(modifiedImage, for: .normal)
        button.setImage(modifiedImage.withTintColor(.systemGray3), for: .highlighted)
    }
    
    // MARK: Настройка кнопки переключения веса шрифта
    private func setUpBoldFontButton() -> Void {
        guard let initialImage = UIImage(named: "bold") else { return }
        self.setUpButton(button: self.boldFontButton, image: initialImage)
        self.boldFontButton.addTarget(self.delegate!,
                                      action: #selector(self.delegate!.boldFontButtonHandler),
                                      for: .touchUpInside)
    }
    
    // MARK: Настройка кнопки переключения наклона шрифта
    private func setUpItalicFontButton() -> Void {
        guard let initialImage = UIImage(named: "italic") else { return }
        self.setUpButton(button: self.italicFontButton, image: initialImage)
        self.italicFontButton.addTarget(self.delegate!,
                                        action: #selector(self.delegate!.italicFontButtonHandler),
                                        for: .touchUpInside)
    }
    
    // MARK: Настройка кнопки подчеркивания шрифта
    private func setUpIUnderlinedFontButton() -> Void {
        guard let initialImage = UIImage(named: "underlined") else { return }
        self.setUpButton(button: self.underlineFontButton, image: initialImage)
        self.underlineFontButton.addTarget(self.delegate!,
                                           action: #selector(self.delegate!.underlineFontButtonHandler),
                                           for: .touchUpInside)
    }
    
    // MARK: Настройка горизонтального стека, в котором лежат все кнопки
    private func setUpHorizontalStack() -> Void {
        self.addSubview(self.horizontalStackView)
        self.addConstrintsToHorizontalStack()
        self.horizontalStackView.addArrangedSubview(self.boldFontButton)
        self.horizontalStackView.addArrangedSubview(self.italicFontButton)
        self.horizontalStackView.addArrangedSubview(self.underlineFontButton)
        self.horizontalStackView.axis = .horizontal
        self.horizontalStackView.distribution = .equalSpacing
        self.horizontalStackView.isLayoutMarginsRelativeArrangement = true
        self.horizontalStackView.layoutMargins = .init(top: 10, left: 40, bottom: 10, right: 40)
    }
    
    private func addConstrintsToHorizontalStack() -> Void {
        self.horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.horizontalStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.horizontalStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            self.horizontalStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.horizontalStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
}
