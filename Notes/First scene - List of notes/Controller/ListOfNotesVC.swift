//
//  ViewController.swift
//  Notes
//
//  Created by Kirill on 25.09.2023.
//

import UIKit



// MARK: - ListOfNotesVC
class ListOfNotesVC: UIViewController {
    
    // MARK: Свойства
    private let coreDataManager = CoreDataManager.shared
    
    private var notesArray: [Note] = [] {
        didSet {
            self.notesArray.sort(by: {
                $0.lastEditDate > $1.lastEditDate
            })
        }
    }
    
    private var filteredNotesArrayForSearch: [Note] = []
    
    private let listOfNotesView = ListOfNotestView()
    
    // Массив заголовков разделов таблицы
    private var tableViewSectionsTitlesArray: [String] = []
    
    // Словарь, ключем которого является заголовок таблицы, а значением массив заметок, дата редактирования которых соответствует заголовку
    private var notesDictionary: [String: [Note]] = [:]
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: loadView
    override func loadView() {
        super.loadView()
        self.view = listOfNotesView
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listOfNotesView.tableView.dataSource = self
        self.listOfNotesView.tableView.delegate = self
        self.setUpNavigationController()
        self.updateNotesArray()
        self.updateSectionTitles()
        self.updateNotesDictionary()
        self.setUpSearchController()        
    }
    
    // MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setUpColors(backgroundColor: AppColors.listOfNotesViewColor.getColor(),
                                               textColor: AppColors.listOfNotesViewTextColor.getColor())
        
        // Данное действие необходимо, чтобы далее в методе viewDidAppear изменить на true это же свойство. Это позволяет сделать search bar видимым после загрузки экрана
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Данное действие необходимо сделать после того, как в методе viewWillAppear значение этого свойства было изменено на false. Это позволяет сделать search bar видимым после загрузки экрана
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    // MARK: Настройка navigation bar
    private func setUpNavigationController() -> Void {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Заметки"
        self.navigationItem.backButtonTitle = "Заметки"
        self.navigationItem.largeTitleDisplayMode = .always
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(self.addButtonHandler))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationController?.setUpColors(backgroundColor: AppColors.listOfNotesViewColor.getColor(),
                                               textColor: AppColors.listOfNotesViewTextColor.getColor())
    }
    
    // MARK: Настройка search controller
    private func setUpSearchController() -> Void {
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.searchTextField.backgroundColor = AppColors.listOfNotesSearchTextFieldColor.getColor()
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Поиск"
        self.navigationItem.searchController = self.searchController
    }
    
    // MARK: Переход на NoteVC
    private func goToNoteVC(note: Note?) -> Void {
        let noteVC = NoteVC(note: note)
        noteVC.closureForDataTransfer = {
            self.updateNotesArray()
            self.updateSectionTitles()
            self.updateNotesDictionary()
            self.listOfNotesView.tableView.reloadData()
        }
        self.navigationController?.pushViewController(noteVC, animated: true)
    }
    
    // MARK: Обработчик нажатия на кнопку добавления заметки на navigation bar
    @objc private func addButtonHandler() -> Void {
        self.goToNoteVC(note: nil)
    }
    
}



// MARK: - Методы для настройки таблицы по разделам
extension ListOfNotesVC {
    
    // MARK: Извлечение массива всех заметок из базы данных
    private func getNotesArrayFromCoreData() -> [Note] {
        let context = self.coreDataManager.persistentContainer.viewContext
        let noteEntityArray = NoteEntity.getNotesArray(context: context)
        var returnedNotesArray = [Note]()
        for noteEntity in noteEntityArray {
            returnedNotesArray.append(Note(noteEntity: noteEntity))
        }
        return returnedNotesArray
    }
    
    // MARK: Установка заметок, полученных из БД, в массив, используемый в качестве источника данных для таблицы
    private func updateNotesArray() -> Void {
        self.notesArray = self.getNotesArrayFromCoreData()
    }
    
    // MARK: Разделение массива заметок на закрепленные и незакрепленные
    private func getAttachedAndNoneAttachedNotesArrays() -> (attachedArray: [Note], noneAttachedArray: [Note])  {
        var attachedNotesArray: [Note] = []
        var noneAttachedNotesArray: [Note] = []
        
        for note in self.notesArray {
            if note.isAttached {
                attachedNotesArray.append(note)
            } else {
                noneAttachedNotesArray.append(note)
            }
        }
        
        return (attachedArray: attachedNotesArray, noneAttachedArray: noneAttachedNotesArray)
    }
    
