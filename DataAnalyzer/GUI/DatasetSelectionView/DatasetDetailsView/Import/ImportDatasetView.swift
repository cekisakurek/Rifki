//
//  ImportDatasetView.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 20.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//

import SwiftUI

struct ImportDatasetView: View {
    
    var url: URL?
    
    @StateObject var viewModel = ImportDatasetViewModel()
    
    @Binding var importing: Bool
    
    @State var name: String = ""
    @State var selectedDelimiter: String = ImportDatasetViewModel.Delimiter.comma.name
    @State var hasHeader: Bool = true
    
    @State var delimiters = [ImportDatasetViewModel.Delimiter.comma.name,
                             ImportDatasetViewModel.Delimiter.semicolon.name,
                             ImportDatasetViewModel.Delimiter.tab.name,
                             ImportDatasetViewModel.Delimiter.colon.name,
                             ImportDatasetViewModel.Delimiter.pipe.name]
    
    var body: some View {
        NavigationView {
            Form {
                TextField(NSLocalizedString("Name", comment: ""), text: $name)
                Toggle(isOn: $hasHeader) {
                    Text(NSLocalizedString("Has Header", comment: ""))
                }
                pickerView
            }
            .navigationBarItems(leading: cancelButton, trailing: importButton)
            .navigationBarTitle(NSLocalizedString("Import", comment: ""))
        }
    }
    
    var importButton: some View {
        Button(action: {
            viewModel.save(url: self.url!, name: self.name, delimiter: selectedDelimiter, hasHeader: self.hasHeader) {
            importing = false
            }
        }) {
            Image(systemName: "folder.badge.plus")
        }
    }
    
    var cancelButton: some View {
        Button(action: { importing = false }) {
            Text(NSLocalizedString("Cancel", comment: ""))
        }
    }
    
    var pickerView: some View {
        Picker(NSLocalizedString("Delimiters", comment: ""), selection: $selectedDelimiter) {
            ForEach(delimiters, id: \.self) { item in
                Text(item)
            }
        }
    }
}

//struct ImportDatasetView_Previews: PreviewProvider {
//    @Binding var importing: Bool = false
//    
//    static var previews: some View {
//        let url = URL(string: "https://google.com")!
//        ImportDatasetView(url: url, importing: $importing)
//    }
//}
