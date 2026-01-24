//
//  MangaDetail.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 15/1/26.
//

import SwiftUI

struct MangaDetail: View {
    let manga: Manga
    
    @State private var isInCollection = false
    @State private var showingCollectionSheet = false
    @State private var volumesOwned: Set<Int> = []
    @State private var readingVolume: Int? = nil
    @State private var completeCollection = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Hero Section con imagen y score
                heroSection
                
                // Content Section
                VStack(alignment: .leading, spacing: 24) {
                    // Títulos
                    titleSection
                    
                    // Status y Stats
                    statsSection
                    
                    // Botón de colección
                    collectionButton
                    
                    // Sinopsis
                    synopsisSection
                    
                    // Tags (Genres, Themes, Demographics)
                    tagsSection
                    
                    // Autores
                    authorsSection
                    
                    // Background info
                    if let background = manga.background, !background.isEmpty {
                        backgroundSection
                    }

                    
                    // Botón de MyAnimeList
                    if !manga.cleanURL.isEmpty {
                        malButton                        
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
        }
        .globalBackground()
        .ignoresSafeArea(edges: .top)
        .sheet(isPresented: $showingCollectionSheet) {
            CollectionConfigSheet(
                manga: manga,
                volumesOwned: $volumesOwned,
                readingVolume: $readingVolume,
                completeCollection: $completeCollection,
                isInCollection: $isInCollection
            )
        }
    }
    
