//
//  NoteVC.swift
//  Notes
//
//  Created by Kirill on 25.09.2023.
//

import UIKit



// MARK: - NoteVC

final class NoteVC: UIViewController {
    
    // MARK: Свойства
    private let coreDataManager = CoreDataManager.shared
    private let noteView = NoteView()
    private let note: Note?
    var closureForDataTransfer: (() -> Void)?
    
    // MARK: Инициализаторы
    init(note: Note?) {
        self.note = note
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: loadView
    override func loadView() {
        self.view = self.noteView
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavigationController()
        self.setUpKeyboardToolBar()
        self.prepareToShowAttributedText()
    }
    
    // MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setUpColors(backgroundColor: AppColors.noteViewColor.getColor(),
                                               textColor: AppColors.noteViewTextColor.getColor())
    }
    
    // MARK: viewWillDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if note == nil {
            self.noteView.textView.becomeFirstResponder()
        }
    }
    
    // MARK: viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.changeNoteEntityAttributesOrCreateNewNoteEntity()
        self.closureForDataTransfer?()
    }
    
    // MARK: Настройка navigation bar
    private func setUpNavigationController() -> Void {
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.setUpColors(backgroundColor: AppColors.noteViewColor.getColor(),
                                               textColor: AppColors.noteViewTextColor.getColor())
    }
    
    // MARK: Наполнение текстом textView
    private func prepareToShowAttributedText() -> Void {
        if let note {
            self.noteView.textView.attributedText = note.attributedText
        }
    }
    
    // MARK: Создание нового экземпляра NoteEntity в контексте БД или изменение атрибутов изменяемого экземпляра NoteEntity
    private func changeNoteEntityAttributesOrCreateNewNoteEntity() -> Void {
        guard let noteAttributedText = self.noteView.textView.attributedText else { return }
        guard !noteAttributedText.string.isEmpty else { return }
        
        let currentDate = Date(timeIntervalSinceNow: TimeInterval(TimeZone.current.secondsFromGMT()))
        var newNote = Note(attributedText: noteAttributedText, lastEditDate: currentDate)
        
        let context = self.coreDataManager.persistentContainer.viewContext
        if let safeNote = self.note {
            if safeNote.isAttached {
                newNote.attach()
            }
            if safeNote.attributedText != newNote.attributedText {
                if let noteEntity = NoteEntity.findNoteEntity(note: safeNote, context: context) {
                    noteEntity.setUpAttributes(note: newNote)
                }
            }
        } else {
            if NoteEntity.findNoteEntity(note: newNote, context: context) == nil {
                NoteEntity.createNoteEntity(note: newNote, context: context)
            }
        }
    }
    
    // MARK: Настройка панели инструментов для inputView (клавиатуры)
    private func setUpKeyboardToolBar() -> Void {
        let toolBar = KeyboardToolBar(keyboardDelegate: self)
        toolBar.sizeToFit()
        if self.noteView.textView.inputView == nil {
            toolBar.setImageToKeyboardChangeButtonForDefaultKeyboard()
        } else {
            toolBar.setImageToKeyboardChangeButtonForCustomKeyboard()
        }
        self.noteView.textView.inputAccessoryView = toolBar
    }
    
}



// MARK: - NoteVC + UIImagePickerControllerDelegate

extension NoteVC: UIImagePickerControllerDelegate {
    
    // MARK: Выбор фотографии в галлерее устройства и вставка выбранной фотографии в textView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let key = UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")
        if let image = info[key] as? UIImage {
            
            let imageWidth = image.size.width
            let textViewWidth = self.noteView.textView.frame.width
            let scaleFactor = imageWidth / textViewWidth
            
            let imageAttachment = NSTextAttachment()
            if scaleFactor > 1 {
                imageAttachment.image = UIImage(cgImage: image.cgImage!, scale: scaleFactor, orientation: .up)
            } else {
                imageAttachment.image = image
            }
            
            // NSMutableAttributedString, который хранит изображение
            let imageAttributedString = NSMutableAttributedString(attachment: imageAttachment)
            let textAttributesForRegularText: [NSAttributedString.Key: Any] = AppFonts.getRegularTextAttributes()
            
            // Установка аттрибутов текста для imageAttributedString
            imageAttributedString.addAttributes(textAttributesForRegularText, range: NSRange(location: 0, length: imageAttributedString.length))
            
            // Добавление NSAttributedString с изображением к NSAttributedString, который уже написан в UITextView
            let attributedString = NSMutableAttributedString(attributedString: self.noteView.textView.attributedText)
            attributedString.append(imageAttributedString)
            
            // Обновление текста в UITextView
            self.noteView.textView.attributedText = attributedString
        }
        picker.dismiss(animated: true)
    }
    
}



