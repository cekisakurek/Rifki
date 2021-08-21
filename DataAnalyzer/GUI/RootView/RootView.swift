//
//  RootView.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 19.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//

import SwiftUI

struct RootView: View {
    
    @StateObject var viewModel = RootViewModel()
    @State var importing = false
    
    var body: some View {
        NavigationView {
            DatasetSelectionView()
            DatasetDetailsView(objectID: nil)
        }.onOpenURL { (url) in
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.scheme = "file"
            viewModel.url = components!.url
            importing = true
        }
        .sheet(isPresented: $importing) {
            if let url = viewModel.url {
                ImportDatasetView(url: url, importing: $importing)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
