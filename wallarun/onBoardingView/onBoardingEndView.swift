//
//  onBoardingEndView.swift
//  wallarun
//
//  Created by 정현 on 2023/08/26.
//

import SwiftUI

struct onBoardingEndView: View {
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                Image("TextBalloon")
                Spacer()
                Button{} label: {
                    NavigationLink(destination: GameView()){
                        Image("StartButton")
                    }
                }
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)

    }
}

struct onBoardingEndView_Previews: PreviewProvider {
    static var previews: some View {
        onBoardingEndView()
    }
}
