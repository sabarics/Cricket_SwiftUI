//
//  HomeViewModel.swift
//  Cricket_SwiftUI
//
//  Created by Sabari on 01/08/21.
//

import Foundation


class HomeViewModel: ObservableObject {
    
    @Published var selectedType: MatchType = getMatchTypeList().first!
    @Published var isUpcomingLoading: Bool =  false
    @Published var isLiveLoading: Bool =  false
    @Published var isCompletedLoading: Bool =  false
    @Published var upcomingMatchList:[MatchList] = []
    @Published var liveMatchList:[MatchList] = []
    @Published var completedMatchList:[MatchList] = []
    @Published var matchList:[MatchList] = []
    
    
    func getScheduledMatchList(){
        
        isUpcomingLoading = true
        
        let urlString = "http://13.127.190.65/api2/scheduleMatches/\(apiKey)"
        
        guard let url = URL(string: urlString) else{
            fatalError("invalid request URL")
        }
        
        WebServiceWrapper.shared.jsonGetTask(url: url) { (response) in
            
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
                    let responseData = try! JSONDecoder().decode(MatchData.self, from: jsonData)
                    self.upcomingMatchList = responseData.data ?? []
                    self.matchList = self.upcomingMatchList
                    self.isUpcomingLoading = false
                }
            }
        }
    }
    
    func getLiveMatchList(){
        isLiveLoading = true
        
        let urlString = "http://13.127.190.65/api2/liveMatches/\(apiKey)"
        guard let url = URL(string: urlString) else{
            fatalError("invalid request URL")
        }
        
        WebServiceWrapper.shared.jsonGetTask(url: url) { (response) in
            self.isLiveLoading = false
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
                    let responseData = try! JSONDecoder().decode(MatchData.self, from: jsonData)
                    self.liveMatchList = responseData.data ?? []
                    //self.matchList = self.liveMatchList
                }
            }
        }
    }
    
    func getCompletedMatchList(){
        isCompletedLoading = true
        
        let urlString = "http://13.127.190.65/api2/completeMatches/\(apiKey)"
        
        guard let url = URL(string: urlString) else{
            fatalError("invalid request URL")
        }
        
        WebServiceWrapper.shared.jsonGetTask(url: url) { (response) in
            self.isCompletedLoading = false
            
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
                    let responseData = try! JSONDecoder().decode(MatchData.self, from: jsonData)
                    self.completedMatchList = responseData.data ?? []
                  //  self.matchList = self.completedMatchList
                }
                
            }
            
        }
    }
}