    // MARK: - Hero Section
    private var heroSection: some View {
        ZStack(alignment: .bottomTrailing) {
            // Imagen principal con gradiente
            AsyncImage(url: URL(string: manga.cleanMainPicture)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 400)
                        .clipped()
                        .overlay {
                            LinearGradient(
                                colors: [.clear, .black.opacity(0.7)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                case .failure(_):
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 400)
                case .empty:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 400)
                        .overlay {
                            ProgressView()
                        }
                @unknown default:
                    EmptyView()
                }
            }
            
            // Score badge
            scoreBadge
                .padding(16)
        }
    }
    
    private var scoreButton: some View {
        HStack(spacing: 6) {
            Image(systemName: "star.fill")
                .font(.system(size: 14, weight: .semibold))
            Text(String(format: "%.2f", manga.score))
                .font(.system(size: 16, weight: .bold))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background {
            Capsule()
                .fill(.brandPrimary)
        }
    }
    
    private var scoreBadge: some View {
        HStack(spacing: 8) {
            Image(systemName: "star.fill")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.yellow)
            
            Text(String(format: "%.2f", manga.score))
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background {
            Capsule()
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
        }
    }
    
    // MARK: - Title Section
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(manga.title)
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(Color.primary)
            
            if let englishTitle = manga.titleEnglish, englishTitle != manga.title {
                Text(englishTitle)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color.primary.opacity(0.7))
            }
            
            Text(manga.titleJapanese)
                .font(.system(size: 16))
                .foregroundStyle(Color.primary.opacity(0.6))
        }
        .padding(.top, 24)
    }
    
    // MARK: - Stats Section
    private var statsSection: some View {
        HStack(spacing: 16) {
            StatCardManga(
                icon: "book.closed.fill",
                value: manga.volumes != nil ? "\(manga.volumes!)" : "?",
                label: "Volúmenes",
                iconColor: Color.brandPrimary
            )
            
            StatCardManga(
                icon: "list.bullet.rectangle.fill",
                value: "\(manga.chapters)",
                label: "Capítulos"
            )
            
            StatCardManga(
                icon: statusIcon,
                value: statusText,
                label: "Estado",
                iconColor: statusColor
            )
        }
    }
    
    private var statusIcon: String {
        switch manga.status {
        case "currently_publishing": return "arrow.right.circle.fill"
        case "finished": return "checkmark.circle.fill"
        case "on_hiatus": return "pause.circle.fill"
        default: return "circle.fill"
        }
    }
    
    private var statusText: String {
        switch manga.status {
        case "currently_publishing": return "Publicando"
        case "finished": return "Finalizado"
        case "on_hiatus": return "Hiatus"
        default: return manga.status
        }
    }
    
    private var statusColor: Color {
        switch manga.status {
        case "currently_publishing": return .green
        case "finished": return .blue
        case "on_hiatus": return .orange
        default: return .gray
        }
    }
    
    // MARK: - Collection Button
    private var collectionButton: some View {
        Button {
            if isInCollection {
                showingCollectionSheet = true
            } else {
                isInCollection = true
                showingCollectionSheet = true
            }
        } label: {
            HStack {
                Image(systemName: isInCollection ? "checkmark.circle.fill" : "plus.circle.fill")
                    .font(.system(size: 20, weight: .semibold))
                
                Text(isInCollection ? "En mi colección" : "Añadir a colección")
                    .font(.system(size: 17, weight: .semibold))
                
                Spacer()
                
                if isInCollection {
                    collectionSummary
                }
            }
            .foregroundStyle(isInCollection ? .white : .brandPrimary)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isInCollection ? Color.brandPrimary : Color.brandPrimary.opacity(0.15))
            }
        }
    }
    
    private var collectionSummary: some View {
        HStack(spacing: 4) {
            if completeCollection {
                Image(systemName: "star.fill")
                    .font(.system(size: 12))
                Text("Completa")
                    .font(.system(size: 14, weight: .medium))
            } else {
                Text("\(volumesOwned.count)/\(manga.volumes ?? 0)")
                    .font(.system(size: 14, weight: .medium))
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background {
            Capsule()
                .fill(.white.opacity(0.2))
        }
    }
    
    // MARK: - Synopsis Section
    private var synopsisSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sinopsis")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color.primary)
            
            Text(manga.sypnosis ?? "")
                .font(.system(size: 16))
                .foregroundStyle(Color.primary.opacity(0.8))
                .lineSpacing(4)
        }
    }
    
    // MARK: - Tags Section
    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            if !manga.genres.isEmpty {
                TagGroup(title: "Géneros", items: manga.genres.map { $0.genre }, color: .blue)
            }
            
            if !manga.themes.isEmpty {
                TagGroup(title: "Temas", items: manga.themes.map { $0.theme }, color: .purple)
            }
            
            if !manga.demographics.isEmpty {
                TagGroup(title: "Demografía", items: manga.demographics.map { $0.demographic }, color: .orange)
            }
        }
    }
    
    // MARK: - Authors Section
    private var authorsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Autores")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(manga.authors, id: \.id) { author in
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.brandPrimary)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(author.firstName) \(author.lastName)")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color.primary)
                            
                            Text(author.role)
                                .font(.system(size: 14))
                                .foregroundStyle(Color.primary.opacity(0.6))
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.primary.opacity(0.05))
                    }
                }
            }
        }
    }
    
    // MARK: - Background Section
    private var backgroundSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Información adicional")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color.primary)
            
            Text(manga.background ?? "")
                .font(.system(size: 16))
                .foregroundStyle(Color.primary.opacity(0.8))
                .lineSpacing(4)
        }
    }
    
    // MARK: - MAL Button
    private var malButton: some View {
        Link(destination: URL(string: manga.cleanURL)!) {
            HStack {
                Image(systemName: "link.circle.fill")
                    .font(.system(size: 20))
                
                Text("Ver en MyAnimeList")
                    .font(.system(size: 17, weight: .medium))
                
                Spacer()
                
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundStyle(Color.primary)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.primary.opacity(0.1))
            }
        }
    }
}

// MARK: - Supporting Views
struct StatCardManga: View {
    let icon: String
    let value: String
    let label: String
    var iconColor: Color = .brandPrimary
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(iconColor)
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color.primary)
            
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color.primary.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.primary.opacity(0.05))
        }
    }
}

struct TagGroup: View {
    let title: String
    let items: [String]
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color.primary)
            
            FlowLayout(spacing: 8) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(color)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background {
                            Capsule()
                                .fill(color.opacity(0.15))
                        }
                }
            }
        }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(CGPoint(x: x, y: y))
                lineHeight = max(lineHeight, size.height)
                x += size.width + spacing
            }
            
            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}

