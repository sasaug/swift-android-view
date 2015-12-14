//
//  View.swift
//  SpeedRent
//
//  Created by sasaug on 7/6/15.
//  Copyright (c) 2015 speedrent. All rights reserved.
//

import Foundation
import UIKit

class UIBaseView:UIView{
    var width:CGFloat = WRAP_CONTENT
    var height:CGFloat = WRAP_CONTENT
    
    var _x:CGFloat = 0;
    var _y:CGFloat = 0;
    var _w:CGFloat = 0;
    var _h:CGFloat = 0;
    
    var marginLeft:CGFloat = 0;
    var marginRight:CGFloat = 0;
    var marginTop:CGFloat = 0;
    var marginBottom:CGFloat = 0;
    
    var paddingLeft:CGFloat = 0;
    var paddingRight:CGFloat = 0;
    var paddingTop:CGFloat = 0;
    var paddingBottom:CGFloat = 0;
    
    var isDebugging = false
    var willDebugAffectChildren = false
    let DEBUG_COLORS_TAG:[String] = ["Red", "Purple", "Blue", "Green", "Orange"]
    let DEBUG_COLORS:[UIColor] = [UIColor(red:CGFloat(244/255.0), green:CGFloat(67/255.0), blue:CGFloat(54/255.0), alpha:CGFloat(0.4)),
        UIColor(red:CGFloat(156/255.0), green:CGFloat(39/255.0), blue:CGFloat(176/255.0), alpha:CGFloat(0.4)),
        UIColor(red:CGFloat(63/255.0), green:CGFloat(81/255.0), blue:CGFloat(181/255.0), alpha:CGFloat(0.4)),
        UIColor(red:CGFloat(76/255.0), green:CGFloat(175/255.0), blue:CGFloat(80/255.0), alpha:CGFloat(0.4)),
        UIColor(red:CGFloat(255/255.0), green:CGFloat(152/255.0), blue:CGFloat(0/255.0), alpha:CGFloat(0.4))]
    
    
    init(width:CGFloat, height:CGFloat){
        super.init(frame: CGRectMake(0,0,0,0))
        self.width = width
        self.height = height
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func width(width:CGFloat)->UIBaseView{
        self.width = width
        return self
    }
    
    func height(height:CGFloat)->UIBaseView{
        self.height = height
        return self
    }
    
    func margin(left:CGFloat=0, right:CGFloat=0, top:CGFloat=0, bottom:CGFloat=0)->UIBaseView{
        self.marginLeft = left
        self.marginRight = right
        self.marginTop = top
        self.marginBottom = bottom
        return self
    }
    
    func padding(left:CGFloat=0, right:CGFloat=0, top:CGFloat=0, bottom:CGFloat=0)->UIBaseView{
        self.paddingLeft = left
        self.paddingRight = right
        self.paddingTop = top
        self.paddingBottom = bottom
        return self
    }
    
    func calculateView(parent:UIBaseView?){}
    
    func build(make:Bool=true)->UIView{
        return self
    }
    
    func debugAll()->UIBaseView{
        self.willDebugAffectChildren = true
        return debug();
    }
    
    func debug()->UIBaseView{
        self.isDebugging = true
        return self
    }
}