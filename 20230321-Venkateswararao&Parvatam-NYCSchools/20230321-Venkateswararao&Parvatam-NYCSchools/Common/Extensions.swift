//
//  Extensions.swift
//  20230321-Venkateswararao&Parvatam-NYCSchools
//
//  Created by Venkat_Sravani on 3/20/23.
//

import Foundation
import UIKit


extension String {
    // Seperate string from range.
    func getRangeString(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
