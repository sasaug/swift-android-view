# swift-android-view

This is a minimal port of Android layout library for iOS, written in Swift 2.

In Android, LinearLayout and RelativeLayout are the core layout view which capable of producing any sort of layout for your UI needs.

This library had been rewritten once, which focus on several performance improvement and easier handling. 

It is currently powering Speedrent iOS App(http://speedrent.com)

# Usage
##LinearLayout
```
//declare a LinearLayout and set it's orientation to vertical, set the padding of left & right to 5 as well
let ll = LinearLayout(width: MATCH_PARENT, height: MATCH_PARENT).vertical().padding(5, right : 5)
//add a UILabel
ll.add(UILabel(), w: MATCH_PARENT, h: WRAP_CONTENT)
//add UIImageView, redefined the height to 200 and add 15 margin to top
ll.add(UIImageView(), w: MATCH_PARENT, h: 200).margin(top: 15)
//add a UIButton with redefined size, and center it. Remember to make ll's height to WRAP_CONTENT if you don't want it to center on the remainder of the layout
ll.add(UIButton(), w: 200, h: 50).gravity(LinearLayout.CENTER)
//add the LinearLayout to the ViewController's view 
view.addSubview(ll)
```

##RelativeLayout
```
//declare a RelativeLayout and set the padding of left, right, top & bottom to 30
let rl = RelativeLayout(width: MATCH_PARENT, height: MATCH_PARENT).padding(30, right : 30, top: 30, bottom: 30)
//add a UILabel and set it to bottom of RelativeLayout, set viewId to 1 so we can refer to it later on. 
rl.add(UILabel(), w: MATCH_PARENT, h: 20).alignParentBottom(true).id(1)
//add a UILabel, set it to above layoutId 1. MATCH_PARENT can ensure it use up the remaining spaces
rl.add(UILabel(), w: MATCH_PARENT, h: MATCH_PARENT).above(1)
//add the RinearLayout to the ViewController's view 
view.addSubview(rl)
```

#Functions
```
//LinearLayout
.add(view:UIView, w:CGFloat?=WRAP_CONTENT, h:CGFloat?=WRAP_CONTENT)->LinearLayoutView
.margin(left:CGFloat, right:CGFloat, top: CGFloat, bottom: CGFloat)->LinearLayoutView
.padding(left:CGFloat, right:CGFloat, top: CGFloat, bottom: CGFloat)->LinearLayoutView
.createScrollable()->RelativeLayout

//LinearLayoutView
.margin(left:CGFloat, right:CGFloat, top: CGFloat, bottom: CGFloat)->LinearLayoutView
.gravity(value:int)->LinearLayoutView	//CENTER, LEFT, RIGHT, TOP, BOTTOM, LEFT_CENTER, RIGHT_CENTER, TOP_CENTER, BOTTOM_CENTER
.weight(value:Double)->LinearLayoutView (LinearLayout total weight is 1, so use 0 to 1 for this value)

//RelativeLayout
.add(view:UIView, w:CGFloat?=WRAP_CONTENT, h:CGFloat?=WRAP_CONTENT)->RelativeLayoutView
.margin(left:CGFloat, right:CGFloat, top: CGFloat, bottom: CGFloat)->RelativeLayoutView
.padding(left:CGFloat, right:CGFloat, top: CGFloat, bottom: CGFloat)->RelativeLayoutView
.createScrollable()->RelativeLayout

//RelativeLayoutView
.margin(left:CGFloat, right:CGFloat, top: CGFloat, bottom: CGFloat)->RelativeLayoutView
.centerMode(int:Int)->RelativeLayoutView	//CENTER, CENTER_HORIZONTAL, CENTER_VERTICAL
.alignParentTop(value:Bool)->RelativeLayoutView
.alignParentBottom(value:Bool)->RelativeLayoutView
.alignParentLeft(value:Bool)->RelativeLayoutView
.alignParentRight(value:Bool)->RelativeLayoutView
.above(id:Int)->RelativeLayoutView
.bottom(id:Int)->RelativeLayoutView
.leftOf(id:Int)->RelativeLayoutView
.rightOf(id:Int)->RelativeLayoutView

```

#More Examples
You can have nested layout, as much as you like
```
let label = UILabel();
label.text = "Hello World"
let image = UIImageView();
image.image = UIImage(named: "apple")
let main = RelativeLayout(width: MATCH_PARENT, height: MATCH_PARENT).padding(5, right: 5, top: 5, bottom: 5)
let rl = RelativeLayout(width: MATCH_PARENT, height: MATCH_PARENT)
let ll = LinearLayout(width: MATCH_PARENT, height: WRAP_CONTENT).vertical()
ll.add(image, w: 200, h: 200).gravity(LinearLayout.CENTER)
ll.add(label, w: 100, h: 50).gravity(LinearLayout.CENTER)
rl.add(ll)	//rl will read ll's width and height instead of setting it to WRAP_CONTENT(default)
main.add(rl);
view.addSubview(main)
```

Quickly enable scrolling in layout(wrapped in UIScrollView)
```
//e.g: view controller view is only 500px in height
let main = LinearLayout(width: MATCH_PARENT, height: 1000)
view.addSubview(main.createScrollable())
```

Using weight in LinearLayout
```
let ll = LinearLayout(width: MATCH_PARENT, height: WRAP_CONTENT)
ll.add(UIlabel(), h: 20).weight(0.4)
ll.add(UIlabel(), h: 20).weight(0.6)
view.addSubview(ll)
```

#Note
- LinearLayout and RelativeLayout extends UIView, but not LinearLayoutView/RelativeLayoutView(they are just container, should rework on naming)
- UIView that have .hidden = true, will be ignored (it won't be built so frame might be wrong)
- AutoBuild is enabled by default. The layout will build when you attached it to a view. You can rebuild the layout(e.g after you call sizeToFit for UILabel) by calling .build()
- If you need the layout to build without attaching to any parent and there is no MATCH_PARENT used, enable forceBuild() and then call .build(). Use this if you know what you are doing.

#Known limitation
- The added UIView will not have padding feature (this was in previous version but now removed, abuse margin instead)
- Predefine LinearLayout/RelativeLayout width when used in UITableViewCell(set it to screen width) rather than using MATCH_PARENT. Somehow the width provided by UITableViewCell's view pre-drawing is always 320(iOS fault).
- Avoid RelativeLayout positioning feature if you can(those above/bottom/leftOf/rightOf) as it's not properly written (chaining these together might cause bug)

