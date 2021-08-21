//
//  ProgressView.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 22.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//

import SwiftUI

struct CenteredProgressView: View {
    var body: some View {
        HStack(alignment: .center) {
            ProgressView()
        }
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}

