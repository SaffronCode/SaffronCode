/**
 * Created by mes on 6/18/2017.
 */
package starlingPack.core {
import flash.geom.Rectangle;

import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class StarlingZoomer {

    private var mySprite:Sprite,
                area:Rectangle;

    private var touchList:Vector.<Touch> ;

    public function StarlingZoomer(zoomableObject:Sprite) {
        mySprite = zoomableObject ;

        clearTouchList();

        mySprite.addEventListener(TouchEvent.TOUCH,listenToTouch);
        mySprite.addEventListener(Event.ENTER_FRAME,animateFloor);
    }

    /**Clear touch list*/
    private function clearTouchList():void
    {
        touchList = new Vector.<Touch>();
    }

    private function animateFloor(e:Event):void
    {
        //TODO
        trace("touch : "+touchList.length);
    }


    private function listenToTouch(e:TouchEvent):void
    {
        //TODO
        var touch:Touch;
        touch = e.getTouch(mySprite.stage);
        if(touch)
        {
            if(touch.phase == TouchPhase.BEGAN)
            {
                addTouch(touch);
            }

            else if(touch.phase == TouchPhase.ENDED)
            {
                removeTouch(touch);
            }

            else if(touch.phase == TouchPhase.MOVED)
            {
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
        }

        /**Remove this touch from the list*/
        private function removeTouch(touch:Touch):void
        {
            for(var i:int ; i<touchList.length ;i++)
            {
                if(touchList[i].id == touch.id)
                {
                    touchList.removeAt(i);
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
        mySprite.x = zoomArea.x-(mySprite.width-zoomArea.width)/2;
        mySprite.y = zoomArea.y-(mySprite.height-zoomArea.height)/2;
    }
}
}
