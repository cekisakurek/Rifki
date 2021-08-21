//
//  RawAnalysisView.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 19.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//

import SwiftUI

struct RawAnalysisView: View {
    
    var objectID: NSManagedObjectID
    
    var body: some View {
        RawAnalysisCollectionView(objectID: objectID)
    }
}

//struct RawAnalysisView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        let dataset = Dataset().objectID
//        
//        RawAnalysisView(objectID: dataset)
//    }
//}
