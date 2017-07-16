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

public class StarlingZoomer {

    private var mySprite:Sprite,
                area:Rectangle;

    private var touchList:Vector.<Touch>,
                lastPose:Vector.<Point>;

    private var targetX:Number,targetY:Number,targetScale:Number;

    /**0 is the reseted distance*/
    private var lastTwoPointsDistance:Number = 0 ;

    public function StarlingZoomer(zoomableObject:Sprite) {
        if(Starling.multitouchEnabled==false)
        {
            trace("You should set Starling.multitouchEnabled = true  before creating starling instance on the main class.");
        }
        mySprite = zoomableObject ;
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

        var scale:Number = 0 ;

        var l:int = touchList.length ;

        for(var i:int = 0 ; i<l ; i++)
        {
            var currentPose:Point = touchToPoint(touchList[i]);
            trace("Global touch point is  "+i+" is : "+touchList[i].getLocation(mySprite)+' vs '+mySprite.width/mySprite.scaleX);
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

            scale = scale-1;

            trace("center : "+center+' vs width : '+spriteRelativeWidth+' from '+mySprite.width);//TODO control the center point to change the target osition on scaled.
            trace("scale : "+scale);

            targetX -= ((center.x/(spriteRelativeWidth))*spriteRelativeWidth)*(scale);
            targetY -= ((center.y/(spriteRelativeHeight))*spriteRelativeHeight)*(scale);
        }
        else if(l==1)
        {
            trace("Global touch point is  "+i+" is : "+touchList[0].getLocation(mySprite)+' vs '+mySprite.width/mySprite.scaleX);
        }

        targetX += deltaX/Math.max(1,l);
        targetY += deltaY/Math.max(1,l);
        targetScale += scale ;

        mySprite.x = targetX ;
        mySprite.y = targetY ;
        mySprite.scale = targetScale ;
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
                if (touch.phase == TouchPhase.BEGAN) {
                    addTouch(touch);
                }

                else if (touch.phase == TouchPhase.ENDED) {
                    removeTouch(touch);
                }

                else if (touch.phase == TouchPhase.MOVED) {
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

        /**Remove this touch from the list*/
        private function removeTouch(touch:Touch):void
        {
            lastTwoPointsDistance = 0 ;
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
        targetScale = mySprite.scale ;

        mySprite.removeEventListener(TouchEvent.TOUCH,listenToTouch);
        mySprite.removeEventListener(Event.ENTER_FRAME,animateFloor);
        mySprite.addEventListener(TouchEvent.TOUCH,listenToTouch);
        mySprite.addEventListener(Event.ENTER_FRAME,animateFloor);
    }
}
}
