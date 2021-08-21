//
//  HeatmapView.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 19.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//

import SwiftUI

struct HeatmapView: View {
    
    var objectID: NSManagedObjectID
    
    @StateObject var viewModel = HeatmapViewModel()
    
    @Environment(\.appTheme) var appTheme: AppTheme
    
    var body: some View {
        ZoomableScrollView {
            if let results = viewModel.heatmapResult {
                HStack(alignment: VerticalAlignment.top) {
                    VStack {
                        VStack(alignment: HorizontalAlignment.leading, spacing: 0) {
                            ForEach(0..<results.labels.count + 1) { i in
                                HStack(alignment: VerticalAlignment.top, spacing: 0) {
                                    ForEach(0..<results.labels.count + 1) { j in
                                        if i == 0 && j == 0 {
                                            Text(" ").frame(width: 200, height: 200).padding(0)
                                        }
                                        else if i == 0 {
                                            let label: String = results.labels[j - 1]
                                            HeatmapRotatedText(text: label)
                                                .frame(width: 80, height: 200)
                                        }
                                        else if j == 0 {
                                            let label: String = results.labels[i - 1]
                                            Text(label)
                                                .frame(width: 200, height: 80)
                                                .padding(0)
                                        }
                                        else {
                                            let value = results.matrix[i - 1][j - 1]
                                            let valueString = "\(value)"
                                            let color = appTheme.heatmap.colorForValue(value: value)
                                            Text(valueString)
                                                .frame(width: 80, height: 80).padding(0)
                                                .background(Color(color))
                                        }
                                    }
                                }
                                .padding(0)
                            }
                        }
                    }
                }
                .padding(0)
            }
            else {
                CenteredProgressView()
            }
        }
        .onAppear(perform: {
            viewModel.calculateHeatmap(of: objectID)
        })
    }
    
    struct HeatmapRotatedText: View {
        
        var text: String
        @State private var size: CGSize = .zero
        var body: some View {
                    
            let newFrame = CGRect(origin: .zero, size: CGSize(width: size.height, height: size.width))
            
            Text(text)
                .fixedSize()
                .frame(alignment: .center)
                .captureSize(in: $size)
                .rotationEffect(.degrees(-90))
                .frame(width: newFrame.width,   // And apply the new frame
                       height: newFrame.height)
        }
    }
    
}

//struct HeatmapView_Previews: PreviewProvider {
//    static var previews: some View {
//        let dataset = Dataset().objectID
//        HeatmapView(objectID: dataset)
//    }
//}

