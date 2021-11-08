//
//  ConvTableViewCell.swift
//  Messenger
//
//  Created by administrator on 08/11/2021.
//

import UIKit

class ConvTableViewCell: UITableViewCell {
    
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var friendImageView: UIImageView!
    
    var frindPicture : UIImage?
    let myImages = ["pink.jpeg","white.jpeg", "black.jpeg","orange.png", "cyan.jpeg" ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        friendImageView.layer.cornerRadius = 20
        friendImageView.layer.masksToBounds = true
        
        if let fImage = frindPicture {
            self.friendImageView.image = fImage
        }
        else{
            randomImage()
    }
    }
    
    func randomImage(){
      
        let random = Int.random(in: 0...myImages.count-1)
            
        self.friendImageView.image = UIImage(named: myImages[random])
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
