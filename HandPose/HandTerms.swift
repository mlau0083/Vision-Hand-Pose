//
//  HandTerms.swift
//  HandPose
//
//  Created by Yannis De Cleene on 04/07/2020.
//  Copyright © 2020 Apple. All rights reserved.
//

import CoreGraphics

public struct Thumb {
    let TIP: CGPoint
    let IP: CGPoint
    let MP: CGPoint
    let CMC: CGPoint
}

struct PossibleThumb {
    let TIP: CGPoint?
    let IP: CGPoint?
    let MP: CGPoint?
    let CMC: CGPoint?
}

public struct Finger {
    let TIP: CGPoint
    let DIP: CGPoint
    let PIP: CGPoint
    let MCP: CGPoint
}

struct PossibleFinger {
    let TIP: CGPoint?
    let DIP: CGPoint?
    let PIP: CGPoint?
    let MCP: CGPoint?
}

enum FingerIndicator {
    case thumb
    case index
    case middle
    case ring
    case little
}

struct Fingers {
    let thumb: Thumb
    let index: Finger
    let middle: Finger
    let ring: Finger
    let little: Finger
    let wrist: CGPoint
    
    func extends(finger: FingerIndicator) -> Bool {
        var chosenFinger = index
        
        switch finger {
        case .index:
            chosenFinger = index
        case .middle:
            chosenFinger = middle
        case .ring:
            chosenFinger = ring
        case .little:
            chosenFinger = little
        case .thumb:
            let thumbTIPAngle = abs(CGPoint.angleBetween(p1: thumb.TIP, p2: thumb.MP, p3: index.MCP))
            let TIPExtends = thumb.TIP.distance(from: index.MCP) > thumb.IP.distance(from: index.MCP) && thumbTIPAngle > 30.0
//            let TIPExtends = thumb.TIP.distance(from: wrist) > thumb.IP.distance(from: wrist) && thumbTIPAngle > 20.0
//            let DIPExtends = thumb.IP.distance(from: wrist) > thumb.MP.distance(from: wrist)
//            let PIPExtends = thumb.MP.distance(from: wrist) > thumb.CMC.distance(from: wrist)
            let thumbOutPalm = abs(thumb.TIP.distance(from: little.MCP)) > abs(index.TIP.distance(from: little.MCP))
            return TIPExtends && thumbOutPalm //&& DIPExtends && PIPExtends
        }
        
        let TIPExtends = chosenFinger.TIP.distance(from: wrist) > chosenFinger.DIP.distance(from: wrist)
        let DIPExtends = chosenFinger.DIP.distance(from: wrist) > chosenFinger.PIP.distance(from: wrist)
        let PIPExtends = chosenFinger.PIP.distance(from: wrist) > chosenFinger.MCP.distance(from: wrist)
        return TIPExtends && DIPExtends && PIPExtends
    }
    
    func findGesture() -> String {
        var sign = ""
        let extendedThumb = self.extends(finger: .thumb)
        let extendedIndex = self.extends(finger: .index)
        let extendedMiddle = self.extends(finger: .middle)
        let extendedRing = self.extends(finger: .ring)
        let extendedLittle = self.extends(finger: .little)
        
        if (extendedThumb && extendedIndex && !extendedMiddle && !extendedRing && extendedLittle) {
            sign = "🤟🏻"
        }
        
        if (extendedThumb && !extendedIndex && !extendedMiddle && !extendedRing && !extendedLittle && thumb.TIP.y < little.MCP.y && abs(thumb.TIP.y-little.MCP.y) > abs(thumb.TIP.x - little.MCP.x)) {
            sign = "👍"
        }
        
        if (extendedThumb && !extendedIndex && !extendedMiddle && !extendedRing && !extendedLittle && thumb.TIP.y > little.MCP.y && abs(thumb.TIP.y-little.MCP.y) > abs(thumb.TIP.x - little.MCP.x)) {
            sign = "👎🏾"
        }
        
        if (extendedThumb && !extendedIndex && !extendedMiddle && !extendedRing && !extendedLittle && thumb.TIP.x < little.MCP.x && abs(thumb.TIP.y-little.MCP.y) < abs(thumb.TIP.x - little.MCP.x)) {
            sign = "⬅️"
        }
        
        if (extendedThumb && !extendedIndex && !extendedMiddle && !extendedRing && !extendedLittle && thumb.TIP.x > little.MCP.x && abs(thumb.TIP.y-little.MCP.y) < abs(thumb.TIP.x - little.MCP.x)) {
            sign = "➡️"
        }
        
        if (!extendedThumb && extendedIndex && !extendedMiddle && !extendedRing && !extendedLittle && index.TIP.y < wrist.y && abs(index.TIP.y-wrist.y) > abs(index.TIP.x - wrist.x)) {
            sign = "☝🏻"
        }
        
        if (!extendedThumb && extendedIndex && !extendedMiddle && !extendedRing && !extendedLittle && index.TIP.y > wrist.y && abs(index.TIP.y-wrist.y) > abs(index.TIP.x - wrist.x)) {
            sign = "👇🏻"
        }
        if (!extendedThumb && extendedIndex && !extendedMiddle && !extendedRing && !extendedLittle && index.TIP.x < wrist.x && abs(index.TIP.y-wrist.y) < abs(index.TIP.x - wrist.x)) {
            sign = "👈🏻"
        }
        
        if (!extendedThumb && extendedIndex && !extendedMiddle && !extendedRing && !extendedLittle && index.TIP.x > wrist.x && abs(index.TIP.y-wrist.y) < abs(index.TIP.x - wrist.x)) {
            sign = "👉🏻"
        }
        
        if (!extendedThumb && extendedIndex && extendedMiddle && !extendedRing && !extendedLittle) {
            sign = "✌🏻"
        }
        
        if (extendedThumb && extendedIndex && extendedMiddle && extendedRing && extendedLittle) {
            sign = "🖐🏻"
        }
        
        if (!extendedThumb && !extendedIndex && !extendedMiddle && !extendedRing && !extendedLittle) {
            sign = "✊🏻"
        }
        
        if (!extendedThumb && !extendedIndex && extendedMiddle && extendedRing && extendedLittle) {
            sign = "👌🏻"
        }
        print(sign, extendedThumb, extendedIndex,extendedMiddle,extendedRing,extendedLittle)
        return sign
    }
}

typealias PossibleFingers = (thumb: PossibleThumb, index: PossibleFinger, middle: PossibleFinger, ring: PossibleFinger, little: PossibleFinger, wrist: CGPoint?)

let defaultHand = Fingers(thumb: Thumb(TIP: .zero, IP: .zero, MP: .zero, CMC: .zero),
                          index: Finger(TIP: .zero, DIP: .zero, PIP: .zero, MCP: .zero),
                          middle: Finger(TIP: .zero, DIP: .zero, PIP: .zero, MCP: .zero),
                          ring: Finger(TIP: .zero, DIP: .zero, PIP: .zero, MCP: .zero),
                          little: Finger(TIP: .zero, DIP: .zero, PIP: .zero, MCP: .zero),
                          wrist: .zero)
