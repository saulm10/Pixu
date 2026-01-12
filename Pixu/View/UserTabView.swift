//
//  UserTabView.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 30/12/25.
//

import SwiftUI

struct UserTabView: View {
    @Environment(AuthStatus.self) private var authStatus

    @Bindable var vmLogin: UserLoginVM
    @Bindable var vmUser: UserVM

    var body: some View {
        Group {
            if authStatus.isLoggedIn {
                UserView(vm: vmUser)
            } else {
                UserLoginView(vm: vmLogin)
            }
        }
    }
}

#Preview {
    UserTabView(
        vmLogin: UserLoginVM(apiManager: .test),
        vmUser: UserVM(apiManager: .test)
    )
}
