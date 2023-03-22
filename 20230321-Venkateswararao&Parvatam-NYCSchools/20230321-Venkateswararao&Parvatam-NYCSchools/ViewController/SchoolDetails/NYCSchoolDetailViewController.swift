//
//  NYCSchoolDetailViewController.swift
//  20230321-Venkateswararao&Parvatam-NYCSchools
//
//  Created by Venkat_Sravani on 3/20/23.
//

import Foundation
import UIKit
import CoreLocation
import MapKit


class NYCSchoolDetailViewController: UITableViewController {
    
    var schoolWithSatScore: SchoolInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = schoolWithSatScore?.school_name
        self.tableView.rowHeight = UITableView.automaticDimension
    }

}

extension NYCSchoolDetailViewController {
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return SchoolDetailsCell.tableViewCellWithSATScore(self.tableView, withSatScore: schoolWithSatScore ?? SchoolInfo())
        case 1:
            return SchoolDetailsCell.tableViewCellWithOverView(self.tableView, withSatScore: schoolWithSatScore ?? SchoolInfo())
        case 2:
            return SchoolDetailsCell.tableViewCellWithContactInfo(self.tableView, withSatScore: schoolWithSatScore ?? SchoolInfo())
        default:
            return SchoolDetailsCell.tableViewCellWithAddress(self.tableView, withSatScore: schoolWithSatScore ?? SchoolInfo())
        }
    }
    
    //MARK: - UITable View Delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0,1,2:
            return UITableView.automaticDimension
        default:
            return UIScreen.main.bounds.width * 0.7
        }
    }
}
