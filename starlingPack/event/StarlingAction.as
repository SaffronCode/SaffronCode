/**
 * Created by mes on 9/7/2017.
 */
package starlingPack.event {
import flash.geom.Point;

import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

import starlingPack.core.ObjStarling;

import starlingPack.core.ObjStarling;

public class StarlingAction {

    private static var itemsList_click:Vector.<DisplayObject> = new Vector.<DisplayObject>();
    private static var itemsFunction_click:Vector.<Function> = new Vector.<Function>();

    private static var itemsList_mouseDown:Vector.<DisplayObject> = new Vector.<DisplayObject>();
    private static var itemsFunction_mouseDown:Vector.<Function> = new Vector.<Function>();



    public static function addClickListener(item:DisplayObject, onClickedFunction:Function):void
    {
        removeClickItem(item);
        itemsList_click.push(item);
        itemsFunction_click.push(onClickedFunction);
        item.addEventListener(TouchEvent.TOUCH, onTouched);
        item.addEventListener(Event.REMOVED_FROM_STAGE, itemRemovedFromStage);
    }

    public static function addMouseDownListener(item:DisplayObject,onMouseDownFunction:Function):void
    {
        removeMouseDownItem(item);
        itemsList_mouseDown.push(item);
        itemsFunction_mouseDown.push(onMouseDownFunction);
        item.addEventListener(TouchEvent.TOUCH, onTouched);
        item.addEventListener(Event.REMOVED_FROM_STAGE, itemRemovedFromStage);
    }

    private static function itemRemovedFromStage(event:Event):void {
        removeClickItem(event.currentTarget as DisplayObject);
        removeMouseDownItem(event.currentTarget as DisplayObject);
    }

    /**Remove all older click listeners from this item*/
    public static function removeClickListeners(item:DisplayObject):void
    {
        while(removeClickItem(item)){};
    }

    /**Remove item and function from list<br>
     * it will return true if item was exists on the itemsList_click*/
    private static function removeClickItem(item:DisplayObject):Boolean {
        var I:int = itemsList_click.indexOf(item);
        if(I!=-1)
        {
            item.removeEventListener(Event.REMOVED_FROM_STAGE, itemRemovedFromStage);
            item.removeEventListener(TouchEvent.TOUCH, onTouched);
            itemsList_click.removeAt(I);
            itemsFunction_click.removeAt(I);
            return true ;
        }
        return false ;
    }

    /**Remove item and function from list<br>
     * it will return true if item was exists on the itemsList_click*/
    private static function removeMouseDownItem(item:DisplayObject):Boolean {
        var I:int = itemsList_mouseDown.indexOf(item);
        if(I!=-1)
        {
            item.removeEventListener(Event.REMOVED_FROM_STAGE, itemRemovedFromStage);
            item.removeEventListener(TouchEvent.TOUCH, onTouched);
            itemsList_mouseDown.removeAt(I);
            itemsFunction_mouseDown.removeAt(I);
            return true ;
        }
        return false ;
    }

    private static function callClickFunctionFor(item:DisplayObject,touches:Touch):void
    {
        var I:int = itemsList_click.indexOf(item);
        if(I!=-1)
        {
            if(itemsFunction_click[I].length>0)
                itemsFunction_click[I](touches);
            else
                itemsFunction_click[I]();
        }
    }

    private static function callMouseDownFunctionFor(item:DisplayObject,touches:Touch):void
    {
        var I:int = itemsList_mouseDown.indexOf(item);
        if(I!=-1)
        {
            if(itemsFunction_mouseDown[I].length>0)
                itemsFunction_mouseDown[I](touches);
            else
                itemsFunction_mouseDown[I]();
        }
    }

    private static function onTouched(event:TouchEvent):void
    {
        var clickedItem:DisplayObject = event.currentTarget as DisplayObject;
        var touches:Touch = event.getTouch(clickedItem);
        if(touches!=null)
        {
            switch (touches.phase)
            {
                case TouchPhase.BEGAN:
                    if(ObjStarling.isTouchableFromParents(clickedItem) && clickedItem.hitTest(clickedItem.globalToLocal(new Point(touches.globalX,touches.globalY))))
                        callMouseDownFunctionFor(clickedItem,touches);
                    break ;
                case TouchPhase.ENDED:
                    if(ObjStarling.isTouchableFromParents(clickedItem) && clickedItem.hitTest(clickedItem.globalToLocal(new Point(touches.globalX,touches.globalY))))
                        callClickFunctionFor(clickedItem,touches);
                    break ;
            }
        }
    }
}
}
