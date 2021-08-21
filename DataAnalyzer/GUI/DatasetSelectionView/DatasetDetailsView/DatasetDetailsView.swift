//
//  DatasetDetailsView.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 19.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//

import SwiftUI

struct DatasetDetailsView: View {
    
    var objectID: NSManagedObjectID?
    
    @State private var selection = DatasetDetailsViewSegments.rawData.rawValue
    
    var body: some View {
        VStack {
            if let objectID = objectID {
                TabView(selection: $selection) {
                    
                    RawAnalysisView(objectID: objectID)
                        .tabItem { Text(NSLocalizedString("Raw Data", comment: "")) }
                        .tag(DatasetDetailsViewSegments.rawData.rawValue)
                    
                    ColumnAnalysisView(objectID: objectID)
                        .tabItem { Text(NSLocalizedString("Analysis", comment: "")) }
                        .tag(DatasetDetailsViewSegments.columnAnalysis.rawValue)
                    HeatmapView(objectID: objectID)
                        .tabItem { Text(NSLocalizedString("Heatmap", comment: ""))}
                        .tag(DatasetDetailsViewSegments.heatmap.rawValue)
                    PlaygroundView(objectID: objectID)
                        .tabItem { Text(NSLocalizedString("Playground", comment: "")) }
                        .tag(DatasetDetailsViewSegments.playground.rawValue)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .configureNavigationBar {
            $0.navigationBar.isTranslucent = false
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                DatasetDetailsSegmentPickerView(selection: $selection)
            }
        }
    }
    
    enum DatasetDetailsViewSegments: Int {
        case rawData
        case columnAnalysis
        case heatmap
        case playground
    }
    
    struct DatasetDetailsSegmentPickerView: View {
        
        @Binding var selection: Int
        
        var body: some View {
            Picker(NSLocalizedString("Select", comment: ""), selection: $selection, content: {
                Text(NSLocalizedString("Raw Data", comment: "")).tag(DatasetDetailsViewSegments.rawData.rawValue)
                Text(NSLocalizedString("Analysis", comment: "")).tag(DatasetDetailsViewSegments.columnAnalysis.rawValue)
                Text(NSLocalizedString("Heatmap", comment: "")).tag(DatasetDetailsViewSegments.heatmap.rawValue)
                Text(NSLocalizedString("Playground", comment: "")).tag(DatasetDetailsViewSegments.playground.rawValue)
            })
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

//struct DatasetDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DatasetDetailsView(objectID: nil)
//    }
//}


extension View {
    func configureNavigationBar(configure: @escaping (UINavigationController) -> Void) -> some View {
        modifier(NavigationConfigurationViewModifier(configure: configure))
    }
}

struct NavigationConfigurationViewModifier: ViewModifier {
    let configure: (UINavigationController) -> Void
    
    func body(content: Content) -> some View {
        content.background(NavigationConfigurator(configure: configure))
    }
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    let configure: (UINavigationController) -> Void
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> NavigationConfigurationViewController {
        NavigationConfigurationViewController(configure: configure)
    }
    
    func updateUIViewController(_ uiViewController: NavigationConfigurationViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        
    }
}

final class NavigationConfigurationViewController: UIViewController {
    let configure: (UINavigationController) -> Void
    
    init(configure: @escaping (UINavigationController) -> Void) {
        self.configure = configure
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let navigationController = navigationController {
            configure(navigationController)
        }
    }
}
