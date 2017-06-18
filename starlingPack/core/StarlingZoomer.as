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

    private var mySprite:Sprite ;

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
        trace("gameAreaMC.width1 : "+mySprite.width);
        mySprite.width = zoomArea.width;
        trace("gameAreaMC.width2 : "+mySprite.width);
        mySprite.height = zoomArea.height;
        trace("+scaleX"+mySprite.scaleX);
        trace("-scaleT"+mySprite.scaleY);
        mySprite.scale = Math.max(mySprite.scaleX,mySprite.scaleY);
        trace("gameAreaMC.width3 : "+mySprite.width);
        mySprite.x = zoomArea.x;//(gameAreaMC.width-ScreenManager.stageWidthFlash())/-2;
        mySprite.y = zoomArea.y;//(gameAreaMC.height-ScreenManager.stageHeightFlash())/-2;
    }
}
}
