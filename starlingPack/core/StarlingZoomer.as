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

    public function StarlingZoomer(zoomableObject:Sprite) {
        mySprite = zoomableObject ;

        mySprite.addEventListener(TouchEvent.TOUCH,listenToTouch);
        mySprite.addEventListener(Event.ENTER_FRAME,animateFloor);
    }

    private function animateFloor(e:Event):void
    {
        //TODO
    }


    private function listenToTouch(e:TouchEvent):void
    {
        //TODO
        var touch:Touch = e.getTouch(mySprite.stage);
        if(touch)
        {
            if(touch.phase == TouchPhase.BEGAN)
            {
            }

            else if(touch.phase == TouchPhase.ENDED)
            {

            }

            else if(touch.phase == TouchPhase.MOVED)
            {
            }
        }
    }

    public function reset(zoomArea:Rectangle):void
    {
        area = zoomArea ;
        mySprite.width = zoomArea.width;
        mySprite.height = zoomArea.height;
        mySprite.scale = Math.max(mySprite.scaleX,mySprite.scaleY);
        mySprite.x = zoomArea.x-(mySprite.width-zoomArea.width)/2;
        mySprite.y = zoomArea.y-(mySprite.height-zoomArea.height)/2;
    }
}
}
