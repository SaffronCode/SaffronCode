/**
 * Created by mes on 6/18/2017.
 */
package starlingPack.core {
import flash.geom.Point;
import flash.geom.Rectangle;

import starling.core.Starling;

import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

import starlingPack.event.StarlingZoomEvent;

public class StarlingZoomer {

    private var mySprite:Sprite,
                area:Rectangle;

    private var touchList:Vector.<Touch>,
                lastPose:Vector.<Point>;

    public static var maxZoomScale:Number = 20 ;

    private var targetX:Number,targetY:Number,targetScale:Number;

    private var firstScale:Number,firstWidth:Number,firstHeight:Number ;

    /**0 is the reseted distance*/
    private var lastTwoPointsDistance:Number = 0 ;

    private var lock:Boolean = false,
                unlockOnTouchUp:Boolean = false ;

    public function StarlingZoomer(zoomableObject:Sprite) {
        if(Starling.multitouchEnabled==false)
        {
            trace("You should set Starling.multitouchEnabled = true  before creating starling instance on the main class.");
        }
        mySprite = zoomableObject ;
        mySprite.addEventListener(StarlingZoomEvent.LOCK_UNTIL_TOUCH_UP,lockUntilTouchUp);
    }

    private function lockUntilTouchUp(event:StarlingZoomEvent):void {
        lock = true ;
        unlockOnTouchUp = true ;
        removeTouch();
    }

    /**Clear touch list*/
    private function clearTouchList():void
    {
        lastPose = new Vector.<Point>();
        touchList = new Vector.<Touch>();
    }

    private function animateFloor(e:Event):void
    {

        var deltaX:Number = 0 ,
            deltaY:Number = 0 ;

        var scale:Number = 1 ;

        var l:int = touchList.length ;

        var lastScale:Number = mySprite.scale ;

        for(var i:int = 0 ; i<l ; i++)
        {
            var currentPose:Point = touchToPoint(touchList[i]);
            //trace("Global touch point is  "+i+" is : "+touchList[i].getLocation(mySprite)+' vs '+mySprite.width/mySprite.scaleX);
            deltaX += currentPose.x-lastPose[i].x ;
            deltaY += currentPose.y-lastPose[i].y ;

            lastPose[i] = currentPose ;
        }


        if(l>=2)
        {
            //var point1:Point = touchToPoint(touchList[0]);
           // var point2:Point = touchToPoint(touchList[1]);

            var relativePoint1:Point = touchToPointOnMainSprite(touchList[0]);
            var relativePoint2:Point = touchToPointOnMainSprite(touchList[1]);

            var center:Point = new Point((relativePoint2.x+relativePoint1.x)/2,(relativePoint2.y+relativePoint1.y)/2);
            var distanceOfTwoPoints:Number = new Point(relativePoint2.x-relativePoint1.x,relativePoint2.y-relativePoint1.y).length*mySprite.scale;
            if(lastTwoPointsDistance!=0)
            {
                scale = distanceOfTwoPoints/lastTwoPointsDistance ;
            }
            lastTwoPointsDistance = distanceOfTwoPoints ;

            var spriteRelativeWidth:Number = mySprite.width/mySprite.scaleX ;
            var spriteRelativeHeight:Number = area.height/mySprite.scale ;

            //trace("center : "+center+' vs width : '+spriteRelativeWidth+' from '+mySprite.width);//TODO control the center point to change the target osition on scaled.
            //trace("scale : "+scale);

            targetX -= (((center.x/(spriteRelativeWidth))*spriteRelativeWidth)*(scale-1))*mySprite.scaleX;
            targetY -= ((center.y/(spriteRelativeHeight))*spriteRelativeHeight)*(scale-1)*mySprite.scaleY;
        }
        /*else if(l==1)
        {
            trace("Global touch point is  "+i+" is : "+touchList[0].getLocation(mySprite)+' vs '+mySprite.width/mySprite.scaleX);
        }*/


        var moveX:Number = deltaX/Math.max(1,l);
        var moveY:Number = deltaY/Math.max(1,l);
        targetX += moveX;
        targetY += moveY;
        targetScale = scale ;

        var targetWidth:Number = mySprite.width*targetScale ;
        var targetHeight:Number = mySprite.height*targetScale ;

        if(l>1 && targetWidth/firstWidth>maxZoomScale || targetHeight/firstHeight>maxZoomScale)
        {
            targetWidth = firstWidth*maxZoomScale ;
            targetHeight = firstHeight*maxZoomScale ;
            targetScale = targetWidth/mySprite.width;
            targetX = mySprite.x + moveX-(((center.x/(spriteRelativeWidth))*spriteRelativeWidth)*(targetScale-1))*mySprite.scaleX;
            targetY = mySprite.y + moveY- ((center.y/(spriteRelativeHeight))*spriteRelativeHeight)*(targetScale-1)*mySprite.scaleY;
        }

        if(targetWidth<area.width || targetHeight<area.height)
        {
            mySprite.width = area.width;
            mySprite.height = area.height;
            mySprite.scale = Math.max(mySprite.scaleX,mySprite.scaleY);
            targetWidth = mySprite.width ;
            targetHeight = mySprite.height ;
        }

        if(targetX>area.left)
        {
            targetX = area.left ;
        }
        if(targetX+targetWidth<area.right)
        {
            targetX = area.right-targetWidth ;
        }

        if(targetY>area.top)
        {
            targetY = area.top ;
        }
        if(targetY+targetHeight<area.bottom)
        {
            targetY = area.bottom-targetHeight ;
        }

        mySprite.x = targetX ;
        mySprite.y = targetY ;
        mySprite.width = targetWidth ;
        mySprite.height = targetHeight ;

        if(mySprite.scale!=lastScale){
            ObjStarling.dispatchEventReverse(mySprite,new StarlingZoomEvent(StarlingZoomEvent.SCALE_CHANGED));
        }

    }


    private function listenToTouch(e:TouchEvent):void
    {
        //TODO
        var touch:Touch ;
        var touchs:Vector.<Touch>;
        touchs = e.getTouches(mySprite);
        for(var i:int = 0 ; i<touchs.length ; i++) {
            touch = touchs[i] ;
            if (touch) {
                if (touch.phase == TouchPhase.BEGAN && !lock) {
                    addTouch(touch);
                }

                else if (touch.phase == TouchPhase.ENDED) {
                    removeTouch(touch);
                    if(unlockOnTouchUp)
                    {
                        lock = false ;
                    }
                }

                else if (touch.phase == TouchPhase.MOVED && !lock) {
                }
            }
        }
    }

        /**Add this touch to the touch list if its not duplicated*/
        private function addTouch(touch:Touch):void
        {
            for(var i:int ; i<touchList.length ; i++)
            {
                if(touchList[i].id==touch.id)
                {
                    trace("The touch was duplicated");
                    return ;
                }
            }
            touchList.push(touch);
            lastPose.push(touchToPoint(touch));
        }

    /**Convert touch to the point*/
    private function touchToPoint(touch:Touch):Point {
        return touch.getLocation(mySprite.parent);
    }

    /**Convert touch to the point*/
    private function touchToPointOnMainSprite(touch:Touch):Point {
        return touch.getLocation(mySprite);
    }

        /**Remove this touch from the list<br>
         * Pass null to remove all touches*/
        private function removeTouch(touch:Touch=null):void
        {
            lastTwoPointsDistance = 0 ;
            if(touch==null)
            {
                touchList = new <Touch>[];
                lastPose = new Vector.<Point>();
                trace("All touches removed");
                return ;
            }
            for(var i:int ; i<touchList.length ;i++)
            {
                if(touchList[i].id == touch.id)
                {
                    touchList.removeAt(i);
                    lastPose.removeAt(i);
                    trace("Touch removed");
                    return ;
                }
            }

        }

    public function reset(zoomArea:Rectangle):void
    {
        clearTouchList();

        area = zoomArea ;
        mySprite.width = zoomArea.width;
        mySprite.height = zoomArea.height;
        mySprite.scale = Math.max(mySprite.scaleX,mySprite.scaleY);
        targetX = mySprite.x = zoomArea.x-(mySprite.width-zoomArea.width)/2;
        targetY = mySprite.y = zoomArea.y-(mySprite.height-zoomArea.height)/2;
        firstScale = targetScale = mySprite.scale ;
        firstWidth = mySprite.width ;
        firstHeight = mySprite.height ;

        mySprite.removeEventListener(TouchEvent.TOUCH,listenToTouch);
        mySprite.removeEventListener(Event.ENTER_FRAME,animateFloor);
        mySprite.addEventListener(TouchEvent.TOUCH,listenToTouch);
        mySprite.addEventListener(Event.ENTER_FRAME,animateFloor);
    }
}
}
