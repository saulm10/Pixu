//
//  MainTabView.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 30/12/25.
//

import Combine
import SwiftUI

struct MainTabView: View {
    @Environment(AuthStatus.self) private var authStatus

    @State var homeTabVM: HomeTabVM = HomeTabVM()
    @State var scrollTabVM: ScrollTabVM = ScrollTabVM()
    @State var userLoginVM: UserLoginVM = UserLoginVM()
    @State var userVM: UserVM = UserVM()
    @State var searchTabVM: SearchTabVM = SearchTabVM()

    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            Tab(
                .tabHome,
                systemImage: selection == 0 ? "house" : "house.fill",
                value: 0
            ) {
                HomeTabView(vm: homeTabVM)
            }

            Tab(
                .tabScroll,
                systemImage: selection == 1
                    ? "play.rectangle.fill" : "play.rectangle",
                value: 1
            ) {
                ScrollTabView(vm: scrollTabVM)
            }

            Tab(
                .tabUser,
                systemImage: selection == 2
                    ? "person.circle.fill" : "person.circle",
                value: 2
            ) {
                UserTabView(
                    vmLogin: userLoginVM,
                    vmUser: userVM
                )
            }

            Tab(
                .tabSearch,
                systemImage: selection == 3
                    ? "magnifyingglass.circle.fill" : "magnifyingglass",
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
        .task {
            authStatus.isLoggedIn = await userLoginVM.loginAuth()
        }
    }
}

#Preview {
    var authStatus = AuthStatus()

    MainTabView(
        homeTabVM: HomeTabVM(apiManager: .test),
        scrollTabVM: ScrollTabVM(apiManager: .test),
        userLoginVM: UserLoginVM(apiManager: .test),
        userVM: UserVM(apiManager: .test),
        searchTabVM: SearchTabVM(apiManager: .test)
    ).environment(authStatus)

}
