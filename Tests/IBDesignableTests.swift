//
//  Tests.swift
//  Tests
//
//  Created by Rico Crescenzio on 08/11/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//
/*
 
 var borderColor: UIColor? { get set }
 var isRounded: Bool { get set }
 
 var shadowOffset: CGSize { get set }
 var shadowColor: UIColor? { get set }
 var shadowRadius: CGFloat { get set }
 var shadowOpacity: Float { get set }
 
 var gradientColorsCount: Int { get set }
 
 var gradientStartPoint: CGPoint { get set }
 var gradientEndPoint: CGPoint { get set }
 
 var gradientColor1: UIColor? { get set }
 var gradientColor2: UIColor? { get set }
 var gradientColor3: UIColor? { get set }
 
 
 */

import XCTest
@testable import WinkKit

class IBDesignableTests: XCTestCase {
    
    var view: WKView!
    
    override func setUp() {
        view = WKView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
    }
    
    func testCornerRadius() {
        let radius: CGFloat = 10
        view.cornerRadius = radius
        XCTAssertEqual(view.cornerRadius, view.layer.cornerRadius)
        
        let newRadius: CGFloat = 15
        view.layer.cornerRadius = newRadius
        XCTAssertEqual(view.cornerRadius, newRadius)
    }
    
    func testBorderWidth() {
        let width: CGFloat = 2
        view.borderWidth = width
        XCTAssertEqual(view.borderWidth, view.layer.borderWidth)
        
        let newWidth: CGFloat = 5
        view.layer.borderWidth = newWidth
        XCTAssertEqual(view.borderWidth, newWidth)
        
    }
    
    func testBorderColor() {
        let color = UIColor.red
        view.borderColor = color
        
        XCTAssertEqual(view.layer.borderColor, color.cgColor)
        XCTAssertEqual(view.borderColor?.cgColor, view.layer.borderColor)
        
        let newColor = UIColor.brown
        view.layer.borderColor = newColor.cgColor
        XCTAssertEqual(view.borderColor, newColor)
    }
    
    func testIsRounded() {
        view.isRounded = true // if set to true, the view must have corner radius = width / 2
        XCTAssertEqual(view.layer.cornerRadius, view.bounds.width / 2)
        
        view.layer.cornerRadius = 2 // if I change manually layer.cornerRadius, view.isRounded must become false
        XCTAssert(!view.isRounded)
        
        view.layer.cornerRadius = view.bounds.width / 2 // now, it doesn't matter that the corner radius is equals to to the view width, it's only a specific case. isRounded must remain false
        XCTAssert(!view.isRounded)
        
    }
    
    func testShadowOffset() {
        let shadowOffset = CGSize(width: 5, height: 10)
        view.shadowOffset = shadowOffset
        XCTAssertEqual(view.shadowOffset, view.layer.shadowOffset)
        
        let newShadowOffset = CGSize(width: 10, height: 5)
        view.layer.shadowOffset = newShadowOffset
        XCTAssertEqual(view.shadowOffset, newShadowOffset)
    }
    
    func testShadowColor() {
        let color = UIColor.red
        view.shadowColor = color
        
        XCTAssertEqual(view.layer.shadowColor, color.cgColor)
        XCTAssertEqual(view.shadowColor?.cgColor, view.layer.shadowColor)
        
        let newColor = UIColor.brown
        view.layer.shadowColor = newColor.cgColor
        XCTAssertEqual(view.shadowColor, newColor)
    }
    
    func testShadowRadius() {
        let radius: CGFloat = 10
        view.shadowRadius = radius
        XCTAssertEqual(view.shadowRadius, view.layer.shadowRadius)
        
        let newRadius: CGFloat = 15
        view.layer.shadowRadius = newRadius
        XCTAssertEqual(view.shadowRadius, newRadius)
    }
    
    func testShadowOpacity() {
        let alpha: Float = 0.5
        view.shadowOpacity = alpha
        XCTAssertEqual(view.shadowOpacity, view.layer.shadowOpacity)
        
        let newAlpha: Float = 0.75
        view.layer.shadowOpacity = newAlpha
        XCTAssertEqual(view.shadowOpacity, newAlpha)
    }

    func testGradientColorsCount() {
        XCTAssertNil(view.gradientLayer)
        
        view.gradientColorsCount = 1
        XCTAssertNotNil(view.gradientLayer)
        XCTAssertNotNil(view.gradientLayer?.colors)
        
        XCTAssertEqual(view.gradientLayer!.colors!.count, 0) // color count increment when color is set too
        view.gradientColor1 = .red
        XCTAssertEqual(view.gradientLayer!.colors!.count, 1)
        
        view.gradientColorsCount = 2
        view.gradientColor2 = .blue
        XCTAssertEqual(view.gradientLayer!.colors!.count, 2)
        
        view.gradientColorsCount = 3
        view.gradientColor3 = .yellow
        XCTAssertEqual(view.gradientLayer!.colors!.count, 3)
        
        view.gradientColorsCount = 10 // test if > 3, return 3
        XCTAssertEqual(view.gradientLayer!.colors!.count, 3)
        
        view.gradientColorsCount = -121 // test if < 0, return 0
        XCTAssertNil(view.gradientLayer)
    }

}
