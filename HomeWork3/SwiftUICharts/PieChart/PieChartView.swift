//
//  PieChartView.swift
//  HomeWork3
//
//  Created by Pavel Antonov on 15.01.2020.
//  Copyright © 2020 OtusHomework. All rights reserved.
//

import SwiftUI

struct PieChartView: View {
    public var data: ChartData
    public var title: String
    public var legend: String?
    public var style: ChartStyle
    public var dropShadow: Bool
    
    @State private var selectIndex: Int = -1

    public init(data: ChartData, title: String, legend: String? = nil, style: ChartStyle = Styles.pieChartStyleOne, dropShadow: Bool? = true){
        self.data = data
        self.title = title
        self.legend = legend
        self.style = style
        self.dropShadow = dropShadow!
    }
    
    public var body: some View {
        ZStack{
            VStack(alignment: .leading){
                HStack {
                    Text(self.title)
                        .font(.headline)
                        .foregroundColor(self.style.textColor)
                    if(self.legend != nil) {
                        Text(self.legend!)
                            .font(.callout)
                            .foregroundColor(self.style.accentColor)
                            .transition(.opacity)
                            .animation(.easeOut)
                    }
                    Spacer()
                    Image(systemName: "chart.pie.fill")
                        .imageScale(.large)
                        .foregroundColor(self.style.legendTextColor)
                }.padding()
                PieChartRow(selectIndex: self.$selectIndex, data: self.data.points.map{$0.1})
                    .foregroundColor(self.style.accentColor).padding(self.legend != nil ? 0 : 12).offset(y:self.legend != nil ? 0 : -10)
                HStack {
                    Circle()
                        .fill()
                        .foregroundColor(self.selectIndex != -1 ? Colors.rangomColor(self.selectIndex) : .gray)
                        .frame(width: 30, height: 30)
                    Text(self.selectIndex != -1 ? self.data.points[self.selectIndex].0 : "Selected pie")
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                    Text(self.selectIndex != -1 ? String(self.data.points[self.selectIndex].1) : "Value")
                        .font(.headline)
                        .foregroundColor(Colors.OrangeStart)
                }
                .padding()
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView(data: TestData.values, title: "Title", legend: "Legend")
    }
}
