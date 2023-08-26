//
//  wallarunApp.swift
//  wallarun
//
//  Created by 정현 on 2023/08/25.
//

import SwiftUI

@main
struct wallarunApp: App {
    init() {
        Thread.sleep(forTimeInterval: 2)
    }
    var body: some Scene {
        WindowGroup {
            onBoardingView()
        }
    }
}

