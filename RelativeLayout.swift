//
//  RelativeLayout.swift
//  SpeedRent
//
//  Created by sasaug on 7/8/15.
//  Copyright (c) 2015 speedrent. All rights reserved.
//

import Foundation
import UIKit
class RelativeLayoutView:BaseView{
    var centerMode = RelativeLayout.CENTER_NONE
    var alignParentLeft = false
    var alignParentRight = false
    var alignParentTop = false
    var alignParentBottom = false
    
    var below = -1;
    var above = -1;
    var leftOf = -1;
    var rightOf = -1;

    override init(view: UIView, width:CGFloat, height:CGFloat){
        super.init(view: view, width: width, height: height)
        
        let v = view as? UIBaseView
        if(v != nil){   //we fetch all the margin data from child if it had any
            self.marginLeft = v!.marginLeft
            self.marginRight = v!.marginRight
            self.marginTop = v!.marginTop
            self.marginTop = v!.marginTop
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func centerMode(value: Int)->RelativeLayoutView{
        self.centerMode = value
        return self
    }
    
    func alignParentLeft(value: Bool)->RelativeLayoutView{
        self.alignParentLeft = value
        return self
    }
    
    func alignParentRight(value: Bool)->RelativeLayoutView{
        self.alignParentRight = value
        return self
    }
    
    func alignParentTop(value: Bool)->RelativeLayoutView{
        self.alignParentTop = value
        return self
    }
    
    func alignParentBottom(value: Bool)->RelativeLayoutView{
        self.alignParentBottom = value
        return self
    }
    
    override func margin(left:CGFloat=0, right:CGFloat=0, top:CGFloat=0, bottom:CGFloat=0)->RelativeLayoutView{
        super.margin(left, right: right, top: top, bottom: bottom)
        return self
    }
    
    func below(id: Int)->RelativeLayoutView{
        self.below = id
        return self
    }
    
    func above(id: Int)->RelativeLayoutView{
        self.above = id
        return self
    }
    
    func leftOf(id: Int)->RelativeLayoutView{
        self.leftOf = id
        return self
    }
    
    func rightOf(id: Int)->RelativeLayoutView{
        self.rightOf = id
        return self
    }
}

class RelativeLayout:UIBaseView{
    static let CENTER_NONE = 0
    static let CENTER_HORIZONTAL = 1
    static let CENTER_VERTICAL = 2
    static let CENTER_PARENT = 3
    
    var autoBuild = true
    var forceBuild = false
    var views:[RelativeLayoutView] = []
    
    var scrollView:UIScrollView!
    
    override init(width:CGFloat, height:CGFloat){
        super.init(width: width, height: height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func margin(left:CGFloat=0, right:CGFloat=0, top:CGFloat=0, bottom:CGFloat=0)->RelativeLayout{
        super.margin(left, right: right, top: top, bottom: bottom)
        return self
    }
    
    override func padding(left:CGFloat=0, right:CGFloat=0, top:CGFloat=0, bottom:CGFloat=0)->RelativeLayout{
        super.padding(left, right: right, top: top, bottom: bottom)
        return self
    }
    
    func hostScrollView()->RelativeLayout{
        scrollView = UIScrollView();
        add(scrollView, w: MATCH_PARENT, h: MATCH_PARENT)
        return self
    }
    
    func autoBuild(enable:Bool)->RelativeLayout{
        autoBuild = enable
        return self
    }
    
    func forceBuild(enable:Bool)->RelativeLayout{
        forceBuild = enable
        return self
    }
    
    override func debug()->RelativeLayout{
        super.debug()
        return self
    }
    
    override func debugAll()->RelativeLayout{
        super.debugAll()
        return self
    }
    
    func add(view:UIView, w:CGFloat? = CGFloat(-99), h:CGFloat? = CGFloat(-99)) -> RelativeLayoutView{
        var nw = w!
        var nh = h!
        
        let v = view as? UIBaseView
        if(w! == -99){
            nw = WRAP_CONTENT
            if(v != nil){
                nw = v!.width
            }
        }
        
        if(h! == -99){
            nh = WRAP_CONTENT
            if(v != nil){
                nh = v!.height
            }
        }
        
        let vc = RelativeLayoutView(view: view, width: nw, height: nh)
        if(superview != nil){
            print("Error: This view already have a parent!")
        }else{
            views.append(vc)
        }
        return vc
    }
    
    override func didMoveToSuperview(){
        super.didMoveToSuperview()
        
        if(!autoBuild){
            let f = BaseView.getViewFrame(self)
            if(f.width == 0 && f.height == 0){
                print("Warning: Remember to call build() as auto build had been disabled.")
            }
            return
        }
        
        //if superview is not nil then we build it
        if(superview != nil){
            let v = superview! as? UIBaseView
            if(v != nil){
                return;
            }
            build()
        }
    }
    
    override func build(make:Bool=true)->UIView{
        if(make){
            let parentView = super.superview
            if(parentView == nil && !forceBuild){
                print("Error: Can't build base view due to lack of parent. Attach this view to a parent first.")
                return self;
            }
            
            //calculate view
            calculateView(nil);
            
            //build parent
            self.frame = CGRectMake(_x, _y, _w, _h);
        }
        
        //clear all subview first
        self.subviews.map({ $0.removeFromSuperview() })
        
        if(isDebugging){
            let index = random()%DEBUG_COLORS.count
            self.layer.backgroundColor = DEBUG_COLORS[index].CGColor
            print(DEBUG_COLORS_TAG[index] + " = " + String(BaseView.getViewFrame(self)))
        }
        
        //build subviews
        for(var i = 0; i < views.count; i++){
            let vc = views[i]
            let view = vc.view!
            if(view.hidden){
                continue;
            }
            view.frame = CGRectMake(vc._x, vc._y, vc._w, vc._h)
            if(isDebugging){
                let index = random()%DEBUG_COLORS.count
                view.layer.backgroundColor = DEBUG_COLORS[index].CGColor
                print(DEBUG_COLORS_TAG[index] + " = " + String(BaseView.getViewFrame(view)))
            }
            
            let v = view as? UIBaseView
            if(v != nil){
                if(isDebugging && willDebugAffectChildren){
                    v!.debug();
                }
                v!.build(false)
            }else{
                let uiScrollView = view as? UIScrollView
                if(uiScrollView != nil){
                    if(isDebugging && willDebugAffectChildren){
                        let index = random()%DEBUG_COLORS.count
                        view.layer.backgroundColor = DEBUG_COLORS[index].CGColor
                        print(DEBUG_COLORS_TAG[index] + " = " + String(BaseView.getViewFrame(view)))
                    }
                    
                    //try to get subviews in uiScrollView to build
                    for(var j = 0; j < uiScrollView!.subviews.count; j++){
                        let v = uiScrollView!.subviews[j] as? UIBaseView
                        if(v != nil){
                            if(isDebugging && willDebugAffectChildren){
                                v!.debug();
                            }
                            v!.frame = CGRectMake(v!._x, v!._y, v!._w, v!._h);
                            v!.build(false)
                        }
                    }
                }
            }
            
            
            addSubview(view)
        }
        return self
    }
    
    override func calculateView(parent:UIBaseView?=nil){
        //generate parent frame, if any
        var parentW:CGFloat = 0;
        var parentH:CGFloat = 0;
        if(parent != nil){
            parentW = parent!._w;
            parentH = parent!._h;
            
            if(width == MATCH_PARENT){
                _w = parentW - (marginLeft + marginRight)   
            }else if(width != WRAP_CONTENT){
                _w = CGFloat(width)
            }else{
                _w = 0
            }
            
            if(height == MATCH_PARENT){
                _h = parentH - (marginTop +  marginBottom) - (parent!.paddingTop + parent!.paddingBottom)
            }else if(height != WRAP_CONTENT){
                _h = CGFloat(height)
            }else{
                _h = 0
            }
        }else{
            let parentView = super.superview
            if(parentView != nil){
                let parentFrame = BaseView.getViewFrame(parentView!)
                parentW = parentFrame.width;
                parentH = parentFrame.height;
            }
            
            if(width == MATCH_PARENT){
                if(parentView == nil){
                    print("Error: Parent is nil but MATCH_PARENT is used. Please disabled forceBuild.")
                }
                _w = parentW - (marginLeft + marginRight)
            }else if(width != WRAP_CONTENT){
                _w = CGFloat(width)
            }else{
                _w = 0
            }
            
            if(height == MATCH_PARENT){
                if(parentView == nil){
                    print("Error: Parent is nil but MATCH_PARENT is used. Please disabled forceBuild.")
                }
                _h = parentH - (marginTop + marginBottom)
            }else if(height != WRAP_CONTENT){
                _h = CGFloat(height)
            }else{
                _h = 0
            }
        }
        
        //loop through all subviews
        for(var i = 0; i < views.count; i++){
            let vc = views[i]
            
            if(vc.view!.hidden){
                continue;
            }
            
            var x:CGFloat = vc.marginLeft + paddingLeft
            var y:CGFloat = vc.marginTop + paddingTop
            var w:CGFloat = vc._w
            var h:CGFloat = vc._h
            
            //attempt to calculate subview if there are UIBaseView or UIScrollView
            //1st iteration to handle WRAP_CONTENT case
            let uiBaseView = vc.view as? UIBaseView
            if(uiBaseView != nil){
                uiBaseView!.calculateView(self);
            }else{
                let uiScrollView = vc.view as? UIScrollView
                if(uiScrollView != nil){
                    //try to get subviews in uiScrollView to build
                    var height:CGFloat = 0;
                    
                    for(var j = 0; j < uiScrollView!.subviews.count; j++){
                        let v = uiScrollView!.subviews[j] as? UIBaseView
                        if(v != nil){
                            v!.calculateView(self);
                            height += v!.marginTop + v!.marginBottom + v!._h
                        }
                    }
                    
                    height += 20;
                    uiScrollView!.contentSize = CGSizeMake(0, height);
                }
            }
            
            if(vc.width == MATCH_PARENT){
                w = _w - x - paddingRight - vc.marginRight
            }else if(vc.width == WRAP_CONTENT){
                let baseView = vc.view as? UIBaseView
                if(baseView != nil){
                    w = baseView!._w
                }else{
                    w = vc.view.frame.width
                }
            }else{
                w = vc.width
            }
            
            if(vc.height == MATCH_PARENT){
                h = _h - y - paddingBottom - vc.marginBottom
            }else if(vc.height == WRAP_CONTENT){
                let baseView = vc.view as? UIBaseView
                if(baseView != nil){
                    h = baseView!._h
                }else{
                    h = vc.view.frame.height
                }
            }else{
                h = vc.height
            }
            
            //attempt to calculate subview if there are UIBaseView or UIScrollView
            //2nd iteration to handle MATCH_PARENT case
            if(uiBaseView != nil){
                uiBaseView!.calculateView(self);
            }else{
                let uiScrollView = vc.view as? UIScrollView
                if(uiScrollView != nil){
                    //try to get subviews in uiScrollView to build
                    var height:CGFloat = 0;
                    
                    for(var j = 0; j < uiScrollView!.subviews.count; j++){
                        let v = uiScrollView!.subviews[j] as? UIBaseView
                        if(v != nil){
                            v!.calculateView(self);
                            height += v!.marginTop + v!.marginBottom + v!._h
                        }
                    }
                    
                    height += 20;
                    uiScrollView!.contentSize = CGSizeMake(0, height);
                }
            }
            
            //resize parent if needed
            if(width == WRAP_CONTENT){
                let val = x + w + paddingRight + vc.marginRight;
                if(val > _w){
                    _w = val;
                }
            }
            
            if(height == WRAP_CONTENT){
                let val = y + h + paddingBottom + vc.marginBottom;
                if(val > _h){
                    _h = val;
                }
            }
            
            //adjusting alignment
            if(vc.centerMode == RelativeLayout.CENTER_HORIZONTAL){
                x = (_w/2) - (w/2)
            }else if(vc.centerMode == RelativeLayout.CENTER_VERTICAL){
                y = (_h/2) - (h/2)
            }else if(vc.centerMode == RelativeLayout.CENTER_PARENT){
                x = (_w/2) - (w/2)
                y = (_h/2) - (h/2)
            }
            
            if(vc.alignParentLeft){
                x = paddingLeft + vc.marginLeft;
            }
            
            if(vc.alignParentRight){
                x = _w - vc.marginRight - paddingRight - w;
            }
            
            if(vc.alignParentTop){
                y = paddingTop + vc.marginTop
            }
            
            if(vc.alignParentBottom){
                y = _h - vc.marginBottom - paddingBottom - h;
            }
            
            if(vc.above != -1){
                let id = vc.above
                for(var j = 0; j < views.count; j++){
                    let _vc = views[j]
                    if(_vc.id == id){
                        y = _vc._y - _vc.marginTop - vc.marginBottom - h
                        if(vc.height == MATCH_PARENT){
                            let value = vc.marginTop + paddingTop;
                            if(y < value){
                                y = value;
                                h = _vc._y - _vc.marginTop - vc.marginBottom - y;
                            }
                        }
                        break;
                    }
                }
            }
            
            if(vc.below != -1){
                let id = vc.below
                for(var j = 0; j < views.count; j++){
                    let _vc = views[j]
                    if(_vc.id == id){
                        y = _vc._y  + _vc._h + _vc.marginBottom + vc.marginTop
                        if(vc.height == MATCH_PARENT){
                            let value = y + h + vc.marginBottom + paddingBottom;
                            if(value > parentH){
                                h = parentH - vc.marginBottom - paddingBottom;
                            }
                        }
                        break;
                    }
                }
            }
            
            if(vc.leftOf != -1){
                let id = vc.leftOf
                for(var j = 0; j < views.count; j++){
                    let _vc = views[j]
                    if(_vc.id == id){
                        x = _vc._x - _vc.marginLeft - vc.marginRight - w
                        if(vc.width == MATCH_PARENT){
                            let value = vc.marginLeft + paddingLeft;
                            if(x < value){
                                x = value;
                                w = _vc._x - _vc.marginLeft - vc.marginRight - x;
                            }
                        }
                        break;
                    }
                }
            }
            
            if(vc.rightOf != -1){
                let id = vc.rightOf
                for(var j = 0; j < views.count; j++){
                    let _vc = views[j]
                    if(_vc.id == id){
                        x = _vc._x  + _vc._w + _vc.marginRight + vc.marginLeft
                        if(vc.width == MATCH_PARENT){
                            let value = x + w + vc.marginRight + paddingRight;
                            if(value > parentH){
                                h = parentW - vc.marginRight - paddingRight;
                            }
                        }
                        break;
                    }
                }
            }
            
            //sync the coordinates back
            vc._x = x;
            vc._y = y;
            vc._w = w;
            vc._h = h;
            
            //attempt to calculate subview if there are UIBaseView or UIScrollView
            //3rd iteration to handle alignment changes
            if(uiBaseView != nil){
                uiBaseView!.calculateView(uiBaseView);
            }else{
                let uiScrollView = vc.view as? UIScrollView
                if(uiScrollView != nil){
                    //try to get subviews in uiScrollView to build
                    var height:CGFloat = 0;
                    
                    for(var j = 0; j < uiScrollView!.subviews.count; j++){
                        let v = uiScrollView!.subviews[j] as? UIBaseView
                        if(v != nil){
                            v!.calculateView(self);
                            height += v!.marginTop + v!.marginBottom + v!._h
                        }
                    }
                    
                    height += 20;
                    uiScrollView!.contentSize = CGSizeMake(0, height);
                }
            }
        }
        
    }
    
    func createScrollable()->RelativeLayout{
        let rl = RelativeLayout(width: MATCH_PARENT, height: MATCH_PARENT).hostScrollView()
        rl.scrollView.addSubview(self)
        return rl
    }
}