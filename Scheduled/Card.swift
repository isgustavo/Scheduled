//
//  Card.swift
//  Card
//
//  Created by Gustavo F Oliveira on 4/27/16.
//  Copyright © 2016 Gustavo F Oliveira. All rights reserved.
//

import UIKit

class Card: UIView {
    
    @IBOutlet weak var contentView: UIView?
    @IBOutlet weak var rightHalfCircle: UIView!
    @IBOutlet weak var leftHalfCircle: UIView!
    
    @IBOutlet weak var arrivalCity: UILabel!
    @IBOutlet weak var arrivalAirport: UILabel!
    
    @IBOutlet weak var departureCity: UILabel!
    @IBOutlet weak var departureAirport: UILabel!
    
    @IBOutlet weak var airline: UILabel!
    @IBOutlet weak var reservationCode: UILabel!
    
    @IBOutlet weak var dataHour: UILabel!
    
    @IBOutlet weak var hotel: UILabel!
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var phone: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NSBundle.mainBundle().loadNibNamed("Card", owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.addSubview(content)
        
        self.initHalfCircleIn(self.rightHalfCircle, xOffset: -5)
        self.initHalfCircleIn(self.leftHalfCircle, xOffset: 45)
        
        self.layer.shadowColor = UIColor.grayColor().CGColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSizeZero
        self.layer.shadowRadius = 10
        self.layer.shouldRasterize = true
        
        self.alpha = 0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    private func initHalfCircleIn(view: UIView, xOffset: CGFloat) {
        
        let overlayView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(50.0), height: view.frame.height))
        overlayView.alpha = 1
        overlayView.backgroundColor = UIColor.whiteColor()
        view.addSubview(overlayView)
        
        let maskLayer = CAShapeLayer()
        
        // Create a path with the rectangle in it.
        let path = CGPathCreateMutable()
        
        let radius : CGFloat = 10
        let yOffset : CGFloat = 15
        CGPathAddArc(path, nil, overlayView.frame.width - radius/2 - xOffset, yOffset, radius, 0.0, 2 * 3.14, false)
        CGPathAddRect(path, nil, CGRectMake(0, 0, overlayView.frame.width, overlayView.frame.height))
        
        maskLayer.backgroundColor = UIColor.blackColor().CGColor
        
        maskLayer.path = path;
        maskLayer.fillRule = kCAFillRuleEvenOdd
        
        // Release the path since it's not covered by ARC.
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true
        
    }
    
    
}
