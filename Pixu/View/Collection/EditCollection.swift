//
//  EditColection.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 12/1/26.
//

import SwiftUI

struct EditMangaView: View {
    @Environment(\.dismiss) private var dismiss
    @State var vm: EditColectionVM

    var body: some View {
        NavigationStack {
            Form {
                Section("Manga") {
                    HStack {
                        AsyncImage(
                            url: URL(string: vm.collection.manga.mainPicture)
                        ) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.3))
                                .overlay(
                                    Image(systemName: "book.fill")
                                        .foregroundColor(.gray)
                                )
                        }
                        .frame(width: 40, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                        VStack(alignment: .leading) {
                            Text(vm.collection.manga.title)
                                .font(.headline)
                            if let volumes = vm.collection.manga.volumes {
                                Text("\(volumes) volúmenes")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }

                Section("Colección") {
                    Toggle(
                        "¿Tienes la colección completa?",
                        isOn: $vm.completeCollection
                    )

                    if !vm.completeCollection {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Volúmenes que posees")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            TextField(
                                "Ej: 1,2,3,4,5",
                                text: $vm.volumesOwnedText
                            )
                            .keyboardType(.numbersAndPunctuation)

                            Text("Separa los números con comas")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                Section("Lectura") {
                    Stepper(
                        vm.readingVolume != nil
                            ? "Leyendo tomo \(vm.readingVolume!)"
                            : "Sin lectura activa",
                        value: Binding(
                            get: { vm.readingVolume ?? 0 },
                            set: { vm.readingVolume = $0 > 0 ? $0 : nil }
                        ),
                        in: 0...999
                    )
                }

                Section {
                    Button("Eliminar de colección", role: .destructive) {
                        vm.showDeleteConfirmation = true
                    }
                }
            }
            .navigationTitle("Editar Manga")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        if let request = vm.updateCollectionRequest() {
                            //onSave(request)
                            dismiss()
                            // TODO: Mostrar tu Toast de éxito
                        }
                    }
                    .fontWeight(.semibold)
                }
            }
            .confirmationDialog(
                "¿Eliminar este manga de tu colección?",
                isPresented: $vm.showDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Eliminar", role: .destructive) {
                    vm.deleteCollection()
                    dismiss()
                    // TODO: Mostrar tu Toast de éxito al eliminar
                }
                Button("Cancelar", role: .cancel) {}
            }
        }
    }
}