// MARK: - NoteVC + UINavigationControllerDelegate
// Подписка на данный протокол необходима для реализации доступа к выбору фотографий
extension NoteVC: UINavigationControllerDelegate {}



// MARK: - NoteVC + CustomKeyboardDelegate
extension NoteVC: CustomKeyboardDelegate {
    
    // MARK: Изменение веса шрифта
    @objc func boldFontButtonHandler() {
        
        let mutableAttributedString = NSMutableAttributedString(attributedString: self.noteView.textView.attributedText)
        let range = self.noteView.textView.selectedRange
        
        if range.length > 0 {
            
            let selectedAttrubutedString = mutableAttributedString.attributedSubstring(from: range)
            let selectedMutableAttributedString = NSMutableAttributedString(attributedString: selectedAttrubutedString)
            
            let attributes = selectedMutableAttributedString.attributes(at: 0, effectiveRange: nil)
            
            mutableAttributedString.setAttributes(AppFonts.getAttributesForBoldOrNoneBoldText(attributes: attributes),
                                                  range: self.noteView.textView.selectedRange)
            
            self.noteView.textView.attributedText = mutableAttributedString
            
        }
        
        self.noteView.textView.selectedRange = range
        
    }
    
    // MARK: Изменение наклона шрифта
    @objc func italicFontButtonHandler() {
        
        let range = self.noteView.textView.selectedRange
        
        let mutableAttributedString = NSMutableAttributedString(attributedString: self.noteView.textView.attributedText)
        
        let selectedAttrubutedString = mutableAttributedString.attributedSubstring(from: range)
        let selectedMutableAttributedString = NSMutableAttributedString(attributedString: selectedAttrubutedString)

        if !selectedAttrubutedString.string.isEmpty {
            let attributes = selectedMutableAttributedString.attributes(at: 0, effectiveRange: nil)
            mutableAttributedString.setAttributes(AppFonts.getAttributesForObliqueOrNoneObliqueText(attributes: attributes),
                                                  range: self.noteView.textView.selectedRange)
        }
        
        self.noteView.textView.attributedText = mutableAttributedString
        
        self.noteView.textView.selectedRange = range
        
    }
    
    // MARK: Подчеркивание шрифта
    @objc func underlineFontButtonHandler() {
        
        let range = self.noteView.textView.selectedRange
        
        let mutableAttributedString = NSMutableAttributedString(attributedString: self.noteView.textView.attributedText)
        
        let selectedAttrubutedString = mutableAttributedString.attributedSubstring(from: range)
        let selectedMutableAttributedString = NSMutableAttributedString(attributedString: selectedAttrubutedString)

        if !selectedAttrubutedString.string.isEmpty {
            let attributes = selectedMutableAttributedString.attributes(at: 0, effectiveRange: nil)
            mutableAttributedString.setAttributes(AppFonts.getAttributesForUnderlinedOrNoneUnderlinedText(attributes: attributes),
                                                  range: self.noteView.textView.selectedRange)
        }
        
        self.noteView.textView.attributedText = mutableAttributedString
        
        self.noteView.textView.selectedRange = range
        
    }
    
}



// MARK: - NoteVC + KeyboardToolBarDelegate
extension NoteVC: KeyboardToolBarDelegate {
    
    @objc func keyBoardDoneButtonHandler() -> Void {
        self.noteView.textView.resignFirstResponder()
        if self.noteView.textView.inputView != nil {
            self.noteView.textView.inputView = nil
            if let keyboardToolBar = self.noteView.textView.inputAccessoryView as? KeyboardToolBar {
                keyboardToolBar.setImageToKeyboardChangeButtonForDefaultKeyboard()
            }
        }
    }
    
    @objc func addImageButtonHandler() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true)
    }
    
    @objc func changeKeyboardButtonHandler() {
        if self.noteView.textView.inputView == nil {
            let keyboardView = CustomKeyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 100), delegate: self)
            
            if let keyboardToolBar = self.noteView.textView.inputAccessoryView as? KeyboardToolBar {
                keyboardToolBar.setImageToKeyboardChangeButtonForCustomKeyboard()
            }
            
            self.noteView.textView.inputView = keyboardView
            self.noteView.textView.resignFirstResponder()
            self.noteView.textView.becomeFirstResponder()
        } else {
            self.noteView.textView.inputView = nil
            
            if let keyboardToolBar = self.noteView.textView.inputAccessoryView as? KeyboardToolBar {
                keyboardToolBar.setImageToKeyboardChangeButtonForDefaultKeyboard()
            }
            
            self.noteView.textView.resignFirstResponder()
            self.noteView.textView.becomeFirstResponder()
        }
    }
    
    
}
