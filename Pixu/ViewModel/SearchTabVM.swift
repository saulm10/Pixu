//
//  SearchTabVM.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 30/12/25.
//

import Combine
import SwiftUI

enum ViewState {
    case loading
    case loaded
    case empty
}

@MainActor @Observable
final class SearchTabVM {
    private let apiManager: APIManager
    
    var state: ViewState = .empty

    var searchText: String = "" {
        didSet {
            // Cancelar la tarea anterior si existe
            searchTask?.cancel()
            
            // Si el texto es muy corto, limpiar resultados
            guard self.searchText.count >= 3 else {
                // Solo limpiar si no hay otros filtros activos
                if selectedGenre.isEmpty && selectedTheme.isEmpty && selectedDemographic.isEmpty {
                    filteredMangas = []
                    state = .empty
                }
                return
            }
            
            // Crear nueva tarea con delay
            searchTask = Task {
                // Esperar 0.5 segundos
                try? await Task.sleep(nanoseconds: 500_000_000)
                
                // Verificar si la tarea no fue cancelada
                guard !Task.isCancelled else {
                    print("⏭️ Búsqueda cancelada (usuario sigue escribiendo)")
                    return
                }
                
                await resetAndReloadFilteredMangas()
            }
        }
    }

    private var searchTask: Task<Void, Never>?
    private var loadTask: Task<Void, Never>?

    var selectedDemographic: [String] = [] {
        didSet {
            // Solo recargar si realmente cambió algo
            guard selectedDemographic != oldValue else { return }
            Task {
                await resetAndReloadFilteredMangas()
            }
        }
    }
    var demographics: [String] = []
    
    var selectedTheme: [String] = [] {
        didSet {
            // Solo recargar si realmente cambió algo
            guard selectedTheme != oldValue else { return }
            Task {
                await resetAndReloadFilteredMangas()
            }
        }
    }
    var themes: [String] = []
    
    var selectedGenre: [String] = [] {
        didSet {
            // Solo recargar si realmente cambió algo
            guard selectedGenre != oldValue else { return }
            Task {
                await resetAndReloadFilteredMangas()
            }
        }
    }
    var genres: [String] = []
    
    var selectedManga: Manga?
    var filteredMangas: [Manga] = []
    private let filteredMangasPS = PageState()

    init(apiManager: APIManager = .live) {
        self.apiManager = apiManager
    }
    
    func loadData() async {
        guard state != .loaded else { return }

        demographics = await apiManager.demographic.getAllDemographics()
        themes = await apiManager.theme.getAllThemes()
        genres = await apiManager.genre.getAllGenres()
        
        state = .empty
    }

    func loadFilteredMangas() async {
        // Cancelar tarea de carga anterior si existe
        loadTask?.cancel()
        
        loadTask = Task {
            // Solo mostrar loading si estamos cargando la primera página
            if filteredMangas.isEmpty {
                state = .loading
            }
            
            guard let page = await filteredMangasPS.nextPage() else {
                print("⚠️ No hay más páginas disponibles")
                return
            }
            
            // Debug: ver qué filtros se están aplicando
            print("🔍 Buscando con:")
            print("  - Texto: '\(searchText)'")
            print("  - Géneros: \(selectedGenre)")
            print("  - Temas: \(selectedTheme)")
            print("  - Demografía: \(selectedDemographic)")
            
            let response = await apiManager.search.advancedSearchMangas(
                input: CustomSearchInputDTO(
                    searchContains: true,
                    searchTitle: searchText.isEmpty ? nil : searchText,
                    searchAuthorFirstName: nil,
                    searchAuthorLastName: nil,
                    searchGenres: selectedGenre.isEmpty ? nil : selectedGenre,
                    searchThemes: selectedTheme.isEmpty ? nil : selectedTheme,
                    searchDemographics: selectedDemographic.isEmpty ? nil : selectedDemographic
                ),
                page: page,
                per: 20
            )
            
            // Verificar si la tarea fue cancelada durante la petición
            guard !Task.isCancelled else {
                print("⏭️ Carga cancelada (nueva búsqueda iniciada)")
                return
            }
            
            print("📊 Resultados obtenidos: \(response.count)")
            
            filteredMangas.append(contentsOf: response)
            
            // Actualizar estado basado en resultados
            if filteredMangas.isEmpty {
                state = .empty
            } else {
                state = .loaded
            }

            let hasMore = response.count == 20
            await filteredMangasPS.finishLoading(hasMore: hasMore)
        }
        
        await loadTask?.value
    }

    func resetAndReloadFilteredMangas() async {
        // NO cancelar searchTask aquí, ya se maneja en el didSet
        
        // Limpiar resultados y resetear paginación
        filteredMangas = []
        await filteredMangasPS.reset()
        
        // Solo buscar si hay criterios de búsqueda
        let hasSearchCriteria = searchText.count >= 3 ||
                                !selectedGenre.isEmpty ||
                                !selectedTheme.isEmpty ||
                                !selectedDemographic.isEmpty
        
        if hasSearchCriteria {
            await loadFilteredMangas()
        } else {
            state = .empty
        }
    }
    
    func clearAllFilters() async {
        // Cancelar búsquedas pendientes
        searchTask?.cancel()
        
        // Resetear todos los filtros
        searchText = ""
        selectedDemographic = []
        selectedTheme = []
        selectedGenre = []
        filteredMangas = []
        
        await filteredMangasPS.reset()
        state = .empty
    }
}
