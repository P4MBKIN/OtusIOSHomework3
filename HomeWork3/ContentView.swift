//
//  ContentView.swift
//  HomeWork3
//
//  Created by Pavel Antonov on 13.01.2020.
//  Copyright © 2020 OtusHomework. All rights reserved.
//

import SwiftUI
import OtusGithubAPI
import OtusNewsAPI

struct ContentView: View {
    @State var selectIndex: Int = 0
    
    var body: some View {
        VStack {
            Picker(selection: self.$selectIndex, label: Text("Label")) {
                Text("Github").tag(0)
                Text("News").tag(1)
                Text("Histogram").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            if selectIndex == 0 {
                PieChartView(
                    data: ChartData(values: SearchAPI.getCountRequestResult(queries: ("language:ObjC", "Objective C"), ("language:Swift", "Swift"), ("language:kotlin", "Kotlin"), ("language:C++", "C++"), ("language:C#", "C#"))),
                    title: "Github",
                    legend: "Count of repos",
                    valueSpecifier: "%.0f"
                )
                .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))
                .animation(.linear(duration: 0.3))
            } else if selectIndex == 1 {
                BarChartView(
                    data: ChartData(values: ArticlesAPI.getCountRequestResult(queries: ("ML", "Machine Learning"), ("VR", "Virtual Reality"), ("AR", "Augmented Reality"), ("IoT", "Internet of Things"), ("blockchain", "Blockchain"), ("bitcoin", "Bitcoin"), ("nginx", "Nginx"))),
                    title: "News",
                    legend: "Count of news",
                    valueSpecifier: "%.0f"
                )
                .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))
                    .animation(.linear(duration: 0.3))
            } else if selectIndex == 2 {
                LineChartView(
                    data: ChartData(values: Histogram().histogram.map{($0.0, $0.1)}),
                    title: "Histogram",
                    legend: "Data histogram",
                    valueSpecifier: "%.0f"
                )
            }
        }
    .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
