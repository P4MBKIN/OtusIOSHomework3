//
//  LineChartView.swift
//  HomeWork3
//
//  Created by Pavel Antonov on 16.01.2020.
//  Copyright © 2020 OtusHomework. All rights reserved.
//

import SwiftUI

struct LineChartView: View {
    @ObservedObject var data: ChartData
    public var title: String
    public var legend: String?
    public var style: ChartStyle
    public var dropShadow: Bool
    public var valueSpecifier: String
    
    @State private var touchLocation: CGPoint = .zero
    @State private var showIndicatorDot: Bool = false
    @State private var currentValue: Double = 2 {
        didSet{
            if (oldValue != self.currentValue && showIndicatorDot) {
                HapticFeedback.playSelection()
            }
            
        }
    }
    private var rateValue: Int
    
    public init(data: ChartData, title: String, legend: String? = nil, style: ChartStyle = Styles.lineChartStyleOne, rateValue: Int? = 14, dropShadow: Bool? = true, valueSpecifier: String? = "%.1f"){
        self.data = data
        self.title = title
        self.legend = legend
        self.style = style
        self.rateValue = rateValue!
        self.dropShadow = dropShadow!
        self.valueSpecifier = valueSpecifier!
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center){
                VStack(alignment: .leading){
                    VStack(alignment: .leading, spacing: 8){
                        Text(self.title).font(.title).bold().foregroundColor(self.style.textColor)
                        if (self.legend != nil){
                            Text(self.legend!).font(.callout).foregroundColor(self.style.legendTextColor)
                        }
                        HStack {
                            if !self.showIndicatorDot {
                                if self.rateValue >= 0 {
                                    Image(systemName: "arrow.up")
                                } else {
                                    Image(systemName: "arrow.down")
                                }
                                Text("\(self.rateValue)%")
                                    .font(.system(size: 41, weight: .bold, design: .default))
                            } else {
                                Spacer()
                                Text("\(self.currentValue, specifier: self.valueSpecifier)")
                                    .font(.system(size: 41, weight: .bold, design: .default))
                                    .foregroundColor(Colors.OrangeStart)
                                Spacer()
                            }
                        }
                    }
                    .transition(.opacity)
                    .animation(.easeIn(duration: 0.1))
                    .padding([.leading, .top])
                    Spacer()
                    GeometryReader{ geometry in
                        Line(data: self.data, frame: .constant(geometry.frame(in: .local)), touchLocation: self.$touchLocation, showIndicator: self.$showIndicatorDot)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .offset(x: 0, y: 0)
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            }
            .gesture(DragGesture()
            .onChanged({ value in
                self.touchLocation = value.location
                self.showIndicatorDot = true
                self.getClosestDataPoint(toPoint: value.location, width:geometry.size.width, height: geometry.size.height)
            })
                .onEnded({ value in
                    self.showIndicatorDot = false
                })
            )
        }
    }
    
    @discardableResult func getClosestDataPoint(toPoint: CGPoint, width:CGFloat, height: CGFloat) -> CGPoint {
        let points = self.data.onlyPoints()
        let stepWidth: CGFloat = width / CGFloat(points.count-1)
        let stepHeight: CGFloat = height / CGFloat(points.max()! + points.min()!)
        
        let index:Int = Int(round((toPoint.x)/stepWidth))
        if (index >= 0 && index < points.count){
            self.currentValue = points[index]
            return CGPoint(x: CGFloat(index)*stepWidth, y: CGFloat(points[index])*stepHeight)
        }
        return .zero
    }
}

struct LineChartView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LineChartView(data: ChartData(points: [8,23,54,32,12,37,7,23,43]), title: "Line chart", legend: "Basic")
                .environment(\.colorScheme, .light)
        }
    }
}
