//
//  onBoardingTabView.swift
//  wallarun
//
//  Created by 정현 on 2023/08/26.
//

import SwiftUI

struct onBoardingTabView: View {
    var body: some View {
        TabView() {
            onBoardingStartView()
            onBoardingEndView()
        }
        .background(Image(systemName: "BackGroundImage_Default"))
    }
}

struct onBoardingTabView_Previews: PreviewProvider {
    static var previews: some View {
        onBoardingTabView()
    }
}
