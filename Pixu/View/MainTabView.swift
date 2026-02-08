//
//  MainTabView.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 30/12/25.
//

import Combine
import SwiftUI
import ToastService

struct MainTabView: View {
    @Environment(AuthStatus.self) private var authStatus

    @State var vm: MainTabVM = MainTabVM()
    @State var homeTabVM: HomeTabVM = HomeTabVM()
    @State var scrollTabVM: ScrollTabVM = ScrollTabVM()
    @State var userLoginVM: UserLoginVM = UserLoginVM()
    @State var userVM: UserVM = UserVM()
    @State var searchTabVM: SearchTabVM = SearchTabVM()

    @State private var showSplash = true

    var body: some View {
        TabView(selection: $vm.selection) {
            Tab(
                .tabHome,
                systemImage: "house",
                value: 0
            ) {
                HomeTabView(vm: homeTabVM)
            }
            Tab(
                .tabScroll,
                systemImage: "play.rectangle",
                value: 1
            ) {
                ScrollTabView(vm: scrollTabVM)
            }
            Tab(
                .tabUser,
                systemImage: "person",
                value: 2
            ) {
                UserTabView(
                    vmLogin: userLoginVM,
                    vmUser: userVM
                )
            }
            Tab(
                .tabSearch,
                systemImage: "magnifyingglass",
                value: 3,
                role: .search
            ) {
                SearchTabView(vm: searchTabVM)
            }
        }
        .tint(Color.brandPrimary)
        .tabBarMinimizeBehavior(.onScrollDown)
        .tabViewStyle(.sidebarAdaptable)
        .defaultAdaptableTabBarPlacement(.tabBar)
        .environment(vm)
        .overlay {
            if showSplash {
                SplashAnimationView()
                    .transition(.opacity)
            }
        }
        .task {
            try? await Task.sleep(for: .milliseconds(1500))
            withAnimation {
                showSplash = false
            }
        }
        .toastOverlay()
    }
}

#Preview(traits: .devEnvironment) {
    MainTabView(
        homeTabVM: HomeTabVM(apiManager: .test),
        scrollTabVM: ScrollTabVM(apiManager: .test),
        userLoginVM: UserLoginVM(apiManager: .test),
        userVM: UserVM(apiManager: .test),
        searchTabVM: SearchTabVM(apiManager: .test)
    )
}
