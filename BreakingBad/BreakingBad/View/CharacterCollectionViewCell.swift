//
//  CharacterCollectionViewCell.swift
//  BreakingBad
//
//  Created by Ali Rıza İLHAN on 27.11.2022.
//

import UIKit
import SDWebImage

final class CharacterCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var characterBirthday: UILabel!
    @IBOutlet private weak var characterNickname: UILabel!
    @IBOutlet private weak var characterName: UILabel!
    @IBOutlet private weak var characterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure(with model: CastModel)  {
        characterName.text = "Name: " + model.name
        characterBirthday.text = "Birthday: " + model.birthday
        characterNickname.text = "Nickname: " + model.nickname
        characterImageView.sd_setImage(with: URL(string: model.img), placeholderImage: UIImage(named: "placeholderImg.jpeg"))
    }
    static func   nib() -> UINib {
        return UINib(nibName: "CharacterCollectionViewCell", bundle: nil)
    }

}
