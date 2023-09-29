//
//  Note.swift
//  Notes
//
//  Created by Kirill on 25.09.2023.
//

import Foundation



// MARK: - Note
struct Note {
    
    private (set) var attributedText: NSAttributedString
    private (set) var lastEditDate: Date
    private (set) var isAttached: Bool = false
    
    init(attributedText: NSAttributedString, lastEditDate: Date) {
        self.attributedText = attributedText
        self.lastEditDate = lastEditDate
    }
    
    init(noteEntity: NoteEntity) {
        self.attributedText = noteEntity.attributedText
        self.lastEditDate = noteEntity.lastEditDate
        self.isAttached = noteEntity.isAttached
    }
    
}



// MARK: - Интерфейс для настройки заметки
extension Note {
    
    mutating func setUpAttributedText(updatedText: NSAttributedString) -> Void {
        self.attributedText = updatedText
    }
    
    mutating func setUpDate(updatedDate: Date) -> Void {
        self.lastEditDate = updatedDate
    }
    
    mutating func attach() -> Void {
        self.isAttached = true
    }
    
    mutating func disattach() -> Void {
        self.isAttached = false
    }
    
    func getDaysFromCurrentDate() -> Int {
        let currentDate = Date(timeIntervalSinceNow: TimeInterval(TimeZone.current.secondsFromGMT()))
        let timeInterval = currentDate.timeIntervalSince(self.lastEditDate)
        return Int(timeInterval / (60 * 60 * 24))
    }
    
}



// MARK: Note + Equatable
extension Note: Equatable  {
    
}
