//
//  SearchablePicker.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 22/1/26.
//

import Foundation
import SwiftUI

struct SearchablePickerView: View {
    let title: String
    let items: [String]
    @Binding var selectedItems: [String]
    let itemLabel: (String) -> String
    
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    var filteredItems: [String] {
        if searchText.isEmpty {
            return items
        }
        return items.filter { itemLabel($0).localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredItems, id: \.self) { item in
                    Button(action: {
                        if selectedItems.contains(item) {
                            selectedItems.removeAll { $0 == item }
                        } else {
                            selectedItems.append(item)
                        }
                    }) {
                        HStack {
                            Text(itemLabel(item))
                                .foregroundColor(.primary)
                            Spacer()
                            if selectedItems.contains(item) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: .globalSearch)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(.globalClose) {
                        dismiss()
                    }
                }
            }
        }
    }
}
