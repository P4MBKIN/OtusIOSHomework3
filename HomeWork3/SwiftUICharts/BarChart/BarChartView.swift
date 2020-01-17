//
//  BarChartView.swift
//  HomeWork3
//
//  Created by Pavel Antonov on 14.01.2020.
//  Copyright © 2020 OtusHomework. All rights reserved.
//

import SwiftUI

struct BarChartView: View {
    private var data: ChartData
    public var title: String
    public var legend: String?
    public var style: ChartStyle
    public var dropShadow: Bool
    public var valueSpecifier: String
    
    @State private var touchLocation: CGFloat = -1.0
    @State private var showValue: Bool = false
    @State private var showLabelValue: Bool = false
    @State private var currentValue: Double = 0 {
        didSet{
            if(oldValue != self.currentValue && self.showValue) {
                HapticFeedback.playSelection()
            }
        }
    }
    public init(data: ChartData, title: String, legend: String? = "Legend", style: ChartStyle = Styles.barChartStyleOrangeLight, dropShadow: Bool? = true, valueSpecifier: String? = "%.1f"){
        self.data = data
        self.title = title
        self.legend = legend
        self.style = style
        self.dropShadow = dropShadow!
        self.valueSpecifier = valueSpecifier!
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack{
                VStack(alignment: .leading){
                    HStack{
                        if(!self.showValue){
                            Text(self.title)
                                .font(.headline)
                                .foregroundColor(self.style.textColor)
                        }else{
                            Text("\(self.currentValue, specifier: self.valueSpecifier)")
                                .font(.headline)
                                .foregroundColor(Colors.OrangeStart)
                        }
                        if(self.legend != nil && !self.showValue) {
                            Text(self.legend!)
                                .font(.callout)
                                .foregroundColor(self.style.accentColor)
                                .transition(.opacity)
                                .animation(.easeOut)
                        }
                        Spacer()
                        Image(systemName: "waveform.path.ecg")
                            .imageScale(.large)
                            .foregroundColor(self.style.legendTextColor)
                    }.padding()
                    BarChartRow(data: self.data.points.map{$0.1}, accentColor: self.style.accentColor, secondGradientAccentColor: self.style.secondGradientColor, touchLocation: self.$touchLocation)
                    if (self.data.valuesGiven) {
                        LabelView(arrowOffset: self.getArrowOffset(touchLocation: self.touchLocation, width: geometry.size.width), title: .constant(self.getCurrentValue(width: geometry.size.width).0)).offset(x: self.getLabelViewOffset(touchLocation: self.touchLocation, width: geometry.size.width), y: CGFloat(-6))
                    }
                    
                }
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .gesture(DragGesture()
                    .onChanged({ value in
                        self.touchLocation = value.location.x / geometry.size.width
                        self.showValue = true
                        self.currentValue = self.getCurrentValue(width: geometry.size.width).1
                        if(self.data.valuesGiven) {
                            self.showLabelValue = true
                        }
                    })
                    .onEnded({ value in
                        self.showValue = false
                        self.showLabelValue = false
                        self.touchLocation = -1
                    })
            )
                .gesture(TapGesture()
            )
            
        }
    }
    
    func getArrowOffset(touchLocation: CGFloat, width: CGFloat) -> Binding<CGFloat> {
        let realLoc = (self.touchLocation * width) - 50
        if realLoc < 10 {
            return .constant(realLoc - 10)
        }else if realLoc > width - 110 {
            return .constant((width - 110 - realLoc) * -1)
        } else {
            return .constant(0)
        }
    }
    
    func getLabelViewOffset(touchLocation: CGFloat, width: CGFloat) -> CGFloat {
        return min(width - 110, max(10,(self.touchLocation * width) - 50))
    }
    
    func getCurrentValue(width: CGFloat)-> (String, Double) {
        let index = max(0, min(self.data.points.count - 1,Int(floor((self.touchLocation * width) / (width / CGFloat(self.data.points.count))))))
        return self.data.points[index]
    }
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartView(data: TestData.values ,title: "Model 3 sales", legend: "Quarterly", valueSpecifier: "%.0f")
    }
}
