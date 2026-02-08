import Foundation
import SwiftData

@MainActor
final class DatabaseManager {
    static let shared = DatabaseManager()
    
    let modelContainer: ModelContainer

    var modelContext: ModelContext {
        modelContainer.mainContext
    }

    private init() {
        let schema = Schema([
            UserCollection.self,
            Manga.self,
            Author.self,
            Genre.self,
            Theme.self,
            Demographic.self,
        ])

        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            self.modelContainer = try ModelContainer(
                for: schema,
                configurations: [config],
            )
            
            // Imprimir ruta para debug
            if let url = modelContainer.configurations.first?.url {
                print("🚀 SwiftData DB Path: \(url.path)")
            }
        } catch {
            fatalError("No se pudo inicializar SwiftData: \(error)")
        }
    }
    
    /// Elimina todo el contenido de la base de datos borrando el archivo físico
    /// Elimina todo el contenido de la base de datos
    func deleteAllData() throws {
        // Desactivar autosave para mejor rendimiento
        modelContext.autosaveEnabled = false
        
        // PASO 1: Eliminar UserCollections (tienen FK a Manga)
        var descriptor1 = FetchDescriptor<UserCollection>()
        descriptor1.propertiesToFetch = [] // Forzar carga de todas las propiedades
        let userCollections = try modelContext.fetch(descriptor1)
        
        for collection in userCollections {
            // Acceder a las propiedades para resolver los faults ANTES de borrar
            _ = collection.volumesOwned
            _ = collection.manga
            modelContext.delete(collection)
        }
        
        // Guardar después de cada entidad principal
        try modelContext.save()
        
        // PASO 2: Eliminar Mangas (tienen relaciones M2M)
        var descriptor2 = FetchDescriptor<Manga>()
        descriptor2.propertiesToFetch = []
        let mangas = try modelContext.fetch(descriptor2)
        
        for manga in mangas {
            // Resolver faults accediendo a las propiedades
            _ = manga.title
            _ = manga.authors
            _ = manga.genres
            _ = manga.themes
            _ = manga.demographics
            
            // Limpiar las relaciones M2M manualmente
            manga.authors.removeAll()
            manga.genres.removeAll()
            manga.themes.removeAll()
            manga.demographics.removeAll()
            
            modelContext.delete(manga)
        }
        
        try modelContext.save()
        
        // PASO 3: Eliminar las entidades relacionadas (ya no tienen referencias)
        let authors = try modelContext.fetch(FetchDescriptor<Author>())
        for author in authors {
            modelContext.delete(author)
        }
        
        let genres = try modelContext.fetch(FetchDescriptor<Genre>())
        for genre in genres {
            modelContext.delete(genre)
        }
        
        let themes = try modelContext.fetch(FetchDescriptor<Theme>())
        for theme in themes {
            modelContext.delete(theme)
        }
        
        let demographics = try modelContext.fetch(FetchDescriptor<Demographic>())
        for demographic in demographics {
            modelContext.delete(demographic)
        }
        
        // Guardar todo
        try modelContext.save()
        
        // Reactivar autosave
        modelContext.autosaveEnabled = true
        
        print("✅ Base de datos limpiada correctamente")
    }
    
    /// Versión segura que no lanza errores
    func deleteAllDataSafely() {
        do {
            try deleteAllData()
        } catch {
            print("❌ Error al limpiar la base de datos: \(error)")
        }
    }
}
