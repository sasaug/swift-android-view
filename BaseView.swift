//
//  View.swift
//  SpeedRent
//
//  Created by sasaug on 7/6/15.
//  Copyright (c) 2015 speedrent. All rights reserved.
//

import Foundation
import UIKit

let WRAP_CONTENT:CGFloat = -1
let MATCH_PARENT:CGFloat = -2


class BaseView{
    var id:Int = -1
    
    var view:UIView!
    
    var width:CGFloat = WRAP_CONTENT
    var height:CGFloat = WRAP_CONTENT
    
    var __x:CGFloat = 0
    var _x: CGFloat {
        get {
            let v = view as? UIBaseView
            if(v != nil){
                return v!._x
            }else{
                return self.__x
            }
        }
        set {
            let v = view as? UIBaseView
            if(v != nil){
                v!._x = newValue
            }else{
                self.__x = newValue
            }
        }
    }
    
    var __y:CGFloat = 0
    var _y: CGFloat {
        get {
            let v = view as? UIBaseView
            if(v != nil){
                return v!._y
            }else{
                return self.__y
            }
        }
        set {
            let v = view as? UIBaseView
            if(v != nil){
                v!._y = newValue
            }else{
                self.__y = newValue
            }
        }
    }
    
    var __w:CGFloat = 0
    var _w: CGFloat {
        get {
            let v = view as? UIBaseView
            if(v != nil){
                return v!._w
            }else{
                return self.__w
            }
        }
        set {
            let v = view as? UIBaseView
            if(v != nil){
                v!._w = newValue
            }else{
                self.__w = newValue
            }
        }
    }
    
    var __h:CGFloat = 0
    var _h: CGFloat {
        get {
            let v = view as? UIBaseView
            if(v != nil){
                return v!._h
            }else{
                return self.__h
            }
        }
        set {
            let v = view as? UIBaseView
            if(v != nil){
                v!._h = newValue
            }else{
                self.__h = newValue
            }
        }
    }
    
    /*var _y:CGFloat = 0;
    var _w:CGFloat = 0;
    var _h:CGFloat = 0;*/
    
    var marginLeft:CGFloat = 0;
    var marginRight:CGFloat = 0;
    var marginTop:CGFloat = 0;
    var marginBottom:CGFloat = 0;
    
    init(view:UIView, width:CGFloat, height:CGFloat){
        self.view = view;
        self.width = width;
        self.height = height;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func id(id:Int)->BaseView{
        self.id = id
        return self
    }
    
    func margin(left:CGFloat=0, right:CGFloat=0, top:CGFloat=0, bottom:CGFloat=0)->BaseView{
        self.marginLeft = left
        self.marginRight = right
        self.marginTop = top
        self.marginBottom = bottom
        return self
    }
    
    static func getViewFrame(view:UIView) -> (x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat){
        let x = view.frame.origin.x;
        let y = view.frame.origin.y;
        let w = view.frame.width;
        let h = view.frame.height;
        return (x, y, w, h)
    }
}

extension CGFloat{
    var auto: CGFloat {
        var scale = UIScreen.mainScreen().scale
        
        if(UIDevice.currentDevice().userInterfaceIdiom == .Pad){
            
            if(scale != 3){
                scale += 1
            }
            return self / 2 * scale
        }else{
            if(scale == 3){
                scale -= 1
            }
            
            return self / 2 * scale;
        }
    }
}

extension Int{
    var auto: CGFloat {
        var scale = UIScreen.mainScreen().scale
        
        if(UIDevice.currentDevice().userInterfaceIdiom == .Pad){
            
            if(scale != 3){
                scale += 1
            }
            return CGFloat(self) / 2 * scale
        }else{
            if(scale == 3){
                scale -= 1
            }
            
            return CGFloat(self) / 2 * scale;
        }
    }
}