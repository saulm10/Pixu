//
//  UserView.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 11/1/26.
//

import Components
import SwiftData
import SwiftUI

struct UserView: View {
    @Environment(MainTabVM.self) private var mainTabVM
    @Bindable var vm: UserVM
    @State var userVM: UserAccountVM = UserAccountVM()

    @Namespace private var namespace
    @State private var selectedView = 0

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                Picker("Vista", selection: $selectedView) {
                    Text("Colleción").tag(0)
                    Text("Estadísticas").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                if selectedView == 0 {
                    collectionsListSection
                        .transition(.move(edge: .leading))
                } else {
                    statisticsSection
                        .transition(.move(edge: .trailing))
                }

            }
            .animation(.spring(), value: selectedView)
            .navigationDestination(item: $vm.selectedManga) { manga in
                MangaDetail(
                    vm: MangaDetailVM(manga: manga),
                    namespace: namespace
                )
            }
            .toolbarRole(.editor)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Mi colección")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                        .bold()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        UserAcountView(vm: userVM)
                    } label: {
                        CircleAvatar()
                    }
                    .buttonStyle(.plain)
                }
            }
            .task {
                vm.loadUserCollection()
            }
            .globalBackground()
        }
    }

    private var collectionsListSection: some View {
        ScrollView{
            LazyVStack(spacing: 12) {
                HStack {
                    TextField("Buscar mangas...", text: $vm.searchText)
                        .submitLabel(.search)
                        .roundedTextFieldStyle()

                    if !vm.searchText.isEmpty {
                        Button(action: { vm.searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }

                HStack {
                    Text("Mis Mangas")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Chip(
                        title: "100%",
                        icon: "checkmark.circle.fill",
                        isSelected: vm.completCollections
                    ) {
                        vm.completCollections.toggle()
                    }
                    Chip(
                        title: "Leyendo",
                        icon: "book.fill",
                        isSelected: vm.readingCollection
                    ) {
                        vm.readingCollection.toggle()
                    }
                }

                if vm.filteredCollection.isEmpty {
                    VStack {
                        ContentUnavailableView(
                            "No tienes mangas en tu colección",
                            systemImage: "books.vertical",
                            description: Text(
                                "Añade un manga"
                            ),
                        )
                        Button {
                            mainTabVM.selection = 3
                        } label: {
                            Label(
                                "Añadir mi primer manga",
                                systemImage: "plus.circle.fill"
                            )
                        }
                        .buttonStyle(.primary)
                    }
                }
                ForEach(vm.filteredCollection) { collection in
                    CollectionRowCard(
                        collection: collection,
                        onTap: { vm.selectedManga = collection.manga }
                    )
                }

            }
        }.padding()
    }

    private var statisticsSection: some View {
        ScrollView {
            VStack(spacing: 0) {

                // --- CABECERA ---
                HStack(alignment: .lastTextBaseline) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Tu colección")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)
                            .tracking(1.5)
                        Text("\(vm.totalMangas) mangas")
                            .font(
                                .system(
                                    size: 34,
                                    weight: .black,
                                    design: .rounded
                                )
                            )
                            .foregroundStyle(.primary)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("tomos")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)
                            .tracking(1.5)
                        Text("\(vm.totalVolumesOwned)")
                            .font(
                                .system(
                                    size: 34,
                                    weight: .black,
                                    design: .rounded
                                )
                            )
                            .foregroundStyle(.primary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 24)

                Divider().padding(.horizontal, 20)

                // --- FILA DE ESTADOS ---
                HStack(spacing: 0) {
                    StatPill(
                        value: "\(vm.completeCollectionsCount)",
                        label: "Completos",
                        icon: "checkmark.seal.fill"
                    )
                    Divider().frame(height: 40)
                    StatPill(
                        value: "\(vm.currentlyReadingCount)",
                        label: "Leyendo",
                        icon: "book.fill"
                    )
                    Divider().frame(height: 40)
                    StatPill(
                        value: "\(vm.failingMangasCount)",
                        label: "Suspensos",
                        icon: "xmark.circle.fill"
                    )
                    Divider().frame(height: 40)
                    StatPill(
                        value: "\(vm.uncommonMangasCount)",
                        label: "Raros",
                        icon: "sparkles"
                    )
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 20)

                Divider().padding(.horizontal, 20)

                // --- DISTRIBUCIÓN DE NOTAS ---
                VStack(alignment: .leading, spacing: 14) {
                    Label(
                        "Distribución de notas",
                        systemImage: "chart.bar.fill"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                    .tracking(1)

                    let total = max(
                        vm.mangasLowScoreCount + vm.mangasMidScoreCount
                            + vm.mangasHighScoreCount,
                        1
                    )

                    GeometryReader { geo in
                        HStack(spacing: 3) {
                            ScoreBar(
                                fraction: Double(vm.mangasLowScoreCount)
                                    / Double(total),
                                count: vm.mangasLowScoreCount,
                                label: "≤ 3.5",
                                color: .red,
                                totalWidth: geo.size.width
                            )
                            ScoreBar(
                                fraction: Double(vm.mangasMidScoreCount)
                                    / Double(total),
                                count: vm.mangasMidScoreCount,
                                label: "3.5–7.5",
                                color: .orange,
                                totalWidth: geo.size.width
                            )
                            ScoreBar(
                                fraction: Double(vm.mangasHighScoreCount)
                                    / Double(total),
                                count: vm.mangasHighScoreCount,
                                label: "> 7.5",
                                color: .green,
                                totalWidth: geo.size.width
                            )
                        }
                    }
                    .frame(height: 64)
                }
                .padding(20)

                Divider().padding(.horizontal, 20)

                // --- MEDIA TOP 5 ---
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Label("Media del Top 5", systemImage: "star.fill")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)
                            .tracking(1)
                        Text(String(format: "%.1f", vm.top5Average))
                            .font(
                                .system(
                                    size: 48,
                                    weight: .black,
                                    design: .rounded
                                )
                            )
                            .foregroundStyle(.primary)
                        Text("sobre 10")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    Spacer()

                    // Gauge circular
                    ZStack {
                        Circle()
                            .stroke(Color.secondary.opacity(0.15), lineWidth: 6)
                        Circle()
                            .trim(
                                from: 0,
                                to: min(CGFloat(vm.top5Average) / 10.0, 1.0)
                            )
                            .stroke(
                                Color.primary,
                                style: StrokeStyle(
                                    lineWidth: 6,
                                    lineCap: .round
                                )
                            )
                            .rotationEffect(.degrees(-90))
                            .animation(
                                .easeOut(duration: 0.6),
                                value: vm.top5Average
                            )
                    }
                    .frame(width: 64, height: 64)
                }
                .padding(20)

                Divider().padding(.horizontal, 20)

                // --- MEJOR Y PEOR ---
                if vm.bestManga != nil || vm.worstManga != nil {
                    VStack(spacing: 0) {
                        if let best = vm.bestManga {
                            ExtremeRow(
                                label: "Mejor valorado",
                                manga: best,
                                isTop: true
                            )
                            Divider().padding(.leading, 20)
                        }
                        if let worst = vm.worstManga {
                            ExtremeRow(
                                label: "Peor valorado",
                                manga: worst,
                                isTop: false
                            )
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding(.bottom, 32)
        }
    }

    // MARK: - Subcomponentes

    private struct StatPill: View {
        let value: String
        let label: String
        let icon: String

        var body: some View {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                Text(label)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                    .tracking(0.5)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private struct ScoreBar: View {
        let fraction: Double
        let count: Int
        let label: String
        let color: Color
        let totalWidth: CGFloat

        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                Spacer()
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color.opacity(0.15))
                        .frame(height: 40)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color.opacity(0.75))
                        .frame(
                            height: max(
                                CGFloat(fraction) * 40,
                                fraction > 0 ? 4 : 0
                            )
                        )
                        .animation(.spring(duration: 0.5), value: fraction)
                }
                Text(label)
                    .font(.system(size: 8, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private struct ExtremeRow: View {
        let label: String
        let manga: Manga
        let isTop: Bool

        var body: some View {
            HStack(spacing: 14) {
                Image(
                    systemName: isTop
                        ? "arrow.up.circle.fill" : "arrow.down.circle.fill"
                )
                .font(.title3)
                .foregroundStyle(isTop ? .green : .red)
                .frame(width: 28)

                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                        .tracking(0.8)
                    Text(manga.title)
                        .font(.subheadline.weight(.semibold))
                        .lineLimit(1)
                }

                Spacer()

                if let score = manga.score {
                    Text(String(format: "%.1f", score))
                        .font(
                            .system(size: 20, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(isTop ? .green : .red)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
        }
    }
}

#Preview(traits: .devEnvironment) {
    TabView {
        Tab {
            UserView(vm: UserVM(apiManager: .test))
        }
    }
}
