//
//  PieChartCell.swift
//  HomeWork3
//
//  Created by Pavel Antonov on 14.01.2020.
//  Copyright © 2020 OtusHomework. All rights reserved.
//

import SwiftUI

struct PieSlice: Identifiable {
    var id = UUID()
    var startDeg: Double
    var endDeg: Double
    var value: Double
    var normalizedValue: Double
}

public struct PieChartCell : View {
    @State private var show: Bool = false
    @State private var touched: Bool = false
    @Binding var selectedIndex: Int
    
    var rect: CGRect
    var radius: CGFloat {
        return min(rect.width, rect.height)/2
    }
    var startDeg: Double
    var endDeg: Double
    var path: Path {
        var path = Path()
        path.addArc(center:rect.mid , radius:self.radius, startAngle: Angle(degrees: self.startDeg), endAngle: Angle(degrees: self.endDeg), clockwise: false)
        path.addLine(to: rect.mid)
        path.closeSubpath()
        return path
    }
    var index: Int
    var color: Color
    public var body: some View {
        path
            .fill()
            .foregroundColor(self.color)
            .opacity(self.touched ? 1 : 0.4)
            .overlay(path.stroke(Color(.white), lineWidth: 3))
            .scaleEffect(self.show ? 1 : 0)
            .animation(Animation.spring().delay(Double(self.index) * 0.04))
            .onAppear(){
                self.show = true
            }
            .gesture(DragGesture()
                .onChanged({ _ in
                    withAnimation(.easeIn(duration: 0.5)) {
                        self.touched = true
                        self.selectedIndex = self.index
                    }
                })
                .onEnded({ _ in
                    withAnimation(.easeIn(duration: 0.5)) {
                        self.touched = false
                        self.selectedIndex = -1
                    }
                })
            )
    }
}

extension CGRect {
    var mid: CGPoint {
        return CGPoint(x:self.midX, y: self.midY)
    }
}

struct PieChartCell_Previews : PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            PieChartCell(selectedIndex: .constant(-1), rect: geometry.frame(in: .local),startDeg: 0.0,endDeg: 90.0, index: 0, color: Color(red: 2.0/255.0, green: 9.0/255.0, blue: 76.0/2.0))
            }.frame(width:100, height:100)
    }
}
