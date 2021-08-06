//
//  MatchLiveViewModel.swift
//  Cricket_SwiftUI
//
//  Created by Sabari on 06/08/21.
//

import Foundation


class MatchLiveViewModel: ObservableObject {
    
    @Published var isMatchLoading: Bool = true
    @Published var matchLiveData: MatchLive!
    @Published var isScocardLoading = false
    @Published var matchScoreCard:MatchResult!
    @Published var teamAScoreCard:Scorecard!
    @Published var teamBScoreCard:Scorecard!
    @Published var matchDetails:MatchDetailsInfo!
    @Published var isMatchResultLoading = false

    func getLiveMatchDetails(matchId:Int){
        
        isMatchLoading = true
        
        let urlString = "http://13.127.190.65/api2/live/\(apiKey)?match_id=\(matchId)"
        
        guard let url = URL(string: urlString) else{
            fatalError("invalid request URL")
        }
        
        WebServiceWrapper.shared.jsonGetTask(url: url) { (response) in
            
            self.isMatchLoading = false
            
            switch response
            {
            case .Error(let error):
                print(error.localizedDescription)
                return
                
            case .ApiError(let apiError):
                print(apiError.debugDescription)
                
            case .Success(let json):
                if let jsonData = try? JSONSerialization.data(withJSONObject: json){
                    let responseData = try! JSONDecoder().decode(MatchLiveData.self, from: jsonData)
                    self.matchLiveData =  responseData.data
                }
            }
        }
    }
    
    func getScoreCardDetails(matchId:Int){
        isScocardLoading = true
        
        let urlString = "http://13.127.190.65/api2/scorecard/\(apiKey)?match_id=\(matchId)"
        
        guard let url = URL(string: urlString) else{
            fatalError("invalid request URL")
        }
        
        WebServiceWrapper.shared.jsonGetTask(url: url) { (response) in
            
            self.isScocardLoading = false
            
            switch response
            {
            case .Error(let error):
                print(error.localizedDescription)
                return
                
            case .ApiError(let apiError):
                print(apiError.debugDescription)
                
            case .Success(let json):
                //6 parsing the Json response
                if let jsonData = try? JSONSerialization.data(withJSONObject: json){
                    let responseData = try! JSONDecoder().decode(MatchResultData.self, from: jsonData)
                    self.matchScoreCard = responseData.data
                    self.setTeamsScoreCards()
                }
            }
        }
    }
    
    
    fileprivate func setTeamsScoreCards(){
        if let teamAScore = self.matchScoreCard?.scorecard?["1"]{
            self.teamAScoreCard = teamAScore
        }
        if let teamBScore = self.matchScoreCard?.scorecard?["2"] {
            self.teamBScoreCard = teamBScore
        }
    }
    
    func getMatchDetails(matchId:Int){
        
        isMatchResultLoading = true
        
        let urlString = "http://13.127.190.65/api2/info/\(apiKey)?match_id=\(matchId)"
        
        guard let url = URL(string: urlString) else{
            fatalError("invalid request URL")
        }
        
        WebServiceWrapper.shared.jsonGetTask(url: url) { (response) in
            
            self.isMatchResultLoading = false
            
            switch response
            {
            case .Error(let error):
                print(error.localizedDescription)
                return
                
            case .ApiError(let apiError):
                print(apiError.debugDescription)
                
            case .Success(let json):
                if let jsonData = try? JSONSerialization.data(withJSONObject: json){
                    let responseData = try! JSONDecoder().decode(MatchDetailsInfoData.self, from: jsonData)
                    self.matchDetails =  responseData.data
                }
            }
        }
    }
    
}
