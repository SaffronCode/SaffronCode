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

    private var targetX:Number,targetY:Number;

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

        var l:int = touchList.length ;

        for(var i:int = 0 ; i<l ; i++)
        {
            deltaX += touchList[i].globalX-lastPose[i].x ;
            deltaY += touchList[i].globalY-lastPose[i].y ;

            lastPose[i] = new Point(touchList[i].globalX,touchList[i].globalY) ;

            trace("Add "+i+" from "+l);
        }

        targetX += deltaX/Math.max(1,l);
        targetY += deltaY/Math.max(1,l);

        mySprite.x = targetX ;
        mySprite.y = targetY ;
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
            lastPose.push(new Point(touch.globalX,touch.globalY));
        }

        /**Remove this touch from the list*/
        private function removeTouch(touch:Touch):void
        {
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

        mySprite.removeEventListener(TouchEvent.TOUCH,listenToTouch);
        mySprite.removeEventListener(Event.ENTER_FRAME,animateFloor);
        mySprite.addEventListener(TouchEvent.TOUCH,listenToTouch);
        mySprite.addEventListener(Event.ENTER_FRAME,animateFloor);
    }
}
}
