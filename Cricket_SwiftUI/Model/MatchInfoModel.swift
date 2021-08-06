//
//  MatchInfoModel.swift
//  Cricket_SwiftUI
//
//  Created by Sabari on 01/08/21.
//

import Foundation


import Foundation

// MARK: - PropertyData
struct MatchDetailsInfoData: Codable {
    let status: Bool?
    let msg: String?
    let data: MatchDetailsInfo?
}

// MARK: - DataClass
struct MatchDetailsInfo: Codable {
    let series, matchs, matchDate, matchTime: String?
    let venue, toss, matchType: String?
    let teamAID: Int?
    let teamA, teamAShort: String?
    let teamAImg: String?
    let teamBID: Int?
    let teamB, teamBShort: String?
    let teamBImg: String?

    enum CodingKeys: String, CodingKey {
        case series, matchs
        case matchDate = "match_date"
        case matchTime = "match_time"
        case venue, toss
        case matchType = "match_type"
        case teamAID = "team_a_id"
        case teamA = "team_a"
        case teamAShort = "team_a_short"
        case teamAImg = "team_a_img"
        case teamBID = "team_b_id"
        case teamB = "team_b"
        case teamBShort = "team_b_short"
        case teamBImg = "team_b_img"
    }
}
