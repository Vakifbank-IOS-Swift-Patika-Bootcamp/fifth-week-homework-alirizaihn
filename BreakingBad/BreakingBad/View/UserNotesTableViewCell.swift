//
//  UserNotesTableViewCell.swift
//  BreakingBad
//
//  Created by Ali Rıza İLHAN on 4.12.2022.
//

import UIKit

final class UserNotesTableViewCell: UITableViewCell {
    @IBOutlet private var seasonLabel: UILabel!
    @IBOutlet private var episodeLabel: UILabel!
    @IBOutlet private var noteLabel: UILabel!
   
    func configureCell(noteModel: Note) {
        seasonLabel.text = "Season: " + (noteModel.season ?? "")
        episodeLabel.text = "Episode: " + (noteModel.episode ?? "")
        noteLabel.text = noteModel.noteText
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
