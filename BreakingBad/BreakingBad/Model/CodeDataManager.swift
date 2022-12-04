//
//  CodeDataManager.swift
//  BreakingBad
//
//  Created by Ali Rıza İLHAN on 2.12.2022.
//
import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private let managedContext: NSManagedObjectContext!
 
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
    }
    func saveNote(newNote: UserNoteModel) -> Note? {
        let entity = NSEntityDescription.entity(forEntityName: "Note", in: managedContext)!
        let note = NSManagedObject(entity: entity, insertInto: managedContext)
        note.setValue(newNote.season, forKeyPath: "season")
        note.setValue(newNote.episode, forKeyPath: "episode")
        note.setValue(newNote.noteText, forKeyPath: "noteText")
        note.setValue(newNote.id, forKey: "id")
        do {
            try managedContext.save()
            return note as? Note
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    func removeNote(noteId: UUID) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        fetchRequest.predicate = NSPredicate(format: "id == %@", noteId as CVarArg)
        if let notes = try? managedContext.fetch(fetchRequest) {
            for note in notes {
                managedContext.delete(note)
            }
            do {
                try managedContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    func removeAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedContext.execute(batchDeleteRequest)

        } catch {
            // Error Handling
        }
    }
    func updateNote(noteModel: UserNoteModel) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        fetchRequest.predicate = NSPredicate(format: "id == %@", noteModel.id as CVarArg)
        
        do {
            let notes = try managedContext.fetch(fetchRequest)
            let note = notes[0]
            note.setValue(noteModel.season, forKeyPath: "season")
            note.setValue(noteModel.episode, forKeyPath: "episode")
            note.setValue(noteModel.noteText, forKeyPath: "noteText")
            note.setValue(noteModel.id, forKey: "id")
            try managedContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func getNotes() -> [Note] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        do {
            let notes = try managedContext.fetch(fetchRequest)
            return notes as! [Note]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
}
