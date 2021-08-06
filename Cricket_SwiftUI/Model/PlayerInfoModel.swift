//
//  PlayerInfoModel.swift
//  Cricket_SwiftUI
//
//  Created by Sabari on 01/08/21.
//

import Foundation

// MARK: - PropertyData
struct PlayerInfoData: Codable {
    let status: Bool?
    let msg: String?
    let data: PlayerInfo?
}

// MARK: - DataClass
struct PlayerInfo: Codable {
    let teamA, teamB: Team?

    enum CodingKeys: String, CodingKey {
        case teamA = "team_a"
        case teamB = "team_b"
    }
}

// MARK: - Team
struct Team: Codable {
    let name, shortName: String?
    let flag: String?
    let player: [Player]?

    enum CodingKeys: String, CodingKey {
        case name
        case shortName = "short_name"
        case flag, player
    }
}

// MARK: - Player
struct Player: Codable {
    let id = UUID()
    let name: String?
    let playRole: String?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case name
        case playRole = "play_role"
        case image
    }
}

enum PlayRole: String, Codable {
    case batsman = "Batsman"
    case battingAllrounder = "Batting Allrounder"
    case bowler = "Bowler"
    case bowlingAllrounder = "Bowling Allrounder"
    case empty = "--"
    case wkBatsman = "WK-Batsman"
}
