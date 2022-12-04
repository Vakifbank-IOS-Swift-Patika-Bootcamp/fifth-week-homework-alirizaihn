//
//  UserNotesViewController.swift
//  BreakingBad
//
//  Created by Ali Rıza İLHAN on 3.12.2022.
//

import UIKit


final class UserNotesViewController: BaseViewController {

    private let button = UIButton(type: UIButton.ButtonType.custom) as UIButton
    @IBOutlet private weak var notesListTableView: UITableView! {
        didSet {
            notesListTableView.reloadData()
        }
    }
    private var notes: [Note] = []
    
    var btn = UIButton(type: .custom)
    override func viewDidLoad() {
        notesListTableView.dataSource = self
        notesListTableView.delegate = self
        notesListTableView.estimatedRowHeight = UITableView.automaticDimension
        reloadNotes()
        super.viewDidLoad()

        
    }
    func reloadNotes() {
        self.notes = CoreDataManager.shared.getNotes()
    }
    @IBAction func addNewNotePassed(_ sender: Any) {
        guard let createNoteViewController = self.storyboard?.instantiateViewController(withIdentifier: "CreateNoteViewController") as? CreateNoteViewController else {return}
        createNoteViewController.delegate = self
        self.present(createNoteViewController, animated: true)
    }
    
}
extension UserNotesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserNotesTableViewCell", for: indexPath) as? UserNotesTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(noteModel: notes[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let createNoteViewController = self.storyboard?.instantiateViewController(withIdentifier: "CreateNoteViewController") as! CreateNoteViewController
        createNoteViewController.delegate = self
        createNoteViewController.note = notes[indexPath.row]
        self.present(createNoteViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let userNote = notes[indexPath.row]
           CoreDataManager.shared.removeNote(noteId: userNote.id!)
           notes.remove(at: indexPath.row)
            notesListTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
extension UserNotesViewController: NewNotesDelegate {
    func createdNewNote() {
        reloadNotes()
        notesListTableView.reloadData()
    }
}
