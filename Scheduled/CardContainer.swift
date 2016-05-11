//
//  CardContainer.swift
//  Card
//
//  Created by Gustavo F Oliveira on 4/27/16.
//  Copyright © 2016 Gustavo F Oliveira. All rights reserved.
//

import UIKit

protocol CardContainerDataSource: class {
    
    func cardContainerViewNextViewWithIndex(index: Int) -> UIView
    
    func cardContainerViewNumberOfViewInIndex() -> Int
}

class CardContainer: UIView {
    
    private let cardMargin: CGFloat = CGFloat(7.0)
    
    private let viewCount: Int = 3
    private var loadedIndex: Int = 0
    private var currentIndex: Int = 0
    private var defaultFrame: CGRect?
    private var cardCenterX: CGFloat?
    private var cardCenterY: CGFloat?
    
    var dataSource: CardContainerDataSource?
    private var currentViews: [UIView]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func reloadCardContainer() {
        
        self.loadedIndex = 0
        self.currentIndex = 0
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        self.currentViews?.removeAll()
        self.currentViews = [UIView]()
        self.loadNextView()
        self.cardViewDefaultScale()
        
    }
    
    func getCurrentIndex() -> Int {
        return self.currentIndex
    }
    
    func getCurrentView() -> UIView? {
        return self.currentViews.first
    }
    
    func loadNextView() {
        
        
        if let d = self.dataSource {
            let index: Int = d.cardContainerViewNumberOfViewInIndex()
            
            
            if index == 0 && index == currentIndex {
                // complete dragging?
                
                
                return
            }
            
            if loadedIndex < index {
                
                let preloadViewCont = index <= self.viewCount ? index : self.viewCount
                
                for(var i: Int = currentViews.count; i < preloadViewCont; i += 1) {
                    
                    let view = self.dataSource?.cardContainerViewNextViewWithIndex(i)
                    
                    if let v = view {
                        
                        self.defaultFrame = v.frame
                        self.cardCenterX = v.center.x
                        self.cardCenterY = v.center.y
                        
                        self.addSubview(v)
                        self.sendSubviewToBack(v)
                        currentViews.append(v)
                        
                        loadedIndex += 1
                    }
                }
            }
        }
        
        if let view = self.getCurrentView() {
        
            let swipeGesture = UISwipeGestureRecognizer(target: self, action:  #selector(CardContainer.swipeDownCardGesture(_:)))
            swipeGesture.direction = UISwipeGestureRecognizerDirection.Down
            view.addGestureRecognizer(swipeGesture)
            
        }
        
    }
    
    func cardViewDefaultScale() {
        
        var index: Int = 0
        for v in currentViews {
            
            if index == 2 {
                UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations:  {
                    v.transform = CGAffineTransformIdentity
                    v.frame = CGRectMake(self.defaultFrame!.origin.x, self.defaultFrame!.origin.y - (self.cardMargin * 8) , self.self.defaultFrame!.size.width, self.defaultFrame!.size.height)
                    v.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFloat(0.87), CGFloat(0.96))
                    }, completion: { finished in
                        v.alpha = 1
                })
            } else if index == 1 {
                
                v.transform = CGAffineTransformIdentity
                v.frame = CGRectMake(self.defaultFrame!.origin.x, self.defaultFrame!.origin.y - (self.cardMargin * 4) , self.self.defaultFrame!.size.width, self.defaultFrame!.size.height)
                v.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFloat(0.93), CGFloat(0.98))
                v.alpha = 1
            } else if index == 0 {
                
                v.transform = CGAffineTransformIdentity
                v.frame = self.defaultFrame!
                v.alpha = 1
            }
            
            
            index += 1
            
        }
        
    }

    
    func swipeDownCardGesture(recognizer: UITapGestureRecognizer) {
        
        if let view = self.getCurrentView() {
        
            self.currentViews.removeAtIndex(0)
            self.currentIndex += 1
        
            self.loadNextView()
        
            UIView.animateWithDuration(0.35, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations:  {
            
                view.center = CGPointMake(view.center.x, (self.frame.size.height * 1.5));
                self.cardViewDefaultScale()
            
                }, completion: { finished in
                
                }
            )
        }
    }
    
    
}
