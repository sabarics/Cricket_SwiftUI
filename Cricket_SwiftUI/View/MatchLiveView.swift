//
//  MatchLiveView.swift
//  Cricket_SwiftUI
//
//  Created by Sabari on 06/08/21.
//

import SwiftUI

struct MatchLiveView: View {
    
    @StateObject var viewModel: MatchLiveViewModel = MatchLiveViewModel()
    @State var matchId:Int = 330
    @State var matchName: String = ""
    @State var teamSelection: Int = 0
    
    var body: some View {
        ScrollView{
            VStack(alignment:.leading){
                MatchHeaderView(viewModel: viewModel)
                ScoreCardLiveListView(viewModel: viewModel, teamSelection: $teamSelection)
            }
        }
        .onAppear{
            viewModel.getMatchDetails(matchId: matchId)
            viewModel.getScoreCardDetails(matchId: matchId)
            viewModel.getLiveMatchDetails(matchId: matchId)
        }
        .navigationTitle("Match Info")
    }
}

struct MatchLiveView_Previews: PreviewProvider {
    static var previews: some View {
        
        MatchLiveView()

    }
}

struct MatchHeaderView:View {
    @ObservedObject var viewModel: MatchLiveViewModel
    var body: some View{
        if viewModel.matchDetails != nil && viewModel.matchLiveData != nil{
            VStack(alignment:.leading){
                Text(viewModel.matchDetails.series ?? "")
                HStack{
                    //VStack
                    VStack{
                        NetworkImage(url: URL(string: viewModel.matchDetails.teamAImg ?? "")!)
                            .frame(width: 100, height: 100, alignment: .center)
                        Text(viewModel.matchDetails.teamA ?? "")
                            .font(.headline)
                        if let score = viewModel.matchLiveData.teamAScore{
                            if let score1 = score.the1{
                                MatchScoreView(str1:"Overs - \(score1.ball ?? "")",str2:"Runs - \(score1.score ?? 0)/\(score1.wicket ?? 0)")
                            }
                            else if let score2 = score.the2{
                                MatchScoreView(str1:"Overs - \(score2.ball ?? "")",str2:"Runs - \(score2.score ?? 0)/\(score2.wicket ?? 0)")
                            }
                            else{
                                Text("Yet to Bat")
                            }
                        }
                    }
                    Spacer()
                    
                    Text("VS")
                        .font(.callout)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    VStack{
                        NetworkImage(url: URL(string: viewModel.matchDetails.teamBImg ?? "")!)
                            .frame(width: 100, height: 100, alignment: .center)
                        Text(viewModel.matchDetails.teamB ?? "")
                            .font(.headline)
                        if let score = viewModel.matchLiveData.teamBScore{
                            if let score1 = score.the1{
                                MatchScoreView(str1:"Overs - \(score1.ball ?? "")",str2:"Runs - \(score1.score ?? 0)/\(score1.wicket ?? 0)")
                            }
                            else if let score2 = score.the2{
                                MatchScoreView(str1:"Overs - \(score2.ball ?? "")",str2:"Runs - \(score2.score ?? 0)/\(score2.wicket ?? 0)")
                            }
                        }
                    }
                }
                
                Spacer()
                    .frame(height: 10)
                VStack(alignment:.leading,spacing:10){
                    Text("Batsman")
                        .font(.title3)
                    HStack{
                        VStack(alignment:.leading){
                            if let firstBatsman = viewModel.matchLiveData?.batsman?[0]
                            {
                                Text(firstBatsman.name ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                Text("\(firstBatsman.run ?? 0)(\(firstBatsman.ball ?? 0)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer()
                            .frame(width: 20)
                        
                        VStack(alignment:.leading){
                            if let firstBatsman = viewModel.matchLiveData?.batsman?[1]
                            {
                                Text(firstBatsman.name ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                Text("\(firstBatsman.run ?? 0)(\(firstBatsman.ball ?? 0)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                
                Spacer()
                    .frame(height: 10)
                VStack(alignment:.leading,spacing:10){
                    Text("Bowler")
                        .font(.title3)
                    HStack{
                        VStack(alignment:.leading){
                            if let bowler = viewModel.matchLiveData?.bolwer
                            {
                                Text(bowler.name ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                Text("Overs - \(bowler.over ?? "")")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Runs - \(bowler.run ?? 0)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Economy - \(bowler.economy ?? "")")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                
                
                Spacer()
                    .frame(height: 10)
                HStack{
                    if let batsman = viewModel.matchLiveData?.lastwicket
                    {
                        Text("Last Wicket -")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("\(batsman.player ?? "") \(batsman.run ?? 0)(\(batsman.ball ?? 0)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .shadow(radius: 1)
        }
    }
}



struct ScoreCardLiveListView: View {
    @StateObject var viewModel: MatchLiveViewModel
    @Binding var teamSelection: Int
    var body: some View{
        //VStack
        VStack(alignment:.leading){
            Text("ScoreCard")
                .font(.title2)
                .bold()
        }
        .padding()
        //Segment View
        if viewModel.matchDetails != nil{
            Picker(selection: $teamSelection, label: Text(""), content: {
                if viewModel.matchDetails != nil{
                    Text(viewModel.matchDetails.teamA ?? "").tag(0)
                    Text(viewModel.matchDetails.teamB ?? "").tag(1)
                }
            })
            .padding(.horizontal)
            .padding(.bottom, 10)
            .pickerStyle(SegmentedPickerStyle())
            
            //Batting Header
            ScoreCardHeaderView(isBatting: true)
            //Batting List
            ForEach(teamSelection == 0 ? viewModel.teamAScoreCard?.batsman ?? [] : viewModel.teamBScoreCard?.batsman ?? [], id:\.self.id){ batsman in
                //Scorcard Batting View
                ScoreCardView(batsman: batsman,isBatting:true)
            }
            Spacer()
                .frame(height:30)
            //Bowling Header
            ScoreCardHeaderView(isBatting: false)
            //Bowling List
            ForEach(teamSelection == 0 ? viewModel.teamAScoreCard?.bolwer ?? [] : viewModel.teamBScoreCard?.bolwer ?? [], id:\.self.id){ bowler in
                //Scorcard Bowlling View
                ScoreCardView(bowler: bowler,isBatting:false)
            }
            
            //Fall of wicket view
            if viewModel.teamAScoreCard != nil && viewModel.teamBScoreCard != nil{
                //VStack - Fall of wicket header
                VStack(alignment:.leading){
                    Spacer()
                        .frame(height:30)
                    HStack{
                        Text("Fall of Wicket")
                            .bold()
                        Spacer()
                    }
                    .padding()
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(5)
                    .padding(.horizontal)
                    
                    VStack(alignment:.leading,spacing:8){
                        ForEach(teamSelection == 0 ? viewModel.teamAScoreCard?.fallwicket ?? [] : viewModel.teamBScoreCard?.fallwicket ?? [], id:\.self.id) {  wicket in
                            FallOfWicketView(wicket: wicket)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .shadow(radius: 1)
                }
            }
        }
    }
}
