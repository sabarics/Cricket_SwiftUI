//
//  LoaderView.swift
//  Cricket_SwiftUI
//
//  Created by Sabari on 01/08/21.
//

import SwiftUI

struct LoaderView1: View {
    
    @State var isAnimationg: Bool = false
    
    var body: some View {
        ZStack{
            Color.white.edgesIgnoringSafeArea(.all)
            Circle()
                .trim(from: 0.0, to: 0.8)
                .stroke(Color.red, style: .init(lineWidth: 5, lineCap: .round))
                .rotationEffect(.degrees(isAnimationg ? 360 : 0))
                .animation(isAnimationg ? .linear(duration: 0.5).repeatForever(autoreverses: false) :.default)
                .frame(width: 70, height: 70, alignment: .center)
        }
        
        .onAppear{
            DispatchQueue.main.async {
                isAnimationg = true
            }
        }
        .onDisappear{
            DispatchQueue.main.async {
                isAnimationg = false
            }
            
        }
    }
}


struct LoaderView: View {
    @State var isAnimated: Bool = false
    var body: some View {
        ZStack{
            ZStack{
                Color.white
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 14)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .trim(from: 0, to: 0.2)
                    .stroke(Color.red, lineWidth: 7)
                    .frame(width: 80, height: 80)
                    .rotationEffect(Angle(degrees: isAnimated ? 360 : 0))
                    .animation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false))
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear{
            DispatchQueue.main.async {
                isAnimated = true
            }
        }
        .onDisappear{
            DispatchQueue.main.async {
                isAnimated = false
            }
        }
    }
}
struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView()
    }
}
