//
//  HomeView.swift
//  Cricket_SwiftUI
//
//  Created by Sabari on 31/07/21.
//

import SwiftUI
import Foundation
import UIKit

struct HomeView: View {
    
    init() {
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = UIColor.clear
        UITableViewCell.appearance().backgroundColor = UIColor.clear
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().backgroundView = nil
        UITableViewCell.appearance().backgroundView = nil
        UITableView.appearance().allowsSelection = false
        UITableViewCell.appearance().selectionStyle = .none
        
    }
    
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    @State var matchTypeList:[MatchType] = getMatchTypeList()
    
    var body: some View {
        NavigationView{
            
            ZStack{
                MatchMainView(matchTypeList: $matchTypeList, viewModel: viewModel)
                if viewModel.isLiveLoading || viewModel.isUpcomingLoading || viewModel.isCompletedLoading {
                    LoaderView()
                }
            }
            .navigationTitle("Cricket")
        }
        .onAppear{
            DispatchQueue.main.async {
                matchTypeList = getMatchTypeList()
                viewModel.selectedType = getMatchTypeList().first!
                viewModel.getScheduledMatchList()
                viewModel.getLiveMatchList()
                viewModel.getCompletedMatchList()
            }
        }
        
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct HomeHeaderView: View{
    
    @State var matchType: MatchType!
    var body: some View{
        
        VStack(alignment:.leading){
            Text(matchType.typeName)
                .font(.headline)
            
            Rectangle()
                .frame(width: 70, height: 3, alignment: .leading)
                .foregroundColor(matchType.isSelected ? .red : .clear)
        }
        .padding(.horizontal,10)
    }
}


struct MatchMainView: View {
    
    @Binding var matchTypeList:[MatchType]
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View{
        //ScrollView
        List{
            //LazyVStack
            //LazyVStack{
            //Match Type View - Header View
            Section(header: MatchTypeView(matchTypeList: $matchTypeList, viewModel: viewModel)){

                
                ForEach(viewModel.matchList, id:\.self.matchID) { matchObj in
                    ZStack {
                        
                        MatchListView(viewModel: viewModel,matchData: matchObj)
                            //.padding(.horizontal, 10)
                            .padding(.bottom, 10)
                            .shadow(radius: 1)
                        
                        NavigationLink(
                            destination: MatchTypeRouting(viewModel: viewModel,matchObj: matchObj)){
                            Rectangle().opacity(0.0)
                        }.frame(width: 0, height: 0)
                        .hidden()
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                }
                .listRowBackground(Color.clear)
                
                .buttonStyle(PlainButtonStyle())
            }
        }
        .listStyle(SidebarListStyle())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal,-16)
    }
}

struct MatchTypeView:View {
    
    @Binding var matchTypeList:[MatchType]
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View{
        //HStack
        HStack{
            Spacer()
            
            ForEach(0..<matchTypeList.count){ index in
                Spacer()
                //LazyVStack
                LazyVStack(alignment:.leading){
                    
                    Text(matchTypeList[index].typeName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    //Rectangle
                    Rectangle()
                        .frame(width: 40, height: 3, alignment: .leading)
                        .foregroundColor(matchTypeList[index].isSelected ? .red : .clear)
                }
                .onTapGesture {
                    //Logic for selection and changes
                    for i in matchTypeList.indices {
                        self.matchTypeList[i].isSelected = false
                    }
                    
                    self.matchTypeList[index].isSelected = true
                    
                    viewModel.selectedType = self.matchTypeList[index]
                    DispatchQueue.main.async {
                        
                        //Reload match list based on MatchType(Upcoming,Live,Results)
                        if viewModel.selectedType.typeName == "Upcoming"{
                            viewModel.matchList = viewModel.upcomingMatchList
                        }
                        else if viewModel.selectedType.typeName == "Live"{
                            viewModel.matchList = viewModel.liveMatchList
                        }
                        else if viewModel.selectedType.typeName == "Results"{
                            viewModel.matchList = viewModel.completedMatchList
                        }
                    }
                }
                Spacer()
            }
        }
        .frame(maxWidth:.infinity)
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
}

struct MatchListView:View {
    @ObservedObject var viewModel: HomeViewModel
    @State var matchData: MatchList!
    @State var det1: String!
    
    var body: some View{
        //VStack
        LazyVStack{
            Text(matchData.series ?? "")
                .font(.subheadline)
                .foregroundColor(.black)
            
            Divider()
                .frame(width:UIScreen.main.bounds.width - 40 ,height: 0.5,alignment: .center)
                .background(Color.gray)
            //HStack
            HStack(alignment:.center){
                //LazyVStack
                LazyVStack(alignment:.leading){
                    
                    Text(matchData.teamA ?? "")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    
                    NetworkImage(url: URL(string: matchData.teamAImg ?? ""))
                        .frame(width: 50, height: 50)
                    // .clipShape(Circle())
                    
                    if self.viewModel.selectedType.typeName == "Results"{
                        
                        MatchScoreView(str1:"Overs - \(matchData.teamAOver ?? "NA")",str2:"Runs - \(matchData.teamAScores ?? "NA")")
                        
                    }
                    else if self.viewModel.selectedType.typeName == "Live"{
                        
                        if let score = matchData.teamAScore?["1"]{
                            
                            MatchScoreView(str1:"Overs - \(score.over ?? "NA")",str2:"Runs - \(score.score ?? 0)/\(score.wicket ?? 0)")
                            
                        }
                        else if let score = matchData.teamAScore?["2"]{
                            
                            MatchScoreView(str1:"Overs - \(score.over ?? "NA")",str2:"Runs - \(score.score ?? 0)/\(score.wicket ?? 0)")
                            
                        }
                        else{
                            
                            MatchScoreView(str1:"Yet to bat",str2:" ")
                        }
                    }
                }
                .frame(width: 110,alignment: .center)
                
                Spacer()
                
                if self.viewModel.selectedType.typeName == "Upcoming"{
                    MatchUpcomingTextView(matchData: self.matchData)
                }
                else if self.viewModel.selectedType.typeName == "Live"{
                    MatchLiveTextView(matchData: self.matchData)
                }
                else{
                    MatchResultTextView(matchData: self.matchData)
                }
                
                Spacer()
                //LazyVSatack
                LazyVStack(alignment:.trailing){
                    Text(matchData.teamB ?? "")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    
                    NetworkImage(url: URL(string: matchData.teamBImg ?? ""))
                        .frame(width: 50, height: 50)
                    //  .clipShape(Circle())
                    
                    if self.viewModel.selectedType.typeName == "Results"{
                        
                        MatchScoreView(str1:"Overs - \(matchData.teamBOver ?? "NA")",str2:"Runs - \(matchData.teamBScores ?? "NA")")
                    }
                    else if self.viewModel.selectedType.typeName == "Live"{
                        
                        if let score = matchData.teamBScore?["1"]{
                            
                            MatchScoreView(str1:"Overs - \(score.over ?? "NA")",str2:"Runs - \(score.score ?? 0)/\(score.wicket ?? 0)")
                            
                        }
                        else if let score = matchData.teamBScore?["2"]{
                            
                            MatchScoreView(str1:"Overs - \(score.over ?? "NA")",str2:"Runs - \(score.score ?? 0)/\(score.wicket ?? 0)")
                        }
                        else{
                            
                            MatchScoreView(str1:"Yet to bat",str2:" ")
                        }
                    }
                }
                .frame(width: 110,alignment: .center)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
    
}

struct MatchScoreView: View{
    
    @State var str1: String!
    @State var str2: String!
    
    var body: some View{
        VStack(alignment:.leading){
            Text(str1)
                .foregroundColor(.gray)
                .font(.caption)
            
            Text(str2)
                .foregroundColor(.gray)
                .font(.caption)
        }
    }
}


struct MatchUpcomingTextView: View {
    
    @State var matchData: MatchList!
    
    var body: some View{
        //LAzyVStack
        LazyVStack{
            
            Text("VS")
                .foregroundColor(.gray)
                .font(.caption)
            
            Text(matchData.dateWise?.components(separatedBy: ", ").first! ?? "" )
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            
            Text(matchData.matchTime ?? "")
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
        }
        .frame(width: 90,alignment: .center)
    }
}

struct MatchLiveTextView: View {
    
    @State var isAtMaxScale = false
    @State var matchData: MatchList!
    private let animation = Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: false)
    private let maxScale: CGFloat = 1.5
    
    var body: some View{
        //LazyVStack
        LazyVStack(spacing:10){
            Text("VS")
                .foregroundColor(.gray)
                .font(.caption)
            
            Text("Live")
                .font(.caption)
                .foregroundColor(.red)
                .scaleEffect(isAtMaxScale ? maxScale : 1)
                .onAppear {
                    withAnimation(animation) {
                        isAtMaxScale.toggle()
                    }
                }
        }
        .frame(width: 90,alignment: .center)
    }
}

struct MatchResultTextView: View {
    @State var matchData: MatchList!
    
    var body: some View{
        //LazyVStack
        LazyVStack(spacing:6){
            Spacer()
            Text("VS")
                .foregroundColor(.gray)
                .font(.caption)
            
            Text(matchData.dateWise?.components(separatedBy: ", ").first! ?? "" )
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            
            Text(matchData.result ?? "")
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.red)
        }
        .frame(width: 90,alignment: .center)
    }
}


struct MatchTypeRouting: View {
    
    @ObservedObject var viewModel: HomeViewModel
    @State var matchObj: MatchList!
    var body: some View{
        if viewModel.selectedType.typeName == "Upcoming"{
            MatchInfoView(matchId:matchObj.matchID ?? 476,matchName:matchObj.series ?? "")
        }
        else if viewModel.selectedType.typeName == "Live"{
            MatchLiveView(matchId:matchObj.matchID ?? 476,matchName:matchObj.series ?? "")
        }
        else{
            MatchResultView(matchId:matchObj.matchID ?? 476,matchName:matchObj.series ?? "")
        }
    }
}
