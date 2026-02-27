//
//  MangaDetail.swift
//  Pixu
//
//  Rediseño — Estilo editorial, tipografía rounded, dividers, sin glass cards
//

import CommonsLib
import SwiftData
import SwiftUI

struct MangaDetail: View {
    @State var vm: MangaDetailVM

    @State private var showingCollectionSheet = false
    @State private var scoreAnimated: Double = 0

    @AppStorage(UserDefaultsK.image.rawValue) var storedImage: String = ""
    @AppStorage(UserDefaultsK.showAdultContent.rawValue) private
        var showAdultContent: Bool = false

    let namespace: Namespace.ID

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                heroSection

                VStack(spacing: 0) {
                    titleBlock
                    Divider().padding(.horizontal, 20)
                    statsRow
                    Divider().padding(.horizontal, 20)
                    collectionBlock
                    Divider().padding(.horizontal, 20)
                    synopsisBlock
                    Divider().padding(.horizontal, 20)
                    publicationBlock
                    Divider().padding(.horizontal, 20)

                    if !vm.manga.genres.isEmpty || !vm.manga.themes.isEmpty
                        || !vm.manga.demographics.isEmpty
                    {
                        tagsBlock
                        Divider().padding(.horizontal, 20)
                    }

                    if !vm.manga.authors.isEmpty {
                        authorsBlock
                        Divider().padding(.horizontal, 20)
                    }

                    if !vm.filteredMangas.isEmpty {
                        relatedBlock
                        Divider().padding(.horizontal, 20)
                    }

                    if let bg = vm.manga.background, !bg.isEmpty {
                        backgroundBlock(bg)
                        Divider().padding(.horizontal, 20)
                    }

                    if !vm.manga.url.isEmpty {
                        malBlock
                    }
                }
                .padding(.bottom, 40)
            }.globalBackground()
        }
        .navigationDestination(item: $vm.selectedManga) { manga in
            MangaDetail(vm: MangaDetailVM(manga: manga), namespace: namespace)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        storedImage = vm.manga.mainPicture
                    } label: {
                        Label(
                            .mangadeetailToolUsericonset,
                            systemImage: "person.crop.circle"
                        )
                    }.tint(.primary)
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .sheet(isPresented: $showingCollectionSheet) {
            CollectionConfigSheet(
                collection: vm.collection,
                manga: vm.manga,
                createCollection: vm.createCollection,
                updateCollection: vm.updateCollection,
                deleteCollection: vm.deleteCollection
            )
        }
        .task {
            await vm.searchCollection()
            await vm.loadFilteredMangas()
            withAnimation(.easeInOut(duration: 1.2).delay(0.4)) {
                scoreAnimated = vm.manga.score ?? 0
            }
        }
    }

    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            ImageUrlCache(
                vm.manga.mainPicture,
                blurred: !showAdultContent && vm.manga.isAdultContent
            )
            .frame(height: 380)
            .clipped()
            .overlay {
                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0.3),
                        .init(color: .black.opacity(0.75), location: 1),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .navigationTransition(.zoom(sourceID: vm.manga.id, in: namespace))

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    MangaScoreGauge(score: scoreAnimated)
                        .frame(width: 80, height: 80)
                        .padding(16)
                }
            }

            VStack(alignment: .leading) {
                Spacer()
                HStack(spacing: 6) {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 8, height: 8)
                    Text(statusShort)
                        .foregroundStyle(.white)
                        .font(.caption)
                        .bold()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.ultraThinMaterial, in: Capsule())
                .padding(16)
            }
        }
        .frame(height: 380)
    }

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(vm.manga.title)
                .font(.largeTitle)
                .bold()

            if let eng = vm.manga.titleEnglish, eng != vm.manga.title {
                Text(eng)
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }

            if let jp = vm.manga.titleJapanese {
                Text(jp)
                    .foregroundStyle(.tertiary)
                    .font(.subheadline)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }

    private var statsRow: some View {
        HStack(spacing: 0) {
            DetailStatPill(
                value: vm.manga.volumes.map { "\($0)" } ?? "—",
                label: .mangadetailVolumes,
                icon: "book.closed.fill"
            )
            Divider().frame(height: 40)
            DetailStatPill(
                value: vm.manga.chapters.map { "\($0)" } ?? "—",
                label: .mangadetailChapters,
                icon: "list.bullet.rectangle.fill"
            )
            Divider().frame(height: 40)
            DetailStatPill(
                value: vm.manga.score.map { score in
                    "\(score, specifier: "%.2f")"
                } ?? "—",
                label: .mangadetailScore,
                icon: "star.fill"
            )
            Divider().frame(height: 40)
            DetailStatPill(
                value: statusShort,
                label: .mangadetailState,
                icon: statusIcon
            )
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
    }

    private var collectionBlock: some View {
        Button {
            showingCollectionSheet = true
        } label: {
            HStack(spacing: 14) {
                Image(
                    systemName: vm.isInCollection
                        ? "checkmark.circle.fill" : "plus.circle.fill"
                )
                .foregroundStyle(vm.isInCollection ? .green : .primary)
                .font(.title)

                VStack(alignment: .leading, spacing: 3) {
                    Text(
                        vm.isInCollection
                            ? "mangadetail_inCollection"
                            : "mangadetail_addtocollection"
                    )
                    .font(.footnote)

                    if let col = vm.collection {
                        Text(
                            .mangadetailVolumenes(
                                col.volumesOwned.count,
                                vm.manga.volumes ?? 0
                            )
                        )
                        .foregroundStyle(.secondary)
                        .font(.footnote)

                    } else {
                        Text(.mangadetailManagecollection)
                            .foregroundStyle(.secondary)
                            .font(.footnote)

                    }
                }

                Spacer()

                if let col = vm.collection, !col.completeCollection,
                    let total = vm.manga.volumes, total > 0
                {
                    CollectionProgressRing(
                        progress: Double(col.volumesOwned.count)
                            / Double(total),
                        color: .primary
                    )
                    .frame(width: 36, height: 36)
                }

                Image(systemName: "chevron.right")
                    .foregroundStyle(.tertiary)
                    .font(.footnote)

            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
        }
        .requiresAuthentication()
    }

    private var synopsisBlock: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionLabel(title: .mangadetailSynopsis, icon: "text.alignleft")
            Text(vm.manga.sypnosis ?? "mangadetail_nosynopsis")
                .font(.callout)
                .foregroundStyle(.primary.opacity(0.85))
                .lineSpacing(5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }

    private var publicationBlock: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionLabel(title: .mangadetailPublication, icon: "calendar")

            HStack(spacing: 0) {
                VStack(spacing: 3) {
                    Image(systemName: "play.circle.fill")
                        .font(.title3)
                    Text(.mangadetailStart)
                        .foregroundStyle(.secondary)
                        .font(.caption2)
                        .textCase(.uppercase)
                        .tracking(0.8)
                    Text(formattedDate(vm.manga.startDate))
                        .font(.headline)
                        .bold()
                }
                .frame(maxWidth: .infinity)

                Rectangle()
                    .frame(height: 2)
                    .frame(maxWidth: .infinity)

                VStack(spacing: 3) {
                    Image(
                        systemName: vm.manga.status == "finished"
                            ? "checkmark.circle.fill" : "ellipsis.circle.fill"
                    )
                    .font(.title3)
                    .foregroundStyle(statusColor)
                    Text(
                        vm.manga.status == "finished"
                            ? "mangadetail_state_end" : "mangadetail_state"
                    )
                    .foregroundStyle(.secondary)
                    .font(.caption2)
                    .textCase(.uppercase)
                    .tracking(0.8)
                    Text(
                        vm.manga.status == "finished"
                            ? LocalizedStringResource(
                                stringLiteral: formattedDate(vm.manga.endDate)
                            ) : statusShort
                    )
                    .font(.headline)
                    .bold()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }

    private var tagsBlock: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionLabel(title: .mangadetailClassification, icon: "tag.fill")

            if !vm.manga.genres.isEmpty {
                ChipGroup(
                    title: .mangadetailClassificationGenres,
                    items: vm.manga.genres.map {
                        $0.genre
                    },
                    color: .primary
                )
            }
            if !vm.manga.themes.isEmpty {
                ChipGroup(
                    title: .mangadetailClassificationThemes,
                    items: vm.manga.themes.map {
                        $0.theme
                    },
                    color: .primary
                )
            }
            if !vm.manga.demographics.isEmpty {
                ChipGroup(
                    title: .mangadetailClassificationDemography,
                    items: vm.manga.demographics.map {
                        $0.demographic
                    },
                    color: .primary
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }

    private var authorsBlock: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionLabel(title: .mangadetailAuthors, icon: "person.2.fill")

            VStack(spacing: 0) {
                ForEach(Array(vm.manga.authors.enumerated()), id: \.element.id)
                { index, author in
                    if index > 0 { Divider().padding(.leading, 54) }
                    AuthorDetailRow(author: author)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }

    private var relatedBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionLabel(
                title: .mangadetailAlsolike,
                icon: "books.vertical.fill"
            )
            .padding(.horizontal, 20)

            horizontalScroll(vm.filteredMangas, skeleton: { MangaCard.loading })
            { manga in
                MangaCard(manga: manga, namespace: namespace) {
                    vm.selectedManga = manga
                }
                .onAppear {
                    if manga.id == vm.filteredMangas.last?.id {
                        Task { await vm.loadFilteredMangas() }
                    }
                }
            }
        }
        .padding(.vertical, 20)
    }

    private func backgroundBlock(_ text: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionLabel(
                title: .mangadetailAdditionalinfo,
                icon: "info.circle.fill"
            )
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.primary.opacity(0.8))
                .lineSpacing(5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }

    private var malBlock: some View {
        Link(destination: URL(string: vm.manga.url)!) {
            HStack(spacing: 12) {
                Image(systemName: "safari.fill")
                    .foregroundStyle(.blue)
                    .font(.title2)
                Text(.mangadetailShowinMyAnime)
                    .font(.headline)
                Spacer()
                Image(systemName: "arrow.up.right")
                    .foregroundStyle(.secondary)
                    .font(.footnote)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
        }
    }

    private var statusShort: LocalizedStringResource {
        switch vm.manga.status {
        case "currently_publishing": return .mangadetailStateActive
        case "finished": return .mangadetailStateEnd
        case "on_hiatus": return .mangadetailStatePause
        default: return "—"
        }
    }

    private var statusIcon: String {
        switch vm.manga.status {
        case "currently_publishing": return "arrow.right.circle.fill"
        case "finished": return "checkmark.circle.fill"
        case "on_hiatus": return "pause.circle.fill"
        default: return "circle.fill"
        }
    }

    private var statusColor: Color {
        switch vm.manga.status {
        case "currently_publishing": return .green
        case "finished": return .green
        case "on_hiatus": return .orange
        default: return .gray
        }
    }

    private func formattedDate(_ raw: String?) -> String {
        guard let raw else { return "—" }
        let input = String(raw.prefix(10))
        let pairs: [(String, String)] = [
            ("yyyy-MM-dd", "MMM yyyy"),
            ("yyyy-MM", "MMM yyyy"),
            ("yyyy", "yyyy"),
        ]
        for (inFmt, outFmt) in pairs {
            let parser = DateFormatter()
            parser.dateFormat = inFmt
            if let date = parser.date(from: input) {
                let out = DateFormatter()
                out.locale = Locale(identifier: "es_ES")
                out.dateFormat = outFmt
                return out.string(from: date).capitalized
            }
        }
        return raw
    }
}

private struct MangaScoreGauge: View {
    let score: Double
    private var progress: Double { score / 10.0 }

    private var gaugeColor: Color {
        switch score {
        case 8...: return .yellow
        case 6..<8: return .green
        case 4..<6: return .orange
        default: return score == 0 ? .gray : .red
        }
    }

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(
                    Color.white.opacity(0.15),
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .rotationEffect(.degrees(135))

            Circle()
                .trim(from: 0, to: progress * 0.75)
                .stroke(
                    gaugeColor,
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .rotationEffect(.degrees(135))

            VStack(spacing: 0) {
                Text(
                    verbatim: score > 0 ? String(format: "%.1f", score) : "N/A"
                )
                .foregroundStyle(.white)
                .font(.title2)
                .bold()
                Text(.mangadetailScore)
                    .foregroundStyle(.white.opacity(0.6))
                    .font(.caption2)
                    .bold()
                    .kerning(1.2)
            }
        }
        .background(Circle().fill(.ultraThinMaterial))
    }
}

private struct DetailStatPill: View {
    let value: LocalizedStringResource
    let label: LocalizedStringResource
    let icon: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title3)
                .bold()
                .minimumScaleFactor(0.6)
                .lineLimit(1)
            Text(label)
                .foregroundStyle(.secondary)
                .font(.caption2)
                .textCase(.uppercase)
                .tracking(0.5)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct SectionLabel: View {
    let title: LocalizedStringResource
    let icon: String

    var body: some View {
        Label(title, systemImage: icon)
            .font(.caption)
            .foregroundStyle(.secondary)
            .textCase(.uppercase)
            .tracking(1)
    }
}

private struct ChipGroup: View {
    let title: LocalizedStringResource
    let items: [String]
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundStyle(.secondary)
                .font(.caption)

            FlowLayout(spacing: 8) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .font(.footnote)
                        .foregroundStyle(color)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(color.opacity(0.12), in: Capsule())
                        .overlay(
                            Capsule().strokeBorder(
                                color.opacity(0.25),
                                lineWidth: 1
                            )
                        )
                }
            }
        }
    }
}

