//
//  SuccessView.swift
//  wallarun
//
//  Created by 관식 on 2023/08/27.
//

import SwiftUI

struct SuccessView: View {
    var body: some View {
        ZStack {
            Image("SuccessView")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width)
        }
        .ignoresSafeArea()
        .toolbar(.hidden)
    }
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
