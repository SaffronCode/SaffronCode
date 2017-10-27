/**
 * Created by mes on 22/10/2017.
 */
package starlingPack.display {
import com.mteamapp.StringFunctions;

import flash.geom.Point;


import flash.geom.Rectangle;
import flash.utils.setTimeout;

import permissionControlManifestDiscriptor.PermissionControl;

import starling.display.DisplayObject;
import starling.display.Quad;
import starling.display.Sprite;
import starling.display.Stage;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchPhase;

import starlingPack.event.StarlingAction;

import starlingPack.event.StarlingAction;
import starlingPack.event.StarlingScrollEvent;

[Event(name="SCROLLING", type="starlingPack.event.StarlingScrollEvent")]
[Event(name="SCROLLING_ENDED", type="starlingPack.event.StarlingScrollEvent")]
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

    public static const rollBackAnimSpeed:Number = 10 ;

    private static const Mu:Number = 0.9 ;

    /**0:Not scrolling, 1:Dragging but scroll is not starting, 2:Is Scrolling.*/
    private var mode:uint ;

    private var freeToScrollLR:Boolean,
                freeToScrollTD:Boolean;

    private var targetStage:Stage ;

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


        controlTargetStage();
    }

    /**Returns true if scrolling availables on LtR direction*/
    private function scrollLRAvailable():Boolean
    {
        return maskArea.width<targRect.width ;
    }

    /**Returns true if scrolling availables on TtD direction*/
    private function scrollTDAvailable():Boolean
    {
        return maskArea.height<targRect.height ;
    }

    private function controlTargetStage():void {
        if(target.stage==null)
        {
            target.addEventListener(Event.ADDED_TO_STAGE,controlTargetStage);
        }
        else
        {
            targetStage = target.stage ;
            target.addEventListener(Event.ENTER_FRAME,animScroll);
            target.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
            StarlingAction.addMouseDownListener(target,mouseDown);
        }
    }

        /**Creates points from touchs*/
        private function touchToParentPoint(touch:Touch):Point
        {
            trace("target.parent : "+target.parent);
            trace("touch : "+touch);
            return target.parent.globalToLocal(new Point(touch.globalX,touch.globalY));
        }

    /**Stop dragging*/
    private function mouseStopDragg(touches:Touch=null):void
    {
        if(mode==0)
        {
            return ;
        }
        mode = 0 ;
        freeToScrollLR = freeToScrollTD = false ;
        trace("Stoppp!!!!!!!!!!!!!");
        //StarlingAction.removeMouseMoveListeners(target.stage,mouseMoved);
        currentTouch = null ;
        dispatchScrollEndEvent();
        setTimeout(dispatchScrollEndEvent,0);
    }

    /**Tells every body that the scroll is over*/
    private function dispatchScrollEndEvent():void
    {
        target.dispatchEvent(new StarlingScrollEvent(StarlingScrollEvent.SCROLLING_ENDED,true));
        target.touchable = true ;
    }

    /**Tells every body that the scroll is began*/
    private function dispatchScrollStartsEvent():void
    {
        target.dispatchEvent(new StarlingScrollEvent(StarlingScrollEvent.SCROLLING,true));
        target.touchable = false ;
    }

    /**Returns a rectangle that defins target area rectangle*/
    public function get targRect():Rectangle
    {
        return new Rectangle(target.x,target.y,target.width,target.height);
    }

    private function mouseDown(touches:Touch):void
    {
        mode = 1 ;
        Vx = 0 ;
        Vy = 0 ;
        trace("Touched!!!!!!!!!!!!!");
        currentTouch = touches ;
        firstTouch = touches.clone();
        //StarlingAction.addMouseMoveListner(target.stage,mouseMoved);
    }

    /**Mouse movelistner
    private function mouseMoved(touches:Touch):void
    {
        trace("Mouse moved : ");
        currentTouch = touches.clone() ;
    }*/


    private function unLoad(e:*):void
    {
        mouseStopDragg();
        this.removeEventListener(Event.ENTER_FRAME,animScroll);
    }

    private function animScroll(event:Event):void {

        if(mode!=0 && (freeToScrollLR==false || freeToScrollTD == false))
        {
            if(freeToScrollLR==false && scrollLRAvailable() && Math.abs(currentTouch.globalX-firstTouch.globalX)>minMoveToScroll){
                freeToScrollLR = true ;
                mode = 2 ;
                dispatchScrollStartsEvent();
            }
            if(freeToScrollTD == false && scrollTDAvailable() && Math.abs(currentTouch.globalY-firstTouch.globalY)>minMoveToScroll){
                freeToScrollTD = true ;
                mode = 2 ;
                dispatchScrollStartsEvent();
            }
        }

        switch(mode)
        {
            case 0:

                Vx*=Mu;
                Vy*=Mu;

                if(scrollLRAvailable()) {
                    if (targRect.x > maskArea.x) {
                        Vx = (maskArea.x - target.x) / rollBackAnimSpeed;
                    }
                    else if (targRect.right < maskArea.right) {
                        Vx = ((maskArea.width - targRect.width) - target.x) / rollBackAnimSpeed;
                    }
                }
                if(scrollTDAvailable()){
                    if(targRect.y>maskArea.y)
                    {
                        Vy = (maskArea.y-target.y)/rollBackAnimSpeed;
                    }
                    else if(targRect.bottom<maskArea.bottom)
                    {
                        Vy = ((maskArea.height-targRect.height)-target.y)/rollBackAnimSpeed;
                    }
                }

                break;
            case 1:
                break;
            case 2:
                if(lastCapturedTouch==null)
                        break;
                if(currentTouch.phase == TouchPhase.ENDED)
                {
                    mouseStopDragg();
                    break
                }
                var pointLast:Point = touchToParentPoint(lastCapturedTouch);
                var pointCurrent:Point = touchToParentPoint(currentTouch);
                if(freeToScrollLR)
                    Vx = pointCurrent.x-pointLast.x ;
                if(freeToScrollTD)
                    Vy = pointCurrent.y-pointLast.y ;

                break;
        }

        target.x += Vx ;
        target.y += Vy ;
        target.mask.x = targetX0-target.x ;
        target.mask.y = targetY0-target.y ;


        if(currentTouch!=null)
            lastCapturedTouch = currentTouch.clone() ;
    }

}
}
