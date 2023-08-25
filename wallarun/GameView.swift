//
//  ContentView.swift
//  wallarun
//
//  Created by 정현 on 2023/08/25.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            SpriteView(scene: GameScene(size: size))
                .frame(width: size.width, height: size.height)
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
