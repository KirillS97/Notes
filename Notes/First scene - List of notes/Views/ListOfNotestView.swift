//
//  ListOfNotestView.swift
//  Notes
//
//  Created by Kirill on 25.09.2023.
//

import UIKit



// MARK: - ListOfNotestView
final class ListOfNotestView: UIView {
    
    // MARK: Свойства
    let tableView = UITableView()
    
    // MARK: Инициализаторы
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = AppColors.listOfNotesViewColor.getColor()
        self.setUpSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



// MARK: - Приватные методы для настройки UI
extension ListOfNotestView {
    
    // MARK: Настройка объекта ListOfNotestView
    private func setUpSelf() -> Void {
        self.setUpTableView()
    }
    
    // MARK: Настройка таблицы tableView
    private func setUpTableView() -> Void {
        self.addSubview(self.tableView)
        self.addConstraintsToTableView()
        self.tableView.estimatedRowHeight = 50
        self.tableView.register(NoteCell.self, forCellReuseIdentifier: NoteCell.reuseId)
        self.tableView.backgroundColor = .none
    }
    
    private func addConstraintsToTableView() -> Void {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
}
