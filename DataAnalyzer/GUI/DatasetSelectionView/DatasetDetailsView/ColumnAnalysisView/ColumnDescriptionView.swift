//
//  RowDescriptionView.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 19.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//

import SwiftUI

struct ColumnDescriptionView: View {
    
    @State var data: DescriptionResult?
    
    var body: some View {
        HStack(spacing: 200) {
            VStack(alignment: .leading) {
                // a for loop needed
                HStack {
                    Text(NSLocalizedString("Mean :", comment: ""))
                    Text(data?.mean ?? "")
                }
                HStack {
                    Text(NSLocalizedString("Std :", comment: ""))
                    Text(data?.std ?? "")
                }
                HStack {
                    Text(NSLocalizedString("Min :", comment: ""))
                    Text(data?.min ?? "")
                }
                HStack {
                    Text(NSLocalizedString("Max :", comment: ""))
                    Text(data?.max ?? "")
                }
                HStack {
                    Text(NSLocalizedString("25% :", comment: ""))
                    Text(data?.twoFivePercentile ?? "")
                }
                HStack {
                    Text(NSLocalizedString("50% :", comment: ""))
                    Text(data?.fiveZeroPercentile ?? "")
                }
                HStack {
                    Text(NSLocalizedString("75% :", comment: ""))
                    Text(data?.sevenFivePercentile ?? "")
                }
                HStack {
                    Text(NSLocalizedString("75% :", comment: ""))
                    Text(data?.sevenFivePercentile ?? "")
                }
            }
            VStack(alignment: HorizontalAlignment.leading) {
                HStack {
                    Text(NSLocalizedString("Kurtosis :", comment: ""))
                    Text(data?.kurtosis ?? "")
                }
                HStack {
                    Text(NSLocalizedString("Skewness :", comment: ""))
                    Text(data?.kurtosis ?? "")
                }
                HStack {
                    Text(NSLocalizedString("Type :", comment: ""))
                    Text(data?.type ?? "")
                }
                HStack {
                    Text(NSLocalizedString("Swilk P :", comment: ""))
                    Text(data?.swilkP ?? "")
                }
                HStack {
                    Text(NSLocalizedString("Swilk W :", comment: ""))
                    Text(data?.swilkW ?? "")
                }
                HStack {
                    Text(NSLocalizedString("Is Gaussian Distribution :", comment: ""))
                    Text(data?.isGaussian ?? "")
                }
                HStack {
                    Text(" ")
                    Text(" ")
                }
                HStack {
                    Text(" ")
                    Text(" ")
                }
            }
        }
    }
}

//struct RowDescriptionView_Previews: PreviewProvider {
//    static var previews: some View {
//        RowDescriptionView()
//    }
//}
