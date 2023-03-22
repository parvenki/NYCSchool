//
//  SchoolSatScoreTableViewCell.swift
//  20230321-Venkateswararao&Parvatam-NYCSchools
//
//  Created by Venkat_Sravani on 3/22/23.
//

import Foundation
import UIKit

class SchoolSatScoreTableViewCell: UITableViewCell {

    @IBOutlet var schoolNameLbl: UILabel!
    @IBOutlet var satReadingAvgScoreLbl: UILabel!
    @IBOutlet var satMathAvgScoreLbl: UILabel!
    @IBOutlet var satWritingAvgScoreLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
