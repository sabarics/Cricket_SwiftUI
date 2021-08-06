//
//  Functions.swift
//  Cricket_SwiftUI
//
//  Created by Sabari on 31/07/21.
//

import Foundation



/// Get Match type list
/// - Returns: array of matchtype 
func getMatchTypeList()->[MatchType]{
    
    return [MatchType(typeName: "Upcoming",isSelected:true),
            MatchType(typeName: "Live",isSelected:false),
            MatchType(typeName: "Results",isSelected:false)
    ]
}
