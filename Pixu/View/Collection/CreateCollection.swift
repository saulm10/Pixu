//
//  CreateCollection.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 12/1/26.
//

import SwiftUI

struct AddMangaView: View {
    @Environment(\.dismiss) var dismiss
    @State var vm = CreateCollectionVM()
    
    let onSave: (UserCollection) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Manga") {
                    Picker("Selecciona un manga", selection: $vm.selectedMangaId) {
                        Text("Seleccionar...").tag(nil as Int?)
                        ForEach(vm.availableMangas) { manga in
                            Text(manga.title).tag(manga.id as Int?)
                        }
                    }
                }
                
                if vm.selectedMangaId != nil {
                    Section("Colección") {
                        Toggle("¿Tienes la colección completa?", isOn: $vm.completeCollection)
                        
                        if !vm.completeCollection {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Volúmenes que posees")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                TextField("Ej: 1,2,3,4,5", text: $vm.volumesOwnedText)
                                    .keyboardType(.numbersAndPunctuation)
                                
                                Text("Separa los números con comas")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    Section("Lectura") {
                        Stepper(
                            vm.readingVolume != nil ? "Leyendo tomo \(vm.readingVolume!)" : "Sin lectura activa",
                            value: Binding(
                                get: { vm.readingVolume ?? 0 },
                                set: { vm.readingVolume = $0 > 0 ? $0 : nil }
                            ),
                            in: 0...999
                        )
                    }
                }
            }
            .navigationTitle("Añadir Manga")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        if let request = vm.createCollectionRequest() {
                            onSave(request)
                            dismiss()
                            // TODO: Mostrar tu Toast de éxito
                        } else {
                            // TODO: Mostrar tu Toast de error
                        }
                    }
                    .disabled(!vm.isValid)
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                vm.loadAvailableMangas()
            }
        }
    }
}
