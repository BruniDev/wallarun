//
//  FailView.swift
//  wallarun
//
//  Created by 관식 on 2023/08/27.
//

import SwiftUI

struct GameOverView: View {
    var body: some View {
        ZStack {
            Image("GameOverView")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width)
        }
        .ignoresSafeArea()
        .toolbar(.hidden)
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView()
    }
}
