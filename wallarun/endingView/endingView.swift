//
//  endingView.swift
//  wallarun
//
//  Created by 정현 on 2023/08/26.
//

import SwiftUI

private var isClicked : Bool = false

struct endingView: View {
    var body: some View {
        endingStartView(toggle: false)
    }
}


struct endingStartView : View {
    
    @State private var isClicked : Bool
    
    init(toggle : Bool) {
        _isClicked = State(initialValue: toggle)
    }
    
    var body : some View {
        NavigationView{
            ZStack{
                VStack{
                    Spacer()
                    if isClicked == false {
                        Image("EndPageTextBalloon1")
                        Button {} label: {
                            NavigationLink(destination: endingStartView(toggle: true)) {
                                Image("NextButton")
                                    .offset(x:250,y:-50)
                            }
                        }
                        
                    } else {
                        Image("EndPageTextBalloon2")
                        Button {} label: {
                            NavigationLink(destination: GameView()) {
                                Image("RetryButton")
                                    .offset(x:250,y:-50)
                            }
                            
                        }
                    }
                }
            }
        }
    }
}

struct endingView_Previews: PreviewProvider {
    static var previews: some View {
        endingView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
