//
//  CollectionViewCell_dude.swift
//  Tabatabata
//
//  Created by Jordane HUY on 27/03/2018.
//  Copyright © 2018 Jordane HUY. All rights reserved.
//

import UIKit

class CollectionViewCell_dude: UICollectionViewCell {
    @IBOutlet var view_color: UIView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet var viewUser: UIView!
    @IBOutlet var labelAA: UILabel!
    
    var isCreation = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewUser.layer.cornerRadius = 75
    }
    
    func setViewColor(color: UIColor){
        self.view_color.backgroundColor = color
    }
}
