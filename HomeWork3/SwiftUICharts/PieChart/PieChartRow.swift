//
//  PieChartRow.swift
//  HomeWork3
//
//  Created by Pavel Antonov on 14.01.2020.
//  Copyright © 2020 OtusHomework. All rights reserved.
//

import SwiftUI

public struct PieChartRow : View {
    @Binding var selectIndex: Int
    var data: [Double]
    var slices: [PieSlice] {
        var tempSlices:[PieSlice] = []
        var lastEndDeg:Double = 0
        let maxValue = data.reduce(0, +)
        for slice in data {
            let normalized: Double = Double(slice)/Double(maxValue)
            let startDeg = lastEndDeg
            let endDeg = lastEndDeg + (normalized * 360)
            lastEndDeg = endDeg
            tempSlices.append(PieSlice(startDeg: startDeg, endDeg: endDeg, value: slice, normalizedValue: normalized))
        }
        return tempSlices
    }
    public var body: some View {
        GeometryReader { geometry in
            ZStack{
                ForEach(0..<self.slices.count){ i in
                    PieChartCell(selectedIndex: self.$selectIndex, rect: geometry.frame(in: .local), startDeg: self.slices[i].startDeg, endDeg: self.slices[i].endDeg, index: i, color: Colors.rangomColor(i))
                }
            }
        }
    }
}

struct PieChartRow_Previews : PreviewProvider {
    static var previews: some View {
        PieChartRow(selectIndex: .constant(-1), data:[8,23,54,32,12,37,7,23,43]).frame(width: 200, height: 200)
        
    }
}
