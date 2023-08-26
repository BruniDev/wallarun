//
//  StartView.swift
//  wallarun
//
//  Created by 정현 on 2023/08/26.
//

import SwiftUI

struct onBoardingStartView : View {
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                Image("TextBalloon")
                Spacer()
                Button{} label: {
                    NavigationLink(destination: onBoardingEndView()){
                        Image("NextButton")
                    }
                }
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)

    }
}


struct onBoardingStartView_Previews: PreviewProvider {
    static var previews: some View {
        onBoardingStartView()
    }
}
