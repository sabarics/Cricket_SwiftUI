//
//  MatchResultView.swift
//  Cricket_SwiftUI
//
//  Created by Sabari on 01/08/21.
//

import SwiftUI

struct MatchResultView: View {
    
    @StateObject var viewModel: MatchResultViewModel = MatchResultViewModel()
    @State var matchId:Int = 330
    @State var matchName: String = ""
    @State var teamSelection: Int = 0
    
    var body: some View {
        //ZStack
        ZStack{
            //ScrollView
            ScrollView{
                //VStack
                VStack(alignment:.leading){
                    MatchResultHeaderView(viewModel: viewModel)
                    ScoreCardListView(viewModel: viewModel, teamSelection: $teamSelection)
                }
            }
            //Loader
            if viewModel.isScocardLoading || viewModel.isMatchResultLoading{
                LoaderView()
            }
        }
        .onAppear{
            viewModel.getMatchDetails(matchId: matchId)
            viewModel.getScoreCardDetails(matchId: matchId)
        }
        .navigationTitle("Match Info")
    }
}

struct MatchResultView_Previews: PreviewProvider {
    static var previews: some View {
        MatchResultView()
    }
}


struct MatchResultHeaderView: View {
    
    @ObservedObject var viewModel: MatchResultViewModel
    var body: some View {
        if viewModel.matchDetails != nil{
            //VStack
            VStack(alignment:.leading,spacing:6){
                
                Text(viewModel.matchDetails.series ?? "")
                    .font(.title3)
                    .fontWeight(.bold)
                    .lineLimit(0)
                    .multilineTextAlignment(.leading)
                //HStack
                HStack{
                    //VStack
                    VStack{
                        NetworkImage(url: URL(string: viewModel.matchDetails.teamAImg ?? "")!)
                            .frame(width: 100, height: 100, alignment: .center)
                            //.clipShape(Circle())
                        Text(viewModel.matchDetails.teamA ?? "")
                            .font(.headline)
                    }
                    Spacer()
                    
                    Text("VS")
                        .font(.callout)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    //VStack
                    VStack{
                        NetworkImage(url: URL(string: viewModel.matchDetails.teamBImg ?? "")!)
                            .frame(width: 100, height: 100, alignment: .center)
                           // .clipShape(Circle())
                        Text(viewModel.matchDetails.teamB ?? "")
                            .font(.headline)
                    }
                }
                Spacer()
                    .frame(height: 20)
                
                Text(viewModel.matchDetails.matchs ?? "")
                    .font(.headline)
                
                Text("Venue: \(viewModel.matchDetails.venue ?? "")")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                
                Text("Match Date: \(viewModel.matchDetails.matchDate ?? "")")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                
                Text( viewModel.matchDetails.toss ?? "")
                    .foregroundColor(.black)
                    .font(.subheadline)
                if viewModel.matchScoreCard != nil {
                    Text(viewModel.matchScoreCard.result ?? "")
                        .foregroundColor(.red)
                        .font(.headline)
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

struct ScoreCardListView: View {
    @StateObject var viewModel: MatchResultViewModel
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


struct ScoreCardHeaderView: View {
    
    @State var isBatting:Bool = true
    
    var body: some View{
        HStack{
            HStack{
                Text(isBatting ? "Batsman" : "Bowler")
                    .bold()
                Spacer()
            }
            .frame(maxWidth:.infinity)
            
            Text(isBatting ? "R" : "O")
                .bold()
                .frame(width:40)
            Text(isBatting ? "B" : "M")
                .bold()
                .frame(width:30)
            Text(isBatting ? "4s" : "R")
                .bold()
                .frame(width:30)
            Text(isBatting ? "6s" : "W")
                .bold()
                .frame(width:30)
            Text(isBatting ? "SR" : "ER")
                .bold()
                .frame(width:55)
        }
        .padding()
        .background(Color.black.opacity(0.05))
        .cornerRadius(5)
        .padding(.horizontal)
    }
}

struct ScoreCardView: View {
    
    @State var batsman: Batsman!
    @State var bowler: Bolwer!
    @State var isBatting:Bool = true
    
    var body: some View{
        HStack{
            if isBatting ? batsman != nil : bowler != nil{
                HStack{
                    VStack(alignment:.leading){
                        Text(isBatting ? batsman.name ?? "" : bowler.name ?? "")
                            .font(.subheadline)
                            .bold()
                        if isBatting{
                            Text(isBatting ? batsman.outBy ?? "" : "")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        }
                    }
                    Spacer()
                }
                .frame(maxWidth:.infinity)
                
                Text(isBatting ? "\(batsman.run ?? 0)" : bowler.over ?? "")
                    .frame(width:40)
                    .font(.subheadline)
                
                Text(isBatting ? "\(batsman.ball ?? 0)" : "\(bowler.maiden ?? 0)")
                    .frame(width:30)
                    .font(.subheadline)
                Text(isBatting ? "\(batsman.fours ?? 0)" : "\(bowler.run ?? 0)")
                    .frame(width:30)
                    .font(.subheadline)
                Text(isBatting ? "\(batsman.sixes ?? 0)" : "\(bowler.wicket ?? 0)")
                    .frame(width:30)
                    .font(.subheadline)
                Text(isBatting ? batsman.strikeRate ?? "" : bowler.economy ?? "")
                    .frame(width:55)
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .padding(.horizontal)
        .shadow(radius: 1)
    }
}

struct FallOfWicketView: View {
    @State var wicket:Fallwicket!
    var body: some View{
        HStack{
            Text("\(wicket.score ?? 0)-\(wicket.wicket ?? 0)")
                .frame(width:50)
            Text("(\(wicket.player ?? "")), Over:\(wicket.over ?? "0")")
            Spacer()
        }
    }
}
