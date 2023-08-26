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
                    }else {
                        Image("FrontPageTextBalloon2")
                    }
                    Spacer()
                    if isClicked == true{
                        Button{
                        } label: {
                            NavigationLink(destination: GameView()){
                                Image("GameStartButton")
                            }
                        }
                    }
                    else {
                        Button{} label: {
                            NavigationLink(destination:  onBoardingStartView(toggle: true)){
                                Image("NextButton")
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
