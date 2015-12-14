//
//  LinearLayout.swift
//  SpeedRent
//
//  Created by sasaug on 7/8/15.
//  Copyright (c) 2015 speedrent. All rights reserved.
//

import Foundation
import UIKit
class LinearLayoutView:BaseView{
    var weight:Float = 1
    var gravity = LinearLayout.LEFT
    
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
    
    func gravity(value:Int)->LinearLayoutView{
        self.gravity = value
        return self
    }
    
    func weight(value:Float)->LinearLayoutView{
        self.weight = value
        return self
    }
    
    override func margin(left:CGFloat=0, right:CGFloat=0, top:CGFloat=0, bottom:CGFloat=0)->LinearLayoutView{
        super.margin(left, right: right, top: top, bottom: bottom)
        return self
    }
}
class LinearLayout: UIBaseView {
    static let LEFT:Int = 1
    static let RIGHT:Int = 2
    static let TOP:Int = 3
    static let BOTTOM:Int = 4
    static let CENTER:Int = 5
    static let LEFT_TOP:Int = 10
    static let RIGHT_TOP:Int = 11
    static let LEFT_BOTTOM:Int = 12
    static let RIGHT_BOTTOM:Int = 13
    static let LEFT_CENTER:Int = 14
    static let RIGHT_CENTER:Int = 15
    static let TOP_CENTER:Int = 20
    static let BOTTOM_CENTER:Int = 21
    
    var autoBuild = true
    var forceBuild = false
    var orientation = true	//true = horizontal, false = vertical
    var weightSum:Float = 1;
    
    var views:[LinearLayoutView] = []
    
