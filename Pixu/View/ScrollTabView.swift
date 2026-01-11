//
//  ScrollView.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 30/12/25.
//

import SwiftUI

struct ScrollTabView: View {
    @Bindable var vm: ScrollTabVM
    
    var body: some View {
        Text(verbatim: "Scoll tab view")
            .globalBackground()
    }
}

#Preview {
    ScrollTabView(vm: ScrollTabVM())
}

