//
//  MainChart.swift
//  microcosm-mac
//
//  Created by Yuji Ogata on 2016/08/31.
//  Copyright © 2016年 Yuji Ogata. All rights reserved.
//

import Cocoa

class MainChart: NSView {
    var pos: Double = 0.0
    var config: ConfigData = ConfigData()
    var common: CommonData = CommonData()
    var cusps: [Double] = []
    
    var myClassVar: NSColor! // the optional mark ! to be noticed.
    
    override init(frame frameRect: NSRect) {
        super.init(frame:frameRect);
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    //or customized constructor/ init
    init(frame frameRect: NSRect, configinfo: ConfigData, cuspsinfo: [Double]) {
        super.init(frame:frameRect);
        config = configinfo
        cusps = cuspsinfo
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
//        let color = NSColor(calibratedRed: 1, green: 0, blue: 0, alpha: 1)
        // 外側円
        let circleRect = NSMakeRect((CGFloat)(config.zodiacPaddingLeft), (CGFloat)(config.zodiacPaddingTop),
                                    (CGFloat)(config.zodiacOuterWidth), (CGFloat)(config.zodiacOuterWidth))
        let path: NSBezierPath = NSBezierPath(ovalIn: circleRect);
        path.stroke()

        // 中心円
        let circleRect2 = NSMakeRect((CGFloat)(config.zodiacPaddingLeft) + (CGFloat)(config.zodiacOuterWidth - config.zodiacCenter) / 2,
                                     (CGFloat)(config.zodiacPaddingLeft) + (CGFloat)(config.zodiacOuterWidth - config.zodiacCenter) / 2,
                                     (CGFloat)(config.zodiacCenter), (CGFloat)(config.zodiacCenter))
        let path2: NSBezierPath = NSBezierPath(ovalIn: circleRect2);
        path2.stroke()

        // 内側円
        let circleRect3 = NSMakeRect((CGFloat)(config.zodiacPaddingLeft) + (CGFloat)(config.zodiacWidth) / 2,
                                     (CGFloat)(config.zodiacPaddingLeft) + (CGFloat)(config.zodiacWidth) / 2,
                                     (CGFloat)(config.zodiacOuterWidth - config.zodiacWidth),
                                     (CGFloat)(config.zodiacOuterWidth - config.zodiacWidth))
        let path3: NSBezierPath = NSBezierPath(ovalIn: circleRect3);
        path3.stroke()
        
//        var housepath : NSBezierPath = NSBezierPath(rect: dirtyRect)
        houseCuspRender(cusps: cusps)
        
    }
    
    func rotate(_ x: CGFloat, y: CGFloat, degree: CGFloat) -> NSPoint{
        
        var pt: NSPoint = NSPoint()
        // ホロスコープは180°から始まる
        let rad: CGFloat = ((degree + 180.0) / 180.0) * (CGFloat)(PI)
        pt.x = x * cos(rad) - y * sin(rad)
        pt.y = x * sin(rad) + y * cos(rad)
        
        return pt
    }

    func setPlanetPosition(_ ipl: Int, degree: Double, startDegree: Double) -> Void {
        let x: Double = (Double)(config.zodiacOuterWidth - config.zodiacWidth - 50) / 2
        let y: Double = 0
        let pt: NSPoint = rotate((CGFloat)(x), y: (CGFloat)(y), degree: (CGFloat)(degree - startDegree))
        
        let planets: [String] = ["☉", "☽", "☿", "♀", "♂", "♃", "♄", "♅", "♆", "♇"]

        
        let lbl: NSTextView = NSTextView(frame: CGRect(
            x: pt.x + (CGFloat)(config.zodiacPaddingLeft) +
                (CGFloat)(config.zodiacOuterWidth) / 2 - 20,
            y: pt.y + (CGFloat)(config.zodiacPaddingLeft) +
                (CGFloat)(config.zodiacOuterWidth) / 2 - 20,
            width: 30, height: 30))
        lbl.textStorage!.mutableString.setString(planets[ipl])
        //        lbl.stringValue = "aaa"
        lbl.drawsBackground = false
        lbl.isSelectable = false
        let xfont = NSFont(name: "Helvetica", size: 18)
        
        lbl.font = xfont
        self.addSubview(lbl)
        
    }
    
    func houseCuspRender(cusps: [Double]) {
        let startX: Double = (Double)(config.zodiacOuterWidth - config.zodiacWidth) / 2
        let startY: Double = 0
        let endX: Double = (Double)(config.zodiacCenter) / 2
        let endY: Double = 0
        
        for i in 1..<13 {
            let degree: Double = cusps[i] - cusps[1]
            let startPt: NSPoint = rotate((CGFloat)(startX), y: (CGFloat)(startY), degree: (CGFloat)(degree))
            let endPt: NSPoint = rotate((CGFloat)(endX), y: (CGFloat)(endY), degree: (CGFloat)(degree))
            let pathLine: NSBezierPath = NSBezierPath()
            pathLine.move(to: NSPoint(
                x: startPt.x + (CGFloat)(config.zodiacPaddingLeft) +
                    (CGFloat)(config.zodiacOuterWidth) / 2,
                y:startPt.y + (CGFloat)(config.zodiacPaddingTop) +
                    (CGFloat)(config.zodiacOuterWidth) / 2))
            pathLine.line(to: NSPoint(x: endPt.x + (CGFloat)(config.zodiacPaddingLeft) +
                (CGFloat)(config.zodiacOuterWidth) / 2,
                                      y:endPt.y + (CGFloat)(config.zodiacPaddingTop) +
                                        (CGFloat)(config.zodiacOuterWidth) / 2))
            pathLine.stroke()
            
        }

    }

    func zodiacRender(_ degree: Double) -> Void {
        
        for i in 0..<12 {
            let newDegree: Double = (Double)(30 * (i + 1)) - degree - 15.0
            let x: Double = (Double)(config.zodiacOuterWidth - 30) / 2
            let y: Double = 0
            let pt: NSPoint = rotate((CGFloat)(x), y: (CGFloat)(y), degree: (CGFloat)(newDegree))

            let newX = pt.x + (CGFloat)(config.zodiacPaddingLeft) +
                (CGFloat)(config.zodiacOuterWidth) / 2 - 16
            let newY = pt.y + (CGFloat)(config.zodiacPaddingLeft) +
                (CGFloat)(config.zodiacOuterWidth) / 2 - 16

            let lbl: NSTextView = NSTextView(frame: CGRect(
                x: newX,
                y: newY,
                width: 30, height: 30))
            lbl.textStorage!.mutableString.setString(common.getSignSymbol(i))
            //        lbl.stringValue = "aaa"
            lbl.drawsBackground = false
            lbl.isSelectable = false
            let xfont = NSFont(name: "Helvetica", size: 18)
            
            lbl.font = xfont
            self.addSubview(lbl)
        }
        
        
    }

    @IBAction func itemClick(sender: AnyObject) {
        NSLog("chart")
    }
    
}
