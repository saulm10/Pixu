//
//  HomeView.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 30/12/25.
//

import SwiftUI

struct HomeTabView: View {
    @Bindable var vm: HomeTabVM
    
    var body: some View {
        Text(verbatim: "Home tab view")
            .globalBackground()
    }
}

#Preview {
    HomeTabView(vm: HomeTabVM())
}

