//
//  NYCSchoolListCell.swift
//  20230321-Venkateswararao&Parvatam-NYCSchools
//
//  Created by Venkat_Sravani on 3/21/23.
//

import Foundation

class NYCSchoolListCell: UITableViewCell {

    // MARK: IBOutlet
    @IBOutlet var cardView: UIView!
    
    @IBOutlet var schoolNameLbl: UILabel!
    @IBOutlet var schoolAddrLbl: UILabel!
    @IBOutlet var schoolPhoneNumBtn: UIButton!
    @IBOutlet var navigateToAddrBtn: UIButton!
    
    @IBOutlet weak var schoolGradeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCardViewShadows()
        self.schoolPhoneNumBtn.layer.cornerRadius = 15
        self.navigateToAddrBtn.layer.cornerRadius = 15
    }
    
    // MARK: Card View Customization Functions
    
    func setupCardViewShadows(){
        let view = cardView
        view?.layer.cornerRadius = 15.0
        view?.layer.shadowColor = UIColor.black.cgColor
        view?.layer.shadowOffset = CGSize(width: 0, height: 2)
        view?.layer.shadowOpacity = 0.8
        view?.layer.shadowRadius = 3
        view?.layer.masksToBounds = false
    }


}