// MARK: - Collection Config Sheet
struct CollectionConfigSheet: View {
    let manga: Manga
    @Binding var volumesOwned: Set<Int>
    @Binding var readingVolume: Int?
    @Binding var completeCollection: Bool
    @Binding var isInCollection: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Complete Collection Toggle
                    VStack(alignment: .leading, spacing: 12) {
                        Toggle(isOn: $completeCollection) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Colección completa")
                                    .font(.system(size: 17, weight: .semibold))
                                Text("Tienes todos los volúmenes")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color.primary.opacity(0.6))
                            }
                        }
                        .tint(.brandPrimary)
                        .onChange(of: completeCollection) { _, newValue in
                            if newValue, let totalVolumes = manga.volumes {
                                volumesOwned = Set(1...totalVolumes)
                            }
                        }
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.primary.opacity(0.05))
                    }
                    
                    // Volumes Selection
                    if !completeCollection {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Volúmenes que posees")
                                .font(.system(size: 20, weight: .bold))
                            
                            Text("Selecciona los volúmenes que tienes en tu colección")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.primary.opacity(0.6))
                            
                            if let totalVolumes = manga.volumes {
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 12) {
                                    ForEach(1...totalVolumes, id: \.self) { volume in
                                        VolumeButton(
                                            number: volume,
                                            isSelected: volumesOwned.contains(volume)
                                        ) {
                                            if volumesOwned.contains(volume) {
                                                volumesOwned.remove(volume)
                                                if readingVolume == volume {
                                                    readingVolume = nil
                                                }
                                            } else {
                                                volumesOwned.insert(volume)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    // Reading Volume Selection
                    if !volumesOwned.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Volumen que estás leyendo")
                                .font(.system(size: 20, weight: .bold))
                            
                            Text("Opcional: marca cuál estás leyendo actualmente")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.primary.opacity(0.6))
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    // None option
                                    ReadingVolumeButton(
                                        number: nil,
                                        isSelected: readingVolume == nil
                                    ) {
                                        readingVolume = nil
                                    }
                                    
                                    ForEach(Array(volumesOwned).sorted(), id: \.self) { volume in
                                        ReadingVolumeButton(
                                            number: volume,
                                            isSelected: readingVolume == volume
                                        ) {
                                            readingVolume = volume
                                        }
                                    }
                                }
                                .padding(.horizontal, 4)
                            }
                        }
                    }
                    
                    // Remove from collection button
                    Button(role: .destructive) {
                        isInCollection = false
                        volumesOwned.removeAll()
                        readingVolume = nil
                        completeCollection = false
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "trash.fill")
                            Text("Eliminar de la colección")
                        }
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.red)
                        }
                    }
                }
                .padding()
            }
            .globalBackground()
            .navigationTitle("Configurar colección")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        // Aquí podrías crear el objeto Collection y enviarlo a tu API
                        saveCollection()
                        dismiss()
                    }
                    .font(.system(size: 17, weight: .semibold))
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveCollection() {
        // Aquí crearías el objeto Collection y lo enviarías a tu API
        let collection = Collection(
            id: UUID(),
            completeCollection: completeCollection,
            readingVolume: readingVolume,
            volumesOwned: Array(volumesOwned).sorted(),
            manga: manga
        )
        
        // TODO: Enviar a la API
        print("Collection to save:", collection)
    }
}

struct VolumeButton: View {
    let number: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("\(number)")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(isSelected ? .white : .primary)
                .frame(width: 60, height: 60)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? Color.brandPrimary : Color.primary.opacity(0.1))
                }
                .overlay {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color.brandPrimary.opacity(0.5), lineWidth: 2)
                    }
                }
        }
    }
}

struct ReadingVolumeButton: View {
    let number: Int?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: number == nil ? "book.closed" : "book.pages")
                    .font(.system(size: 16, weight: .semibold))
                
                Text(number == nil ? "Ninguno" : "Vol. \(number!)")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundStyle(isSelected ? .white : .primary)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background {
                Capsule()
                    .fill(isSelected ? Color.brandPrimary : Color.primary.opacity(0.1))
            }
        }
    }
}

#Preview(traits: .devEnvironment) {
    MangaDetail(manga: Manga.test)
}