    override init(width:CGFloat, height:CGFloat){
        super.init(width: width, height: height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func margin(left:CGFloat=0, right:CGFloat=0, top:CGFloat=0, bottom:CGFloat=0)->LinearLayout{
        super.margin(left, right: right, top: top, bottom: bottom)
        return self
    }
    
    override func padding(left:CGFloat=0, right:CGFloat=0, top:CGFloat=0, bottom:CGFloat=0)->LinearLayout{
        super.padding(left, right: right, top: top, bottom: bottom)
        return self
    }
    
    func horizontal() -> LinearLayout{
        orientation = true
        return self
    }
    
    func vertical()-> LinearLayout{
        orientation = false
        return self
    }
    
    func autoBuild(enable:Bool)->LinearLayout{
        autoBuild = enable
        return self
    }
    
    func forceBuild(enable:Bool)->LinearLayout{
        forceBuild = enable
        return self
    }
    
    override func debug()->LinearLayout{
        super.debug()
        return self
    }
    
    override func debugAll()->LinearLayout{
        super.debugAll()
        return self
    }
    
    func weightSum(weight:Float)-> LinearLayout{
        self.weightSum = weight
        return self
    }
    
    
    func add(view:UIView, w:CGFloat? = CGFloat(-99), h:CGFloat? = CGFloat(-99)) -> LinearLayoutView{
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
        
        let vc = LinearLayoutView(view: view, width: nw, height: nh)
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
            if(isDebugging && willDebugAffectChildren){
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
                if(parent != self){
                    _w = parentW - (marginLeft + marginRight) - (parent!.paddingLeft + parent!.paddingRight)
                }else{
                    _w = parentW
                }
            }else if(width != WRAP_CONTENT){
                _w = CGFloat(width)
            }else{
                _w = 0
            }
            
            if(height == MATCH_PARENT){
                if(parent != self){
                    _h = parentH - (marginTop +  marginBottom) - (parent!.paddingTop + parent!.paddingBottom)
                }else{
                    _h = parentH
                }
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
            var prev:LinearLayoutView!
            if( i != 0){
                var c = 1;
                prev = views[i-c]
                while(prev.view!.hidden){
                    c++;
                    if(i-c >= 0){
                        prev = views[i-c]
                    }else{
                        prev = nil;
                        break;
                    }
                    
                }
            }
            
            if(vc.view!.hidden){
                continue;
            }
            
            var x:CGFloat = 0
            var y:CGFloat = 0
            var w:CGFloat = vc._w
            var h:CGFloat = vc._h
            
            //attempt to calculate subview if there are UIBaseView or UIScrollView
            var uiBaseView = vc.view as? UIBaseView
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
            
            
            if(prev != nil){
                if(orientation){	//horizontal
                    x = prev._x + prev._w + prev.marginRight + vc.marginLeft
                    y = paddingTop + vc.marginTop
                    
                }else{	//vertical
                    x = paddingLeft + vc.marginLeft
                    y = prev._y + prev._h + prev.marginBottom + vc.marginTop
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
                
                if(vc.weight < 1 && vc.weight >= 0){
                    if(orientation){
                        w = (_w - paddingLeft - paddingRight) * CGFloat(vc.weight)
                    }else{
                        h = (_h - paddingTop - paddingBottom) * CGFloat(vc.weight)
                    }
                }
            }else{
                x = paddingLeft + vc.marginLeft
                y = paddingTop + vc.marginTop
                
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
                
                if(vc.weight < 1 && vc.weight >= 0){
                    if(orientation){
                        w = (_w - paddingLeft - paddingRight) * CGFloat(vc.weight)
                    }else{
                        h = (_h - paddingTop - paddingBottom) * CGFloat(vc.weight)
                    }
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
            
            //sync the coordinates back
            vc._x = x;
            vc._y = y;
            vc._w = w;
            vc._h = h;
            
            //attempt to calculate subview if there are UIBaseView or UIScrollView
            uiBaseView = vc.view as? UIBaseView
            if(uiBaseView != nil){
                uiBaseView!.calculateView(uiBaseView);
            }else{
                let uiScrollView = vc.view as? UIScrollView
                if(uiScrollView != nil){
                    //try to get subviews in uiScrollView to build
                    var h:CGFloat = 0;
                    
                    for(var j = 0; j < uiScrollView!.subviews.count; j++){
                        let v = uiScrollView!.subviews[j] as? UIBaseView
                        if(v != nil){
                            v!.calculateView(self);
                            h += v!.marginTop + v!.marginBottom + v!._h
                        }
                    }
                    
                    h += 20;
                    uiScrollView!.contentSize = CGSizeMake(0, h);
                }
            }
            
        }
        
        //calculate alignment (post parent frame resize)
        for(var i = 0; i < views.count; i++){
            let vc = views[i];
            if(vc.view!.hidden){
                continue;
            }
            var x:CGFloat = vc._x
            var y:CGFloat = vc._y
            let w:CGFloat = vc._w
            let h:CGFloat = vc._h
            
            //calculate allowed frame area
            var mw:CGFloat = x+w;
            var mh:CGFloat = y+h;
            
            if(orientation){//hr
                if(i == views.count-1){     //check if last view
                    mw = _w - paddingRight
                }
                mh = _h - paddingBottom;
            }else{
                if(i == views.count-1){     //check if last view
                    mh = _h - paddingBottom
                }
                mw = _w - paddingRight;
            }
            
            if(vc.gravity == LinearLayout.LEFT || vc.gravity == LinearLayout.TOP || vc.gravity == LinearLayout.LEFT_TOP){
                //default
            }
            if(vc.gravity == LinearLayout.RIGHT || vc.gravity == LinearLayout.RIGHT_TOP || vc.gravity == LinearLayout.RIGHT_BOTTOM ||  vc.gravity == LinearLayout.RIGHT_CENTER){
                x = mw - vc.marginRight - paddingRight - w + paddingLeft + vc.marginLeft;
            }
            if(vc.gravity == LinearLayout.BOTTOM ||  vc.gravity == LinearLayout.LEFT_BOTTOM || vc.gravity == LinearLayout.RIGHT_BOTTOM || vc.gravity == LinearLayout.BOTTOM_CENTER){
                y = mh - vc.marginBottom - paddingBottom - h + paddingTop + vc.marginTop;
            }
            if(vc.gravity == LinearLayout.CENTER){
                x += ((mw - x)/2)-(w/2)
                y += ((mh - y)/2)-(h/2)
            }
            if(vc.gravity == LinearLayout.LEFT_CENTER || vc.gravity == LinearLayout.RIGHT_CENTER){
                y += ((mh - y)/2)-(h/2)
            }
            if(vc.gravity == LinearLayout.TOP_CENTER || vc.gravity == LinearLayout.BOTTOM_CENTER){
                x += ((mw - x)/2)-(w/2)
            }
            
            //sync the coordinates back
            vc._x = x;
            vc._y = y;
            vc._w = w;
            vc._h = h;
        }
    }
    
    func createScrollable()->RelativeLayout{
        let rl = RelativeLayout(width: MATCH_PARENT, height: MATCH_PARENT).hostScrollView()
        rl.scrollView.addSubview(self)
        return rl
    }
}