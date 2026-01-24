struct CustomSearchInputDTO: Codable {
    let searchContains: Bool
    let searchTitle: String?
    let searchAuthorFirstName: String?
    let searchAuthorLastName: String?
    let searchGenres: [String]?
    let searchThemes: [String]?
    let searchDemographics: [String]?
    
    init(
        searchContains: Bool = true,
        searchTitle: String? = nil,
        searchAuthorFirstName: String? = nil,
        searchAuthorLastName: String? = nil,
        searchGenres: [String]? = nil,
        searchThemes: [String]? = nil,
        searchDemographics: [String]? = nil
    ) {
        self.searchContains = searchContains
        self.searchTitle = searchTitle?.isEmpty == true ? nil : searchTitle
        self.searchAuthorFirstName = searchAuthorFirstName?.isEmpty == true ? nil : searchAuthorFirstName
        self.searchAuthorLastName = searchAuthorLastName?.isEmpty == true ? nil : searchAuthorLastName
        self.searchGenres = searchGenres?.isEmpty == true ? nil : searchGenres
        self.searchThemes = searchThemes?.isEmpty == true ? nil : searchThemes
        self.searchDemographics = searchDemographics?.isEmpty == true ? nil : searchDemographics
    }
}
