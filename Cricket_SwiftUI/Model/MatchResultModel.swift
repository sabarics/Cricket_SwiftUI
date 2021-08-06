//
//  MatchResultModel.swift
//  Cricket_SwiftUI
//
//  Created by Sabari on 01/08/21.
//

import Foundation


import Foundation

// MARK: - PropertyData
struct MatchResultData: Codable {
    let status: Bool?
    let msg: String?
    let data: MatchResult?
}

// MARK: - DataClass
struct MatchResult: Codable {
    let result: String?
    let scorecard: [String: Scorecard]?
}

// MARK: - Scorecard
struct Scorecard: Codable {
    let team: PlayingTeam?
    let batsman: [Batsman]?
    let bolwer: [Bolwer]?
    let fallwicket: [Fallwicket]?
    let partnership: [Partnership]?
}

// MARK: - Batsman
struct Batsman: Codable {
    let id = UUID()
    let name: String?
    let run, ball, fours, sixes: Int?
    let strikeRate, outBy: String?

    enum CodingKeys: String, CodingKey {
        case name, run, ball, fours, sixes
        case strikeRate = "strike_rate"
        case outBy = "out_by"
    }
}

// MARK: - Bolwer
struct Bolwer: Codable {
    let id = UUID()
    let name, over: String?
    let maiden, run, wicket: Int?
    let economy: String?
}

// MARK: - Fallwicket
struct Fallwicket: Codable {
    let id = UUID()
    let player: String?
    let score, wicket: Int?
    let over: String?
}

// MARK: - Partnership
struct Partnership: Codable {
    let playerA, playerB: String?
    let run, ball: Int?

    enum CodingKeys: String, CodingKey {
        case playerA = "player_a"
        case playerB = "player_b"
        case run, ball
    }
}

// MARK: - Team
struct PlayingTeam: Codable {
    let name: String?
    let flag: String?
    let score, wicket: Int?
    let over, extras: String?
}