private struct AuthorDetailRow: View {
    let author: Author

    var initials: String {
        [author.firstName.prefix(1), author.lastName.prefix(1)].joined()
    }

    var avatarColor: Color {
        let colors: [Color] = [
            .blue, .purple, .pink, .orange, .teal, .green, .indigo,
        ]
        return colors[abs(author.firstName.hashValue) % colors.count]
    }

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(avatarColor.opacity(0.18))
                    .frame(width: 42, height: 42)
                Text(initials)
                    .foregroundStyle(avatarColor)
                    .font(.subheadline)
                    .bold()

            }

            VStack(alignment: .leading, spacing: 2) {
                Text(verbatim: "\(author.firstName) \(author.lastName)")
                    .font(.subheadline)
                    .bold()
                Text(author.role)
                    .foregroundStyle(.secondary)
                    .font(.footnote)
            }

            Spacer()
        }
        .padding(.vertical, 8)
    }
}

private struct CollectionProgressRing: View {
    let progress: Double
    let color: Color

    var body: some View {
        ZStack {
            Circle().stroke(color.opacity(0.2), lineWidth: 4)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            Text(verbatim: "\(Int(progress * 100))%")
                .foregroundStyle(color)
                .font(.caption2)
                .bold()
        }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        ).size
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(
                at: CGPoint(
                    x: bounds.minX + result.positions[index].x,
                    y: bounds.minY + result.positions[index].y
                ),
                proposal: .unspecified
            )
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

struct CollectionConfigSheet: View {
    let manga: Manga
    @State private var collection: UserCollection
    @State private var isNew: Bool
    let createCollection: (UserCollection) async -> Void
    let updateCollection: (UserCollection) async -> Void
    let deleteCollection: (UserCollection) async -> Void

