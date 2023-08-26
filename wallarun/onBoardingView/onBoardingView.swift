//
//  StartView.swift
//  wallarun
//
//  Created by 정현 on 2023/08/26.
//

import SwiftUI

private var isClicked : Bool = false

struct onBoardingView : View {
    var body : some View {
        onBoardingStartView(toggle: false)
    }
}

struct onBoardingStartView : View {
    
    @State private var isClicked :Bool
    
    init(toggle : Bool) {
        _isClicked = State(initialValue: toggle)
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                VStack{
                    Spacer()
                    if isClicked == false {
                        Image("FrontPageTextBalloon1")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 136.25)
                    }else {
                        Image("FrontPageTextBalloon2")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 136.25)
                    }
                    Spacer()
                    if isClicked == true{
                        Button{
                        } label: {
                            NavigationLink(destination: GameView(gameState: .play)){
                                Image("GameStartButton")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 55)
                            }
                        }
                    }
                    else {
                        Button{} label: {
                            NavigationLink(destination:  onBoardingStartView(toggle: true)){
                                Image("NextButton")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 55)
                            }
                        }
                    }
                    Spacer()
                }

                Spacer()
            }
            .fullBackground(imageName: "BackGroundImage_all")
        }
        
        .navigationBarBackButtonHidden(true)
    }
    
}



//struct onBoardingStartView_Previews: PreviewProvider {
//    static var previews: some View {
//        onBoardingStartView()
//    }
//}

public extension View {
    func fullBackground(imageName: String) -> some View {
        return background(
            Image(imageName)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
    }
}
