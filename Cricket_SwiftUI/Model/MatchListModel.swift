//
//  MatchListModel.swift
//  Cricket_SwiftUI
//
//  Created by Sabari on 01/08/21.
//

import Foundation

import Foundation

// MARK: - PropertyData
struct MatchData: Codable {
    let status: Bool?
    let msg: String?
    let data: [MatchList]?
}

// MARK: - Datum
struct MatchList: Codable {
    let matchID: Int?
    let series, dateWise, matchDate, matchTime: String?
    let matchs, venue: String?
   // let matchType: MatchTypes?
    let result: String?
    let teamAID: Int?
    let teamA, teamAShort: String?
    let teamAImg: String?
    let teamAScores, teamAOver: String?
    let teamBID: Int?
    let teamB, teamBShort: String?
    let teamBImg: String?
    let teamBScores, teamBOver: String?
    let teamBScore, teamAScore: [String: TeamScore]?

    enum CodingKeys: String, CodingKey {
        case matchID = "match_id"
        case series
        case dateWise = "date_wise"
        case matchDate = "match_date"
        case matchTime = "match_time"
        case matchs, venue
       // case matchType = "match_type"
        case result
        case teamAID = "team_a_id"
        case teamA = "team_a"
        case teamAShort = "team_a_short"
        case teamAImg = "team_a_img"
        case teamAScores = "team_a_scores"
        case teamAOver = "team_a_over"
        case teamBID = "team_b_id"
        case teamB = "team_b"
        case teamBShort = "team_b_short"
        case teamBImg = "team_b_img"
        case teamBScores = "team_b_scores"
        case teamBOver = "team_b_over"
        case teamBScore = "team_b_score"
        case teamAScore = "team_a_score"
    }
}

enum MatchTypes: String, Codable {
    case odi = "ODI"
    case t20 = "T20"
    case test = "Test"
}


// MARK: - TeamScore
struct TeamScore: Codable {
    let score, wicket: Int?
    let over: String?
}
