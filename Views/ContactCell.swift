//
//  ContactCell.swift
//  Tableviewdemo
//
//

import Foundation
import UIKit
class ContactCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    
    
    var contactItem: Contact?{
        didSet {
            if let progileImageData = contactItem?.avatar{
                profileImage.image = UIImage(data: progileImageData)
            }
            fullname.text = contactItem?.fullname
            phoneNumber.text = contactItem?.phoneNumber
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.contentMode = .scaleAspectFit
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.masksToBounds = true
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = nil
        fullname.text = ""
        phoneNumber.text = ""
    }
}
