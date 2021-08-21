//
//  ColumnAnalysisView.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 19.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//

import SwiftUI

struct ColumnAnalysisView: View {
    
    var objectID: NSManagedObjectID
    
    @StateObject var viewModel = ColumnAnalysisViewModel()
    @State var selectedColumn: String?
    @Environment(\.appTheme) var appTheme: AppTheme
    
    var body: some View {
        HStack() {
            List {
                Section {
                    ForEach(viewModel.headers, id: \.self) { header in
                        HStack {
                            Text(header).frame(maxHeight: .infinity)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedColumn = header
                            viewModel.calculateDistribution(of: header)
                            viewModel.calculateProbability(of: header)
                            viewModel.calculateDescription(of: header)
                        }
                        .listRowBackground(self.selectedColumn == header ? Color(appTheme.columnAnalysis.columnSelectedBackground) : Color.clear)
                    }
                } 
            }
            .onAppear(perform: {
                viewModel.objectID = objectID
            })
            .frame(width: 300.0)
            .overlay(Divider(), alignment: .trailing)
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    if viewModel.calculatingProbability {
                        CenteredProgressView()
                            .frame(maxHeight: .infinity)
                    }
                    else {
                        ProbabilityGraphSegmentView(result: viewModel.probabilityResult)
                    }
                }
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                HStack {
                    if viewModel.calculatingDistribution {
                        CenteredProgressView()
                            .frame(maxHeight: .infinity)
                    }
                    else {
                        DistributionGraphSegmentView(result: viewModel.histogramResult)
                    }
                }
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                HStack {
                    if viewModel.calculatingDescription {
                        ColumnDescriptionView(data: nil)
                    }
                    else {
                        ColumnDescriptionView(data: viewModel.descriptionResult)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .contentShape(Rectangle())
        }
        .padding()
    }
    
    struct DistributionGraphSegmentView: View {
        
        var result: HistorgramResult?
        
        var body: some View {
            RotatedText(angle: .degrees(-90), text: NSLocalizedString("Frequency", comment: ""))
            VStack {
                Text(NSLocalizedString("Distribution", comment: ""))
                    .font(.title)
                DistributionGraphViewRepresentation(data: result)
                    .frame(maxWidth: .infinity)
                Text(NSLocalizedString("Values", comment: ""))
            }
        }
    }

    struct ProbabilityGraphSegmentView: View {
        
        var result: ProbabilityResult?
        
        var body: some View {
            RotatedText(angle: .degrees(-90), text: NSLocalizedString("Ordered Values", comment: ""))
            VStack {
                Text(NSLocalizedString("Probability", comment: ""))
                    .font(.title)
                ProbabilityGraphViewRepresentation(data: result)
                    .frame(maxWidth: .infinity)
                Text(NSLocalizedString("Theoretical Quantiles", comment: ""))
            }
        }
    }
}



//struct ColumnAnalysisView_Previews: PreviewProvider {
//    static var previews: some View {
//        let dataset = Dataset().objectID
//        ColumnAnalysisView(objectID: dataset)
//    }
//}
