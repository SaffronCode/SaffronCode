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

[Event(name="SCROLLING", type="starlingPack.event.StarlingScrollEvent")]
public class ScrollStarling extends Sprite {

    private var target:DisplayObject;
   //private var mask:Image ;
    private var maskArea:Rectangle ;

    private var currentTouch:Touch,
                firstTouch:Touch,
                lastCapturedTouch:Touch;

    private var targetX0:Number,targetY0:Number;

    private var Vx:Number,Vy:Number;

    public static const minMoveToScroll:Number = 10 ;

    private static const Mu:Number = 0.9 ;

    /**0:Not scrolling, 1:Dragging but scroll is not starting, 2:Is Scrolling.*/
    private var mode:uint ;

    private var freeToScrollLR:Boolean,
                freeToScrollTD:Boolean;

    public function ScrollStarling(Target:DisplayObject,MaskArea:Rectangle) {
        super();

        mode = 0 ;

        PermissionControl.controlDescriptorForMasks();

        Vx = 0 ;
        Vy = 0 ;

        target = Target ;
        maskArea = MaskArea ;

        targetX0 = target.x ;
        targetY0 = target.y ;

        var mask:Quad = new Quad(maskArea.width,maskArea.height);
        target.mask = mask;

        target.addEventListener(Event.ENTER_FRAME,animScroll);
        target.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
        StarlingAction.addMouseDownListener(target,mouseDown);
        StarlingAction.addClickListener(target,mouseStopDragg);
    }

        /**Creates points from touchs*/
        private function touchToParentPoint(touch:Touch):Point
        {
            return target.parent.globalToLocal(new Point(touch.globalX,touch.globalY));
        }

    private function mouseStopDragg(touches:Touch):void
    {
        mode = 0 ;
        freeToScrollLR = freeToScrollTD = false ;
        trace("Stoppp!!!!!!!!!!!!!");
        StarlingAction.removeMouseMoveListeners(target.stage,mouseMoved);
        currentTouch = null ;
    }

    private function mouseDown(touches:Touch):void
    {
        mode = 1 ;
        Vx = 0 ;
        Vy = 0 ;
        trace("Touched!!!!!!!!!!!!!");
        currentTouch = touches.clone() ;
        firstTouch = touches.clone();
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
        switch(mode)
        {
            case 0:

                Vx*=Mu;
                Vy*=Mu;

                break;
            case 1:
                if(lastCapturedTouch==currentTouch)
                {
                    break;
                }
                    trace("firstTouch.globalX  : "+firstTouch.globalX);
                if(Math.abs(currentTouch.globalX-firstTouch.globalX)>minMoveToScroll){
                    freeToScrollLR = true ;
                    mode = 2 ;
                }
                if(Math.abs(currentTouch.globalY-firstTouch.globalY)>minMoveToScroll){
                    freeToScrollTD = true ;
                    mode = 2 ;
                }

                break;
            case 2:
                var pointLast:Point = touchToParentPoint(lastCapturedTouch);
                var pointCurrent:Point = touchToParentPoint(currentTouch);
                Vx = pointCurrent.x-pointLast.x ;
                Vy = pointCurrent.y-pointLast.y ;

                break;
        }

        target.x += Vx ;
        target.y += Vy ;
        target.mask.x = targetX0-target.x ;
        target.mask.y = targetY0-target.y ;


        lastCapturedTouch = currentTouch ;
    }

}
}
