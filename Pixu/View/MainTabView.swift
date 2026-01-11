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
    @State var userTabVM: UserTabVM = UserTabVM()
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
                UserTabView(vm: userTabVM)
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
        .searchable(
            text: $searchTabVM.searchText,
            placement: .toolbar,
            prompt: .globalSearch
        )
        .tabBarMinimizeBehavior(.onScrollDown)
        .tabViewStyle(.sidebarAdaptable)
        .defaultAdaptableTabBarPlacement(.tabBar)
        .onAppear(){
            Task{
                authStatus.isLoggedIn = await userTabVM.loginAuth()                
            }
        }
    }
}

#Preview {
    MainTabView(
        homeTabVM: HomeTabVM(apiManager: .test),
        scrollTabVM: ScrollTabVM(apiManager: .test),
        userTabVM: UserTabVM(apiManager: .test),
        searchTabVM: SearchTabVM(apiManager: .test)
    )
}
