//
//  MangaCard.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 15/1/26.
//

import SwiftUI
import Components

struct MangaCard: View {
    let manga: Manga
    let onTap: () -> Void

    init(
        manga: Manga,
        onTap: @escaping () -> Void = {}
    ) {
        self.manga = manga
        self.onTap = onTap
    }

    var body: some View {
        GlassEffectContainer {
            ZStack {
                ImageUrlCache(
                    manga.mainPicture,
                    contentMode: .fill
                )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding()
        .onTapGesture {
            onTap()
        }
    }
}


#Preview {
    MangaCard(manga: .test)
        .frame(width: 300, height: 400)
}
