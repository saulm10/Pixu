//
//  SearchTabView.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 30/12/25.
//

import SwiftUI

struct SearchTabView: View {
    @Bindable var vm: SearchTabVM

    var body: some View {
        NavigationStack {
            List {

            }
        }
        .searchable(text: $vm.searchText)
        .listStyle(.plain)
        .globalBackground()
    }
}

#Preview {
    SearchTabView(vm: SearchTabVM())
}