    // MARK: Заполнение массива с заголовками таблицы
    private func updateSectionTitles() -> Void {
        if !self.tableViewSectionsTitlesArray.isEmpty {
            self.tableViewSectionsTitlesArray.removeAll()
        }
        
        let (attachedNotesArray, noneAttachedNotesArray) = self.getAttachedAndNoneAttachedNotesArrays()
        
        if !attachedNotesArray.isEmpty {
            self.tableViewSectionsTitlesArray.append(TableViewSectionTitle.attached.rawValue)
        }
        
        for note in noneAttachedNotesArray {
            var sectionTitle: String
            
            switch note.getDaysFromCurrentDate() {
            case 0     : sectionTitle = TableViewSectionTitle.today.rawValue
            case 1...7 : sectionTitle = TableViewSectionTitle.lastSevenDays.rawValue
            case 8...30: sectionTitle = TableViewSectionTitle.lastThirtyDays.rawValue
            default    : sectionTitle = TableViewSectionTitle.moreThanThirtyDays.rawValue
            }
            
            if !self.tableViewSectionsTitlesArray.contains(where: { title in
                title == sectionTitle
            }) {
                self.tableViewSectionsTitlesArray.append(sectionTitle)
            }
            
        }
    }
    
    // MARK: Подсчет количества заметок для каждого заголовка таблицы
    private func getNotesCountWhoseDateMatchesTheSectionTitle(sectionTitle: String) -> Int {
        
        var count = 0
        let (attachedNotesArray, noneAttachedNotesArray) = self.getAttachedAndNoneAttachedNotesArrays()
        
        if sectionTitle == TableViewSectionTitle.attached.rawValue {
            return attachedNotesArray.count
        }
        
        switch sectionTitle {
        case TableViewSectionTitle.today.rawValue:
            noneAttachedNotesArray.forEach { note in
                if note.getDaysFromCurrentDate() == 0 {
                    count += 1
                }
            }
        case TableViewSectionTitle.lastSevenDays.rawValue:
            noneAttachedNotesArray.forEach { note in
                if (note.getDaysFromCurrentDate() > 0) && (note.getDaysFromCurrentDate() <= 7) {
                    count += 1
                }
            }
        case TableViewSectionTitle.lastThirtyDays.rawValue:
            noneAttachedNotesArray.forEach { note in
                if (note.getDaysFromCurrentDate() > 7) && (note.getDaysFromCurrentDate() <= 30) {
                    count += 1
                }
            }
        default:
            noneAttachedNotesArray.forEach { note in
                if note.getDaysFromCurrentDate() > 30 {
                    count += 1
                }
            }
            
        }
        return count
    }
    
    // MARK: Заполнение словаря с заметками, в котором замтеки отсортированны по соответствующим заголовкам
    private func updateNotesDictionary() -> Void {
        
        if !self.notesDictionary.isEmpty {
            self.notesDictionary.removeAll()
        }
        
        let (attachedNotesArray, noneAttachedNotesArray) = self.getAttachedAndNoneAttachedNotesArrays()
        
        for title in self.tableViewSectionsTitlesArray {
            var notesArray: [Note] = []
            
            switch title {
            case TableViewSectionTitle.attached.rawValue:
                attachedNotesArray.forEach { note in
                    notesArray.append(note)
                }
            case TableViewSectionTitle.today.rawValue:
                noneAttachedNotesArray.forEach { note in
                    if note.getDaysFromCurrentDate() == 0 {
                        notesArray.append(note)
                    }
                }
            case TableViewSectionTitle.lastSevenDays.rawValue:
                noneAttachedNotesArray.forEach { note in
                    if (note.getDaysFromCurrentDate() > 0) && (note.getDaysFromCurrentDate() <= 7) {
                        notesArray.append(note)
                    }
                }
            case TableViewSectionTitle.lastThirtyDays.rawValue:
                noneAttachedNotesArray.forEach { note in
                    if (note.getDaysFromCurrentDate() > 7) && (note.getDaysFromCurrentDate() <= 30) {
                        notesArray.append(note)
                    }
                }
            default:
                noneAttachedNotesArray.forEach { note in
                    if note.getDaysFromCurrentDate() > 30 {
                        notesArray.append(note)
                    }
                }
                
            }
            
            if !notesArray.isEmpty {
                self.notesDictionary[title] = notesArray
            }
            
        }
        
    }
    
    
}



