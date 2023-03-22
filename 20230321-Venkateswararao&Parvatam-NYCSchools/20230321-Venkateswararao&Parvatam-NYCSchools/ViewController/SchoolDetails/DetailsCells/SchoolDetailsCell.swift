//
//  SchoolDetailsCell.swift
//  20230321-Venkateswararao&Parvatam-NYCSchools
//
//  Created by Venkat_Sravani on 3/21/23.
//

import Foundation
import UIKit

class SchoolDetailsCell {
    
    // Rendering all details cells to display in detailview
    static func tableViewCellWithSATScore(_ tableView: UITableView, withSatScore: SchoolInfo) -> UITableViewCell{
        
        // dislaying sat score score
        guard let schoolWithSATScoresCell = tableView.dequeueReusableCell(withIdentifier: Constants.schoolWithSATScoreCellIdentifier) as? SchoolSatScoreTableViewCell else {
            return UITableViewCell()
        }
        
        schoolWithSATScoresCell.schoolNameLbl.text = withSatScore.school_name
        guard let readingAvgScore = withSatScore.sat_critical_reading_avg_score, let mathAvgScore = withSatScore.sat_math_avg_score, let writingAvgScore = withSatScore.sat_writing_avg_score else {
            return UITableViewCell()
        }
        
        schoolWithSATScoresCell.satReadingAvgScoreLbl.text = (readingAvgScore.isEmpty) ? "No SAT score information for this high school" : ("SAT Average Critical Reading Score: " + readingAvgScore)
        
        // displaying math avg score
        schoolWithSATScoresCell.satMathAvgScoreLbl.isHidden = (!writingAvgScore.isEmpty) ? false : true
        schoolWithSATScoresCell.satMathAvgScoreLbl.text = (!writingAvgScore.isEmpty) ? ("SAT Average Math Score:   " + mathAvgScore) : nil
        
        
        // displaying writing avg Score
        schoolWithSATScoresCell.satWritingAvgScoreLbl.isHidden =  (!writingAvgScore.isEmpty) ? false : true
        schoolWithSATScoresCell.satWritingAvgScoreLbl.text = (!writingAvgScore.isEmpty) ? ("SAT Average Writing Score:   " + writingAvgScore) : nil
        
        return schoolWithSATScoresCell
    }
    
    /// returns school description view
    static func tableViewCellWithOverView(_ tableView: UITableView, withSatScore: SchoolInfo) -> UITableViewCell{
        guard let schoolWithOverviewCell = tableView.dequeueReusableCell(withIdentifier: Constants.schoolOverviewCellIdentifier) as? SchoolOverViewTableViewCell else {
            return UITableViewCell()
        }
        schoolWithOverviewCell.schoolDetailsLbl.text = withSatScore.overview_paragraph
        
        return schoolWithOverviewCell
    }
    
    // return school contact information
    static func tableViewCellWithContactInfo(_ tableView: UITableView, withSatScore: SchoolInfo) -> UITableViewCell{
        guard let schoolWithContactCell = tableView.dequeueReusableCell(withIdentifier: Constants.schoolWithContactCellIdentifier) as? SchoolContactTableViewCell else {
            return UITableViewCell()
        }
        
        schoolWithContactCell.schoolAddressLbl.text = "Location: " + Utils.getCompleteAddressWithoutCoordinate(withSatScore.school_location)
        if let phone_Number = withSatScore.school_phone_number, !phone_Number.isEmpty {
            schoolWithContactCell.schoolPhoneLbl.text = phone_Number
        }
        schoolWithContactCell.schoolWebsiteLbl.text = withSatScore.school_website
        
        return schoolWithContactCell
    }
    
    // returns school location cell
    static func tableViewCellWithAddress(_ tableView: UITableView, withSatScore: SchoolInfo) -> UITableViewCell{
        guard let schoolWithAddressCell = tableView.dequeueReusableCell(withIdentifier: Constants.schoolWithLocationCellIdentifier) as? SchoolLocationTableViewCell else {
            return UITableViewCell()
        }
        if let schoolCoordinate = Utils.getCoodinateForSelectedSchool(withSatScore.school_location){
            schoolWithAddressCell.addAnnotaionWithCoordinates(schoolCoordinate)
        }
        return schoolWithAddressCell
    }
}