    @Environment(\.dismiss) private var dismiss

    init(
        collection: UserCollection? = nil,
        manga: Manga,
        createCollection: @escaping (UserCollection) async -> Void,
        updateCollection: @escaping (UserCollection) async -> Void,
        deleteCollection: @escaping (UserCollection) async -> Void
    ) {
        self.manga = manga
        self.createCollection = createCollection
        self.updateCollection = updateCollection
        self.deleteCollection = deleteCollection

        if let collection = collection {
            self._collection = State(initialValue: collection)
            self._isNew = State(initialValue: false)
        } else {
            self._collection = State(
                initialValue: UserCollection(
                    id: UUID(),
                    completeCollection: false,
                    readingVolume: nil,
                    volumesOwned: [],
                    manga: manga
                )
            )
            self._isNew = State(initialValue: true)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 24) {
                    completeCollectionSection
                    if !collection.completeCollection {
                        volumesSelectionSection
                    }
                    if !collection.volumesOwned.isEmpty { readingVolumeSection }
                    if !isNew { deleteCorrectionButton }
                }
                .padding()
            }
            .globalBackground()
            .navigationTitle(.mangaCollectioTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(.globalSave) {
                        saveCollection()
                        dismiss()
                    }
                    .font(.headline)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button(.globalClose) {
                        dismiss()
                    }
                }
            }
        }
    }

    private var completeCollectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Toggle(isOn: $collection.completeCollection) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(.mangacollectionCollectionfull)
                        .font(.headline)
                    Text(.mangacollectionAllvolumes)
                        .foregroundStyle(Color.primary.opacity(0.6))
                        .font(.subheadline)
                }
            }
            .tint(.brandPrimary)
            .onChange(of: collection.completeCollection) { _, newValue in
                if newValue, let totalVolumes = manga.volumes {
                    collection.volumesOwned = Array(1...totalVolumes)
                }
            }
        }
        .padding()
        .background(
            Color.primary.opacity(0.05),
            in: RoundedRectangle(cornerRadius: 12)
        )
    }

    private var volumesSelectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(.mangacollectionVolumesown)
                .font(.title3)
                .bold()
            Text(.mangacollectionVolumesuhave)
                .foregroundStyle(Color.primary.opacity(0.6))
                .font(.headline)

            if let totalVolumes = manga.volumes {
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 60))],
                    spacing: 12
                ) {
                    ForEach(1...totalVolumes, id: \.self) { volume in
                        VolumeButton(
                            number: volume,
                            isSelected: collection.volumesOwned.contains(volume)
                        ) {
                            toggleVolume(volume)
                        }
                    }
                }
            }
        }
    }

    private var readingVolumeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(.mangacollectionCurrentreading)
                .font(.title3)
                .bold()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ReadingVolumeButton(
                        number: nil,
                        isSelected: collection.readingVolume == nil
                    ) {
                        collection.readingVolume = nil
                    }
                    ForEach(Array(collection.volumesOwned).sorted(), id: \.self)
                    { volume in
                        ReadingVolumeButton(
                            number: volume,
                            isSelected: collection.readingVolume == volume
                        ) {
                            collection.readingVolume = volume
                        }
                    }
                }
                .padding(.horizontal, 4)
            }

            Spacer()
        }
    }
    
    private var deleteCorrectionButton: some View {
        Button {
            let col = collection
            Task { await deleteCollection(col) }
            dismiss()
        } label: {
            Label(.mangacollectionDelete, systemImage: "trash")
                .foregroundStyle(.white)
                .font(.subheadline)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(
                    .red.opacity(0.85),
                    in: RoundedRectangle(cornerRadius: 14)
                )
        }
    }

    private func saveCollection() {
        let col = collection
        Task {
            if isNew {
                await createCollection(col)
            } else {
                await updateCollection(col)
            }
        }
    }

    private func toggleVolume(_ volume: Int) {
        if let index = collection.volumesOwned.firstIndex(of: volume) {
            collection.volumesOwned.remove(at: index)
            if collection.readingVolume == volume {
                collection.readingVolume = nil
            }
        } else {
            collection.volumesOwned.append(volume)
        }
    }

    struct VolumeButton: View {
        let number: Int
        let isSelected: Bool
        let action: () -> Void
        var body: some View {
            Button(action: action) {
                Text("\(number)")
                    .foregroundStyle(isSelected ? .white : .primary)
                    .font(.callout)
                    .frame(width: 60, height: 60)
                    .background(
                        isSelected
                            ? Color.brandPrimary : Color.primary.opacity(0.1),
                        in: RoundedRectangle(cornerRadius: 10)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10).strokeBorder(
                            isSelected
                                ? Color.brandPrimary.opacity(0.5) : .clear,
                            lineWidth: 2
                        )
                    )
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
                    Image(
                        systemName: number == nil ? "book.closed" : "book.pages"
                    )
                    .font(.callout)
                    Text(.globalVol(numVolumens: number ?? 0))
                        .font(.callout)
                }
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    isSelected
                        ? Color.brandPrimary : Color.primary.opacity(0.1),
                    in: Capsule()
                )
            }
        }
    }
}

#Preview(traits: .devEnvironment) {
    @Previewable @Namespace var namespace
    NavigationStack {
        MangaDetail(
            vm: MangaDetailVM(manga: Manga.testList[3]),
            namespace: namespace
        )
    }
}
