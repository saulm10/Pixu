//
//  UserCollectionRepository.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 3/2/26.
//

import Foundation
import SwiftData

extension DatabaseManager {
    func syncCollection(remoteItems: [UserCollection]) {
        do {
            let remoteIDs = remoteItems.map { $0.id }
            
            try modelContext.delete(model: UserCollection.self, where: #Predicate { collection in
                !remoteIDs.contains(collection.id)
            })

            for incoming in remoteItems {
                _ = try resolveCollection(incoming)
            }

            try modelContext.save()
            print("✅ Sincronización completada con éxito.")
            
        } catch {
            print("❌ Error crítico durante la sincronización: \(error.localizedDescription)")
        }
    }
    
    func createCollection(_ collection: UserCollection) throws {
        do {
            // Resolver el manga asociado (asegurar que existe en BD)
            let resolvedManga = try resolveManga(collection.manga)
            
            // Asignar el manga resuelto a la colección
            collection.manga = resolvedManga
            
            // Insertar la nueva colección
            modelContext.insert(collection)
            
            // Guardar cambios
            try modelContext.save()
            
            print("✅ Colección creada exitosamente para manga: \(collection.manga.title)")
            
        } catch {
            print("❌ Error al crear colección: \(error.localizedDescription)")
            throw error
        }
    }
    
    func updateCollection(_ collection: UserCollection) throws {
        do {
            // Buscar la colección existente por ID
            let id = collection.id
            let descriptor = FetchDescriptor<UserCollection>(
                predicate: #Predicate { $0.id == id }
            )
            
            guard let existing = try modelContext.fetch(descriptor).first else {
                print("⚠️ No se encontró la colección con ID: \(id)")
                throw DatabaseError.collectionNotFound
            }
            
            // Actualizar los campos
            existing.completeCollection = collection.completeCollection
            existing.readingVolume = collection.readingVolume
            existing.volumesOwned = collection.volumesOwned
            
            // Resolver y actualizar el manga si es necesario
            let resolvedManga = try resolveManga(collection.manga)
            existing.manga = resolvedManga
            
            // Guardar cambios
            try modelContext.save()
            
            print("✅ Colección actualizada exitosamente para manga: \(existing.manga.title)")
            
        } catch {
            print("❌ Error al actualizar colección: \(error.localizedDescription)")
            throw error
        }
    }
    
    func deleteCollection(_ collection: UserCollection) throws {
        do {
            modelContext.delete(collection)
            try modelContext.save()
            
            print("✅ Colección eliminada exitosamente")
            
        } catch {
            print("❌ Error al eliminar colección: \(error.localizedDescription)")
            throw error
        }
    }
    
    func getCollectionByMangaId(idManga: Int) -> UserCollection? {
        do {
            let descriptor = FetchDescriptor<UserCollection>(
                predicate: #Predicate { collection in
                    collection.manga.id == idManga
                }
            )
            
            return try modelContext.fetch(descriptor).first
        } catch {
            print("❌ Error al buscar colección: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func resolveCollection(_ incoming: UserCollection) throws -> UserCollection {
        let resolvedManga = try resolveManga(incoming.manga)
        
        let id = incoming.id
        let descriptor = FetchDescriptor<UserCollection>(predicate: #Predicate { $0.id == id })
        
        if let existing = try? modelContext.fetch(descriptor).first {
            existing.completeCollection = incoming.completeCollection
            existing.readingVolume = incoming.readingVolume
            existing.volumesOwned = incoming.volumesOwned
            existing.manga = resolvedManga
            
            return existing
        } else {
            incoming.manga = resolvedManga
            modelContext.insert(incoming)
            
            return incoming
        }
    }
}

// MARK: - Database Errors
enum DatabaseError: LocalizedError {
    case collectionNotFound
    case mangaNotFound
    
    var errorDescription: String? {
        switch self {
        case .collectionNotFound:
            return "No se encontró la colección en la base de datos"
        case .mangaNotFound:
            return "No se encontró el manga en la base de datos"
        }
    }
}
