//
//  MatchInfoViewModel.swift
//  Cricket_SwiftUI
//
//  Created by Sabari on 01/08/21.
//

import Foundation


class MatchInfoViewModel: ObservableObject {
    
    @Published var isMatchInfoLoading = false
    @Published var isPlayerInfoLoading = false
    @Published var matchDetails:MatchDetailsInfo!
    @Published var teamAPlayer:[Player] = []
    @Published var teamBPlayer:[Player] = []
    
    
    func getMatchDetails(matchId:Int){
        
        isMatchInfoLoading = true
        
        let urlString = "http://13.127.190.65/api2/info/\(apiKey)?match_id=\(matchId)"
        
        guard let url = URL(string: urlString) else{
            fatalError("invalid request URL")
        }
        
        WebServiceWrapper.shared.jsonGetTask(url: url) { (response) in
            
            self.isMatchInfoLoading = false
            
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
                    let responseData = try! JSONDecoder().decode(MatchDetailsInfoData.self, from: jsonData)
                    self.matchDetails =  responseData.data
                }
            }
        }
    }
    
    func getPlayerDetails(matchId:Int){
        
        isPlayerInfoLoading = true
        
        let urlString = "http://13.127.190.65/api2/playerxi/\(apiKey)?match_id=\(matchId)"
        
        guard let url = URL(string: urlString) else{
            fatalError("invalid request URL")
        }
        
        WebServiceWrapper.shared.jsonGetTask(url: url) { (response) in
            
            self.isPlayerInfoLoading = false
            
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
                    let responseData = try! JSONDecoder().decode(PlayerInfoData.self, from: jsonData)
                    self.teamAPlayer =  responseData.data?.teamA?.player ?? []
                    self.teamBPlayer =  responseData.data?.teamB?.player ?? []
                }
            }
        }
    }
}
