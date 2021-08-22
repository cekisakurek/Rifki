//
//  PlaygroundView.swift
//  DataAnalyzer
//
//  Created by Cihan E. Kisakurek on 19.08.21.
//  Copyright © 2021 cekisakurek. All rights reserved.
//

import SwiftUI
import QGrid

struct PlaygroundView: View {
    
    var objectID: NSManagedObjectID?
    
    @StateObject private var viewModel = PlaygroundViewModel()
    @State private var presentingAddGraphView = false
    
    var body: some View {
        
        HStack {
            if let items = viewModel.items {
                QGrid(items, columns: 3) { item in
                    GridCell(objectID: objectID, item: item, presenting: $presentingAddGraphView)
                        .frame(width: 300, height: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                        .padding()
                }
                .sheet(isPresented: $presentingAddGraphView){
                    SelectGraphTypeView(objectID: objectID, presenting: $presentingAddGraphView)
                }
            }
            else {
                CenteredProgressView()
            }
        }
        .onAppear {
            viewModel.getGraphs(from: objectID)
        }
    }
    
    struct GridCell: View {
        
        var objectID: NSManagedObjectID?
        var item: PlaygroundViewModel.PlaygroundGraphItem
        
        @Binding var presenting: Bool
        
        var body: some View {
            if item.index == -1 {
                Button {
                    presenting.toggle()
                } label: {
                    Text("➕")
                        .font(.system(size: 160))
                        .multilineTextAlignment(.center)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
            else {
                NavigationLink(destination: PlaygroundGraphView(graph: item.graph)) {
                    VStack(alignment: .center) {
                        Image(systemName: "chart.bar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color(red: 70.0/255.0, green: 70.0/255.0, blue: 70.0/255.0))
                        Text(item.graph!.name!)
                            .foregroundColor(Color(red: 70.0/255.0, green: 70.0/255.0, blue: 70.0/255.0))
                            .padding()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }
}

struct SelectGraphAxesView: View {
    
    var objectID: NSManagedObjectID?
    var selectedType: PlaygroundGraphType!
    
    @Binding var presenting: Bool
    @StateObject var viewModel = AddGraphViewModel()
    @State var xAxis = ""
    @State var yAxis = ""
    @State var name = ""
        
    var body: some View {
        Form {
            TextField(NSLocalizedString("Name", comment: ""), text: $name)
            Picker(NSLocalizedString("X Axis", comment: ""), selection: $xAxis) {
                ForEach(viewModel.headers, id: \.self) { header in
                    Text(header)
                }
            }
            Picker(NSLocalizedString("Y Axis", comment: ""), selection: $yAxis) {
                ForEach(viewModel.headers, id: \.self) { header in
                    Text(header)
                }
            }
        }
        .navigationBarItems(trailing: saveButton)
        .navigationBarTitle(NSLocalizedString("Select Axes", comment: ""))
        .onAppear{
            viewModel.objectID = objectID
        }
    }
    
    var saveButton: some View {
        Button(action: {
            viewModel.save(xAxis: xAxis, yAxis: yAxis, type: selectedType, name: name)
            presenting = false
            
        }) {
            Text(NSLocalizedString("Save", comment: ""))
        }
    }
}


struct SelectGraphTypeView: View {
    
    var objectID: NSManagedObjectID?
    
    @Binding var presenting: Bool
    
    var closeButton: some View {
        Button(action: { presenting = false }) {
            Image(systemName: "xmark")
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    NavigationLink(destination: SelectGraphAxesView(objectID: objectID, selectedType: PlaygroundGraphType.Bar, presenting: $presenting)) {
                        
                        ImageItemView(image: Image("barchart"),
                                      name: NSLocalizedString("Bar Chart", comment: ""))
                    }
                    NavigationLink(destination: SelectGraphAxesView(objectID: objectID, selectedType: PlaygroundGraphType.Line, presenting: $presenting)) {
                        
                        ImageItemView(image: Image("linechart"),
                                      name: NSLocalizedString("Line Chart", comment: ""))
                    }
                }
                HStack {
                    NavigationLink(destination: SelectGraphAxesView(objectID: objectID, selectedType: PlaygroundGraphType.Scatter, presenting: $presenting)) {
                        
                        ImageItemView(image: Image("scatterchart"),
                                      name: NSLocalizedString("Scatter Chart", comment: ""))
                    }
                }
            }
            .navigationTitle(NSLocalizedString("Select Type", comment: ""))
            .navigationBarItems(trailing: closeButton)
        }
    }
    
    struct ImageItemView: View {
        
        var image: Image
        var name: String
        
        var body: some View {
            VStack {
                image
                    .resizable()
                    .frame(width: 200, height: 200)
                    .aspectRatio(contentMode: .fit)
                Text(name)
            }
        }
    }
}

//struct PlaygroundView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaygroundView()
//    }
//}
