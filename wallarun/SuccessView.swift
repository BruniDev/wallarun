//
//  SuccessView.swift
//  wallarun
//
//  Created by 관식 on 2023/08/27.
//

import SwiftUI

struct SuccessView: View {
    
    @State private var isClicked = false
    
    var body: some View {
        if !isClicked {
                ZStack {
                    Image("SuccessView")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width)
                    Button {
                        isClicked.toggle()
                    } label: {
                        Image("NextButton")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 55)

                    }
                    .offset(x: 250, y: 120)
                }
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
        } else {
            endingView()
        }
    }
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
