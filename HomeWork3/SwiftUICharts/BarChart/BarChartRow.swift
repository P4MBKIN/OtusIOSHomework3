//
//  BarChartRow.swift
//  HomeWork3
//
//  Created by Pavel Antonov on 14.01.2020.
//  Copyright © 2020 OtusHomework. All rights reserved.
//

import SwiftUI

struct BarChartRow: View {
    var data: [Double]
    var accentColor: Color
    var secondGradientAccentColor: Color?
    var maxValue: Double {
        data.max() ?? 0
    }
    @Binding var touchLocation: CGFloat
    public var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: (geometry.frame(in: .local).width-22)/CGFloat(self.data.count * 3)){
                ForEach(0..<self.data.count) { i in
                    BarChartCell(value: self.normalizedValue(index: i), index: i, width: Float(geometry.frame(in: .local).width - 22), numberOfDataPoints: self.data.count, accentColor: self.accentColor, secondGradientAccentColor: self.secondGradientAccentColor, touchLocation: self.$touchLocation)
                        .scaleEffect(self.touchLocation > CGFloat(i)/CGFloat(self.data.count) && self.touchLocation < CGFloat(i+1)/CGFloat(self.data.count) ? CGSize(width: 1.4, height: 1.1) : CGSize(width: 1, height: 1), anchor: .bottom)
                        .animation(.spring())
                    
                }
            }
            .padding([.top, .leading, .trailing], 10)
        }
    }
    
    func normalizedValue(index: Int) -> Double {
        return Double(self.data[index])/Double(self.maxValue)
    }
}

struct BarChartRow_Previews: PreviewProvider {
    static var previews: some View {
        BarChartRow(data: [8,23,54,32,12,37,7], accentColor: Colors.OrangeStart, touchLocation: .constant(-1))
    }
}
