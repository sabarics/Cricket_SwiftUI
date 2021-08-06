//
//  MatchLiveModel.swift
//  Cricket_SwiftUI
//
//  Created by Sabari on 06/08/21.
//

import Foundation

// MARK: - PropertyData
struct MatchLiveData: Codable {
    let status: Bool?
    let msg: String?
    let data: MatchLive?
}

// MARK: - DataClass
struct MatchLive: Codable {
    let matchID, seriesID: Int?
    let matchOver, minRate, maxRate, minRate1: String?
    let maxRate1, minRate2, maxRate2, favTeam: String?
    let session: String?
    let currentInning, battingTeam, ballingTeam: Int?
    let firstCircle, secondCircle, toss, result: String?
    let matchType: String?
    let sRun, sBall: Int?
    let sOvr, sMin, sMax: String?
    let teamAID: Int?
    let teamA, teamAShort: String?
    let teamAImg: String?
    let teamAScore: LiveTeamScore?
    let teamAScores, teamAOver: String?
    let teamBID: Int?
    let teamB, teamBShort: String?
    let teamBImg: String?
    let teamBScore: LiveTeamScore?
    let currRate, teamBScores, teamBOver: String?
    let target: Int?
    let rrRate: String?
    let runNeed, ballRem: Int?
    let trailLead: String?
    let lastwicket: Lastwicket?
    let batsman: [Batsman]?
    let partnership: Partnership?
    let bolwer: Bolwer?
    let last36Ball: [Last36Ball]?
    let nextBatsman: String?

    enum CodingKeys: String, CodingKey {
        case matchID = "match_id"
        case seriesID = "series_id"
        case matchOver = "match_over"
        case minRate = "min_rate"
        case maxRate = "max_rate"
        case minRate1 = "min_rate_1"
        case maxRate1 = "max_rate_1"
        case minRate2 = "min_rate_2"
        case maxRate2 = "max_rate_2"
        case favTeam = "fav_team"
        case session
        case currentInning = "current_inning"
        case battingTeam = "batting_team"
        case ballingTeam = "balling_team"
        case firstCircle = "first_circle"
        case secondCircle = "second_circle"
        case toss, result
        case matchType = "match_type"
        case sRun = "s_run"
        case sBall = "s_ball"
        case sOvr = "s_ovr"
        case sMin = "s_min"
        case sMax = "s_max"
        case teamAID = "team_a_id"
        case teamA = "team_a"
        case teamAShort = "team_a_short"
        case teamAImg = "team_a_img"
        case teamAScore = "team_a_score"
        case teamAScores = "team_a_scores"
        case teamAOver = "team_a_over"
        case teamBID = "team_b_id"
        case teamB = "team_b"
        case teamBShort = "team_b_short"
        case teamBImg = "team_b_img"
        case teamBScore = "team_b_score"
        case currRate = "curr_rate"
        case teamBScores = "team_b_scores"
        case teamBOver = "team_b_over"
        case target
        case rrRate = "rr_rate"
        case runNeed = "run_need"
        case ballRem = "ball_rem"
        case trailLead = "trail_lead"
        case lastwicket, batsman, partnership, bolwer
        case last36Ball = "last36ball"
        case nextBatsman = "next_batsman"
    }
}

enum Last36Ball: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Last36Ball.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Last36Ball"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - Lastwicket
struct Lastwicket: Codable {
    let player: String?
    let run, ball: Int?
}



// MARK: - TeamScore
struct LiveTeamScore: Codable {
    let the1, the2: The1?
    let teamID: Int?

    enum CodingKeys: String, CodingKey {
        case the1 = "1"
        case the2 = "2"
        case teamID = "team_id"
    }
}


// MARK: - The1
struct The1: Codable {
    let score, wicket: Int?
    let ball: String?
}
