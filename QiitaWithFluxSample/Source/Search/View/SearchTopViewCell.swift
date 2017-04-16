//
//  SearchTopViewCell.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/16.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import UIKit
import Kingfisher

class SearchTopViewCell: UITableViewCell, Nibable {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with item: Item) {
        userNameLabel.text = "\(item.user.id)が\(item.createdDateString)に投稿"
        titleLabel.text = item.title
        descriptionLabel.text = item.newLineExcludedBody
        
        if let url = URL(string: item.user.profileImageUrl) {
            thumbnailImageView.kf.setImage(with: url)
        }
    }
}
