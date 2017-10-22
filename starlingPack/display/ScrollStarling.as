/**
 * Created by mes on 22/10/2017.
 */
package starlingPack.display {
import com.mteamapp.StringFunctions;

import flash.geom.Point;


import flash.geom.Rectangle;

import permissionControlManifestDiscriptor.PermissionControl;

import starling.display.DisplayObject;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;

import starlingPack.event.StarlingAction;

import starlingPack.event.StarlingAction;

public class ScrollStarling extends Sprite {

    private var target:DisplayObject;
   //private var mask:Image ;
    private var maskArea:Rectangle ;

    private var firstPoint:Point;

    private var currentTouch:Touch ;

    public function ScrollStarling(Target:DisplayObject,MaskArea:Rectangle) {
        super();

        PermissionControl.controlDescriptorForMasks();

        target = Target ;
        maskArea = MaskArea ;

        var mask:Quad = new Quad(maskArea.width,maskArea.height);
        target.mask = mask;

        target.addEventListener(Event.ENTER_FRAME,animScroll);
        target.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
        StarlingAction.addMouseDownListener(target,mouseDragging);
        StarlingAction.addClickListener(target,mouseStopDragg);
    }

    /**Creates points from touchs*/
    private function touchToParentPoint(touch:Touch):Point
    {
        return target.parent.globalToLocal(new Point(touch.globalX,touch.globalY));
    }

    private function mouseStopDragg(touches:Touch):void
    {
        trace("Stoppp!!!!!!!!!!!!!");
        StarlingAction.removeMouseMoveListeners(target.stage,mouseMoved);
        currentTouch = null ;
    }

    private function mouseDragging(touches:Touch):void
    {
        trace("Touched!!!!!!!!!!!!!");
        currentTouch = touches.clone() ;
        firstPoint = touchToParentPoint(touches);
        StarlingAction.addMouseMoveListner(target.stage,mouseMoved);
    }

    /**Mouse movelistner*/
    private function mouseMoved(touches:Touch):void
    {
        trace("Mouse moved : ");
        currentTouch = touches.clone() ;
    }


    private function unLoad(e:*):void
    {
        this.removeEventListener(Event.ENTER_FRAME,animScroll);
    }

    private function animScroll(event:Event):void {
        //trace("currentTouch : "+currentTouch)
        if(currentTouch!=null)
        {
            trace("Re place it");
            var currentPoint:Point = touchToParentPoint(currentTouch);
            target.x = currentPoint.x-firstPoint.x;
            target.y = currentPoint.y-firstPoint.y;
        }
    }

}
}
