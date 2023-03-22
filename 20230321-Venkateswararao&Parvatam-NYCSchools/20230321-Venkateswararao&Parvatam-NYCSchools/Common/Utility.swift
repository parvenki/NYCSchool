//
//  Utility.swift
//  20230321-Venkateswararao&Parvatam-NYCSchools
//
//  Created by Venkat_Sravani on 3/20/23.
//

import Foundation
import CoreLocation
import MapKit

class Utils {
    
    // returns address
    static func getCompleteAddressWithoutCoordinate(_ schoolAddr: String?) -> String{
        if let schoolAddress = schoolAddr{
            let address = schoolAddress.components(separatedBy: "(")
            return address[0]
        }
        return ""
    }
    
   //featch school lat and lang details
    static func getCoodinateForSelectedSchool(_ schoolAddr: String?) -> CLLocationCoordinate2D?{
        if let schoolAddress = schoolAddr{
            let coordinateString = schoolAddress.getRangeString(from: "(", to: ")")
            let coordinates = coordinateString?.components(separatedBy: ",")
            if let coordinateArray = coordinates{
                let latitude = (coordinateArray[0] as NSString).doubleValue
                let longitude = (coordinateArray[1] as NSString).doubleValue
                return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
            }
        }
        return nil
    }
    
    // JSON parse
    static func getSchoolInfoWithJSON(_ json: [String: Any]) -> SchoolInfo?{
        if !json.isEmpty{
            let nycSchools = SchoolInfo()
            if let dbnObject = json["dbn"] as? String{
                nycSchools.dbn = dbnObject
            }
            
            if let schoolNameOnject = json["school_name"] as? String{
                nycSchools.school_name = schoolNameOnject
            }
            
            if let overviewParagraphObject = json["overview_paragraph"] as? String{
                nycSchools.overview_paragraph = overviewParagraphObject
            }
            if let schoolAddressObject = json["location"] as? String{
                nycSchools.school_location = schoolAddressObject
            }
            if let schoolTelObject = json["phone_number"] as? String{
                nycSchools.school_phone_number = schoolTelObject
            }
            
            if let websiteObject = json["website"] as? String{
                nycSchools.school_website = websiteObject
            }
            
            if let finalgrades = json["finalgrades"] as? String {
                nycSchools.finalgrades = finalgrades
            }
            
            return nycSchools
        }
        return nil
    }
    
    // array of school info
    static func fetchNYCSchoolWithJsonData(_ schoolsData: Any) -> [SchoolInfo]?{
        guard let schoolsDetailsArray = schoolsData as? [[String: Any]] else{
            return nil
        }
        var schoolModelArray = [SchoolInfo]()
        for schoolsDetail in schoolsDetailsArray {
            if let schoolModels = Utils.getSchoolInfoWithJSON(schoolsDetail){
                schoolModelArray.append(schoolModels)
            }
        }
        return schoolModelArray
    }
    
}