// MARK: - UITableViewDataSource
extension ListOfNotesVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.searchController.isActive && !self.searchController.isEmpty  {
            return 1
        } else {
            return self.tableViewSectionsTitlesArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !self.searchController.isActive {
            let customHeader = CustomHeaderForTableView(frame: .zero)
            guard self.tableViewSectionsTitlesArray.indices.contains(section) else { return customHeader }
            customHeader.setTitle(text: self.tableViewSectionsTitlesArray[section])
            return customHeader
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.isActive && !self.searchController.isEmpty {
            return self.filteredNotesArrayForSearch.count
        } else {
            if self.tableViewSectionsTitlesArray.indices.contains(section) {
                let title = self.tableViewSectionsTitlesArray[section]
                return self.getNotesCountWhoseDateMatchesTheSectionTitle(sectionTitle: title)
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : NoteCell
        
        if let reusedCell = self.listOfNotesView.tableView.dequeueReusableCell(withIdentifier: NoteCell.reuseId) as? NoteCell {
            cell = reusedCell
        } else {
            cell = NoteCell(style: .default, reuseIdentifier: NoteCell.reuseId)
        }
        
        var note: Note!
        
        if self.searchController.isActive && !self.searchController.isEmpty {
            guard self.filteredNotesArrayForSearch.indices.contains(indexPath.row) else { return cell }
            note = self.filteredNotesArrayForSearch[indexPath.row]
        } else {
            guard self.tableViewSectionsTitlesArray.indices.contains(indexPath.section) else { return cell }
            let title = self.tableViewSectionsTitlesArray[indexPath.section]
            guard let notesArray = self.notesDictionary[title] else { return cell }
            guard notesArray.indices.contains(indexPath.row) else { return cell }
            note = notesArray[indexPath.row]
        }
        
        cell.setMainLabelText(text: note.attributedText.string)
        cell.setDateLabelText(date: note.lastEditDate)
        
        return cell
    }
    
}



// MARK: - UITableViewDelegate
extension ListOfNotesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var note: Note!
        
        if self.searchController.isActive && !self.searchController.isEmpty {
            guard self.filteredNotesArrayForSearch.indices.contains(indexPath.row) else { return }
            note = self.filteredNotesArrayForSearch[indexPath.row]
        } else {
            guard self.tableViewSectionsTitlesArray.indices.contains(indexPath.section) else { return }
            let title = self.tableViewSectionsTitlesArray[indexPath.section]
            guard let notesArray = self.notesDictionary[title] else { return }
            guard notesArray.indices.contains(indexPath.row) else { return }
            note = notesArray[indexPath.row]
        }
        
        self.goToNoteVC(note: note)
        self.listOfNotesView.tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var selectedNote: Note!
        
        if self.searchController.isActive && !self.searchController.isEmpty {
            guard self.filteredNotesArrayForSearch.indices.contains(indexPath.row) else { return nil }
            selectedNote = self.filteredNotesArrayForSearch[indexPath.row]
        } else {
            guard self.tableViewSectionsTitlesArray.indices.contains(indexPath.section) else { return nil }
            let sectionTitle: String = self.tableViewSectionsTitlesArray[indexPath.section]
            guard let notesArray: [Note] = self.notesDictionary[sectionTitle] else { return nil }
            guard notesArray.indices.contains(indexPath.row) else { return nil }
            selectedNote = notesArray[indexPath.row]
        }
        
        let context = self.coreDataManager.persistentContainer.viewContext
        
        // Инициализация объекта "UIContextualAction", инициирующего действие удаления ячейки
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "") { (action: UIContextualAction,
                                                            view: UIView,
                                                            bool: (@escaping (_) -> Void)) -> Void in
            NoteEntity.removeNoteEntity(note: selectedNote, context: context)
            self.updateNotesArray()
            self.updateSectionTitles()
            self.updateNotesDictionary()
            self.updateFilteredNotesArrayForSearch()
            self.listOfNotesView.tableView.reloadData()
        }
        
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        // Инициализация объекта "UIContextualAction", инициирующего действие закрепления/открепления ячейки
        let attachNoteAction = UIContextualAction(style: .normal,
                                              title: "") { (action: UIContextualAction,
                                                            view: UIView,
                                                            bool: (@escaping (_) -> Void)) -> Void in
            if selectedNote.isAttached {
                selectedNote.disattach()
            } else {
                selectedNote.attach()
            }
            
            if let noteEntity = NoteEntity.findNoteEntity(note: selectedNote, context: context) {
                noteEntity.setUpAttributes(note: selectedNote)
            }
            self.updateNotesArray()
            self.updateSectionTitles()
            self.updateNotesDictionary()
            self.listOfNotesView.tableView.reloadData()
        }
        
        attachNoteAction.backgroundColor = .systemOrange
        
        if selectedNote.isAttached {
            attachNoteAction.image = UIImage(systemName: "pin.slash.fill")
        } else {
            attachNoteAction.image = UIImage(systemName: "pin.fill")
        }
        
        // Инициализация кофигурации кнопок
        let actionsObject = UISwipeActionsConfiguration(actions: [deleteAction, attachNoteAction])
        
        // Возврат конфигурации кнопок
        return actionsObject
    }
    
}



extension ListOfNotesVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.updateFilteredNotesArrayForSearch()
        self.listOfNotesView.tableView.reloadData()
    }
    
    private func updateFilteredNotesArrayForSearch() -> Void {
        guard let text = self.searchController.searchBar.text else { return }
        let filteredArray = self.notesArray.filter { note in
            note.attributedText.string.lowercased().contains(text.lowercased())
        }
        self.filteredNotesArrayForSearch = filteredArray.sorted(by: {
            $0.lastEditDate > $1.lastEditDate
        })
    }
    
}
