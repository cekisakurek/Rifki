//
//  DatasetSelectionView.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 19.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//

import SwiftUI
import UniformTypeIdentifiers

struct DatasetSelectionView: View {
    
    @StateObject var viewModel = DatasetSelectionViewModel()
    
    private static let context = PersistenceController.shared.container.viewContext
    
    var body: some View {
        List {
            ForEach(viewModel.datasets) { dataset in
                NavigationLink(destination: DatasetDetailsView(objectID: dataset.objectID)) {
                    DatasetRow(name: dataset.name)
                }
            }
            .onDelete(perform: viewModel.removeDatasets)
        }
        .navigationTitle(NSLocalizedString("Datasets", comment: ""))
        .navigationBarItems(trailing: addDatasetButton)
    }
    
    var addDatasetButton: some View {
        Button(action: { viewModel.showDocumentPicker() }) {
            Image(systemName: "plus")
        }
    }
    
    final class DatasetSelectionViewModel: NSObject, ObservableObject, UIDocumentPickerDelegate, NSFetchedResultsControllerDelegate {
        
        @Published var fileURL: URL?
        
        @Published var datasets: [Dataset]!
        
        private lazy var fetchedResultsController: NSFetchedResultsController<Dataset> = {
            let request: NSFetchRequest<Dataset> = Dataset.fetchRequest()
            let sort = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [sort]
            request.fetchBatchSize = 20
            let frc = NSFetchedResultsController<Dataset>(fetchRequest: request, managedObjectContext: DatasetSelectionView.context, sectionNameKeyPath: nil, cacheName: nil)
            frc.delegate = self
            return frc
        }()
        
        override init() {
            super.init()
            do {
                try self.fetchedResultsController.performFetch()
                datasets = self.fetchedResultsController.fetchedObjects ?? []
            }
            catch {
                datasets = []
            }
        }
        
        func showDocumentPicker() {
            let supportedTypes: [UTType] = [UTType.commaSeparatedText]
            let picker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
            picker.delegate = self
            picker.allowsMultipleSelection = false
            picker.modalPresentationStyle = .formSheet
            
            let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
            window?.rootViewController!.present(picker, animated: false, completion: nil)
        }
        
        func removeDatasets(at offsets: IndexSet) {
            for index in offsets {
                let dataset = datasets[index]
                do {
                    try dataset.delete()
                    
                }
                catch {
                    print(String(describing: error))
                }
            }
        }
        
        //MARK: NSFetchedResultsControllerDelegate
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let objects = controller.fetchedObjects {
                self.datasets = objects as? [Dataset]
            }
            else {
                self.datasets = []
            }
        }
        
        //MARK: UIDocumentPickerDelegate
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let url = urls.first {
                if var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                    components.scheme = "rifki"
                    UIApplication.shared.open(components.url!)
                }
            }
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            print("cancelled")
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
            print(url)
        }
    }
    
    struct DatasetRow: View {
        var name: String?
        
        var body: some View {
            Text(name ?? NSLocalizedString("New Dataset", comment: ""))
        }
    }
}

//struct DatasetSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        DatasetSelectionView()
//    }
//}
