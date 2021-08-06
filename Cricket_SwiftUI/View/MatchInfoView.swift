//
//  MatchInfoView.swift
//  Cricket_SwiftUI
//
//  Created by Sabari on 01/08/21.
//

import SwiftUI

struct MatchInfoView: View {
    
    @StateObject var viewModel: MatchInfoViewModel = MatchInfoViewModel()
    @State var matchId:Int = 476
    @State var matchName: String = ""
    
    var body: some View {
        
        ZStack{
            
            MatchInfoMainView(viewModel: viewModel)
            //Loader
            if viewModel.isMatchInfoLoading || viewModel.isPlayerInfoLoading{
                LoaderView()
            }
        }
        .onAppear{
            viewModel.getMatchDetails(matchId: matchId)
            viewModel.getPlayerDetails(matchId: matchId)
        }
        .navigationTitle("Match Info")
    }
}

struct MatchInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MatchInfoView()
    }
}

struct MatchInfoMainView: View {
    @ObservedObject var viewModel: MatchInfoViewModel
    @State var teamSelection: Int = 0
    var body: some View{
        //Scroll View
        ScrollView{
            //VStack
            VStack(alignment:.leading){
                
                MatchInfoHeaderView(viewModel: viewModel)
                
                Text("Team Squad")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.vertical,10)
                
                //Segment View
                Picker(selection: $teamSelection, label: Text(""), content: {
                    if viewModel.matchDetails != nil{
                        Text(viewModel.matchDetails.teamA ?? "").tag(0)
                        Text(viewModel.matchDetails.teamB ?? "").tag(1)
                    }
                })
                .padding(.horizontal)
                .padding(.bottom, 10)
                .pickerStyle(SegmentedPickerStyle())
                
                ForEach(teamSelection == 0 ? viewModel.teamAPlayer : viewModel.teamBPlayer, id:\.self.id) { playerInfo in
                    PlayerInfoView(playerInfo: playerInfo)
                }
            }
        }
    }
}

struct MatchInfoHeaderView: View {
    
    @ObservedObject var viewModel: MatchInfoViewModel
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
                           // .clipShape(Circle())
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
                            //.clipShape(Circle())
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
                
                Text("Match Time: \(viewModel.matchDetails.matchTime ?? "")")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .shadow(radius: 1)
            
        }
    }
}

struct PlayerInfoView: View {
    
    @State var playerInfo: Player!
    
    var body: some View {
        if playerInfo != nil{
            //VStack
            VStack(alignment:.leading){
                //HStack
                HStack{
                    
                    NetworkImage(url: URL(string: playerInfo.image?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")!)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                    //VStack
                    VStack(alignment:.leading,spacing:4){
                        
                        Text(playerInfo.name ?? "")
                            .font(.custom("", fixedSize: 15))
                        
                        Text(playerInfo.playRole ?? "")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                .padding(10)
            }
            .padding(.vertical,1)
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal,16)
            .shadow(radius: 1)
        }
    }
}
