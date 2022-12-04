//
//  CreateNoteViewController.swift
//  BreakingBad
//
//  Created by Ali Rıza İLHAN on 4.12.2022.
//

import UIKit

protocol NewNotesDelegate {
    func createdNewNote()
}
class CreateNoteViewController: BaseViewController {

    @IBOutlet private weak var pageTitleLabel: UILabel!
    @IBOutlet private weak var bgView: UIView!
    @IBOutlet private weak var userNoteTextView: UITextView!
    @IBOutlet private weak var selectEpisodeButton: UIButton!
    @IBOutlet private weak var episodeTableView: UITableView! {
        didSet {
            episodeTableView.dataSource = self
            episodeTableView.delegate = self
            episodeTableView.estimatedRowHeight = UITableView.automaticDimension
        }
    }
    private var newNotes = UserNoteModel(episode: "", noteText: "", season: "", id: UUID())
    var seasons: [SeasonModel]? {
        didSet {
            episodeTableView.reloadData()
        }
    }
    var delegate: NewNotesDelegate? = nil
    var note: Note? = nil
    var episodes: [EpisodeModel]? {
        didSet {
            
            seasons = episodes?.reduce(into: [SeasonModel](), { s1, s2 in

                if ((s1.isEmpty)) {
                   s1.append(SeasonModel(name: s2.season, episodes: [s2]))
                } else {
                    if let index =  s1.firstIndex(where: { $0.name == s2.season.components(separatedBy: " ").joined()}) {
                        s1[index].episodes.append(s2)
                    } else {
                        s1.append(SeasonModel(name: s2.season, episodes: [s2]))
                    }
                }
               
            })
        }
    }
    var notes: [Note] = []
//    private let notePlaceHolder = "Write Your Note..."
   
    override func viewDidLoad() {
        super.viewDidLoad()

        if note != nil {
            configureUI(note!)
        }
        self.indicator.startAnimating()
        Client.getEpisode { [weak self] episodes, error in
            guard let self = self else { return }
            self.indicator.stopAnimating()
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription) {
                    self.navigationController?.popViewController(animated: true)
                }
                return
            }
            if episodes?.isEmpty ?? true {
                self.showErrorAlert(message: "No Episode") {
                    self.navigationController?.popViewController(animated: true)
                }
                return
            }
            self.episodes = episodes
        }
    }
    @IBAction func selectEpisodePressed(_ sender: Any) {
        episodeTableView.isHidden.toggle()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        bgView.endEditing(true)
        view.endEditing(true)
    }
    func configureUI(_ note: Note) -> Void {
        pageTitleLabel.text = "Update"
        newNotes.episode = note.episode ?? ""
        newNotes.id = note.id!
        newNotes.season = note.season ?? ""
        newNotes.noteText = note.noteText  ?? ""
        let title = "S: " + (newNotes.season ?? "") + " / E: " + (newNotes.episode ?? "")
        selectEpisodeButton.setTitle(title, for: .normal)
        userNoteTextView.text = newNotes.noteText
    }
    @IBAction func AddButtonPressed(_ sender: Any) {
       print(String(describing:newNotes))
        if (userNoteTextView.text == "" || newNotes.episode == "") {
            self.showErrorAlert(message: "Please fill in all the blanks. "){
                    self.navigationController?.popViewController(animated: true)
            }
        } else {
            newNotes.noteText = userNoteTextView.text
            if note != nil {
    //            Update
                CoreDataManager.shared.updateNote(noteModel: newNotes)
            } else {
    //            Create
                CoreDataManager.shared.saveNote(newNote: newNotes)
            }
            self.dismiss(animated: true)
            self.delegate?.createdNewNote()
        }
        
    }
}
extension CreateNoteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        seasons?[section].episodes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = seasons?[indexPath.section].episodes[indexPath.row].title
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        seasons?.count ?? 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let episode = seasons?[indexPath.section].episodes[indexPath.row]
        newNotes.episode = episode?.title ?? ""
        newNotes.season = episode?.season ?? ""
        let title = "S: " + (episode?.season ?? "") + " / E: " + (episode?.title ?? "")
        selectEpisodeButton.setTitle(title, for: .normal)
        episodeTableView.isHidden = true
    }
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        view.backgroundColor = .systemYellow
        let lbl = UILabel(frame: CGRect(x: 15, y: 0, width: view.frame.width - 15, height: 40))
        lbl.text = "Season: " + (seasons?[section].name ?? "")
        
        view.addSubview(lbl)
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
}

