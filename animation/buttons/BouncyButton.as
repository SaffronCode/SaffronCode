package animation.buttons
//animation.buttons.BouncyButton
{
import animation.Anim_swing;

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

public class BouncyButton extends MovieClip
{
    private var animate:Anim_swing ;

    private var maxScale:Number = 0.1 ;

    private var scale0:Number ;

    private var isOverMe:Boolean = false ;

    /**This parameter will prevent Click event to dispatch*/
    private var preventClick:Boolean = true ;

    private const clickAfterThisTime:Number = 500 ;

    private static var lastTimeOutId:uint ;

    public function BouncyButton()
    {
        super();
        this.buttonMode = true ;
        this.mouseChildren = false ;
        this.addEventListener(MouseEvent.MOUSE_OVER,overEffect);
        this.addEventListener(MouseEvent.MOUSE_OUT,outEffect);
        this.addEventListener(MouseEvent.CLICK,handleDefaultClick)

        this.addEventListener(Event.ENTER_FRAME,animation);
        scale0 = this.scaleX ;
        maxScale = this.scaleX + maxScale ;
    }

    private function handleDefaultClick(event:MouseEvent):void
    {
        if(preventClick)
        {
            event.stopImmediatePropagation();
            animate = new Anim_swing(this,10);
            //Prevent other buttons click
            clearTimeout(lastTimeOutId);
            lastTimeOutId = setTimeout(dispatchRealClick,clickAfterThisTime);
        }
    }

    private function dispatchRealClick():void
    {
        preventClick = false ;
        this.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
        preventClick = true ;
    }

    private function outEffect(event:MouseEvent):void
    {
        isOverMe = false ;
    }

    private function animation(event:Event):void
    {
        if(isOverMe)
            this.scaleY += (maxScale-this.scaleY)/4 ;
        else
            this.scaleY += (scale0-this.scaleY)/2 ;

        this.scaleX = this.scaleY ;
    }

    private function overEffect(event:MouseEvent):void
    {
        isOverMe = true ;
    }
}
}
