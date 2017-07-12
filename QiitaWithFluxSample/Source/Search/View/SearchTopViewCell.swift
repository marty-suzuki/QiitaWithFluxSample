//
//  SearchTopViewCell.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/16.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import UIKit
import Nuke
import QiitaSession

class SearchTopViewCell: UITableViewCell, Nibable {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with item: Item) {
        userNameLabel.text = "\(item.user.id)が\(item.createdDateString)に投稿"
        titleLabel.text = item.title
        descriptionLabel.text = item.newLineExcludedBody
        thumbnailImageView.image = nil
        if let url = URL(string: item.user.profileImageUrl) {
            loadImage(with: url, into: thumbnailImageView)
        }
    }
}
