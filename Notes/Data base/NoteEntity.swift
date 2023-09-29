//
//  NoteEntity.swift
//  Notes
//
//  Created by Kirill on 26.09.2023.
//

import Foundation
import CoreData



// MARK: Модель для хранения заметок в БД
class NoteEntity: NSManagedObject {
    @NSManaged var lastEditDate: Date
    @NSManaged var attributedText: NSAttributedString
    @NSManaged var isAttached: Bool
}



extension NoteEntity {
    @nonobjc class func fetchRequest() -> NSFetchRequest<NoteEntity> {
        return NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
    }
}



extension NoteEntity : Identifiable {

}




extension NoteEntity {
    
    // MARK: Настройка аттрибутов экземпляра
    func setUpAttributes(note: Note) -> Void {
        self.attributedText = note.attributedText
        self.lastEditDate   = note.lastEditDate
        self.isAttached     = note.isAttached
    }
    
    // MARK: Получение массива всех NoteEntity из контекста БД
    class func getNotesArray(context: NSManagedObjectContext) -> [NoteEntity] {
        // Создание запроса к БД
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        
        // Отправка запроса и обработка ответа от БД
        if let fetchResult = try? context.fetch(request) {
            return fetchResult
        } else {
            return []
        }
    }
    
    // MARK: Поиск элемента NoteEntity в контексте БД
    class func findNoteEntity(note: Note, context: NSManagedObjectContext) -> NoteEntity? {
        // Создание запроса к БД
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "lastEditDate == %@", note.lastEditDate as CVarArg)
        
        // Отправка запроса и обработка ответа от БД
        if let fetchResult = try? context.fetch(request) {
            if !fetchResult.isEmpty {
                return fetchResult.last!
            }
        }
        return nil
    }
    
    // MARK: Создание элемента NoteEntity
    class func createNoteEntity(note: Note, context: NSManagedObjectContext) -> Void {
        if NoteEntity.findNoteEntity(note: note, context: context) == nil {
            let newNote = NoteEntity(context: context)
            newNote.setUpAttributes(note: note)
        }
    }
    
    // MARK: Удаление элемента NoteEntity из контекста БД
    class func removeNoteEntity(note: Note, context: NSManagedObjectContext) -> Void {
        if let noteEntity = NoteEntity.findNoteEntity(note: note, context: context) {
            context.delete(noteEntity)
        }
    }
    
}
