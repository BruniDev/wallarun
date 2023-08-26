//
//  ContentView.swift
//  wallarun
//
//  Created by 정현 on 2023/08/25.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    
    @State var gameState: GameState
    
    var body: some View {
        switch gameState {
        case .play:
            NavigationView{
                GeometryReader { geo in
                    let size = geo.size
                    SpriteView(scene: GameScene(size: size, gameState: $gameState))
                        .frame(width: size.width, height: size.height)
                }
                .ignoresSafeArea()
            }
            .navigationBarBackButtonHidden(true)
        case .success:
            SuccessView()
                .navigationBarBackButtonHidden(true)
        case .gameOver:
            GameOverView()
                .navigationBarBackButtonHidden(true)
        }
    }
}

enum GameState {
    case play
    case success
    case gameOver
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameState: .play)
            .previewInterfaceOrientation(.landscapeRight)
    }
}
