//
//  PixuApp.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 29/12/25.
//

import SwiftUI

@main
struct PixuApp: App {
    @State private var authStatus = AuthStatus()
    
//        init(){
//            loadRocketSimConnect()
//        }
//    
//        private func loadRocketSimConnect() {
//            #if DEBUG
//            guard (Bundle(path: "/Applications/RocketSim.app/Contents/Frameworks/RocketSimConnectLinker.nocache.framework")?.load() == true) else {
//                print("Failed to load linker framework")
//                return
//            }
//            print("RocketSim Connect successfully linked")
//            #endif
//        }

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }.environment(authStatus)
    }
}
