//
//  Avatar.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 15/1/26.
//

import Components
import SwiftUI

struct CircleAvatar: View {
    var big: Bool = false
    @AppStorage(UserDefaultsK.initial.rawValue) var initial: String = "U"
    @AppStorage(UserDefaultsK.image.rawValue) var image: String = ""

    var body: some View {
        let big: CGFloat = big ? 150 : 32

        Circle()
            .fill(Color.clear)
            .frame(width: big, height: big)
            .overlay {
                if !image.isEmpty {
                    ImageUrlCache(image)
                        .clipShape(Circle())
                } else {
                    Text(initial)
                        .font(.title2)
                        .bold()
                }
            }
            .glassEffect(in: Circle())
    }
}
