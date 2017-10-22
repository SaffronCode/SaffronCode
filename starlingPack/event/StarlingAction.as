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

    private static var itemsList_mouseMove:Vector.<DisplayObject> = new Vector.<DisplayObject>();
    private static var itemsFunction_mouseMove:Vector.<Function> = new Vector.<Function>();



    /**The action function can get Touch variable to*/
    public static function addClickListener(item:DisplayObject, onClickedFunction:Function):void
    {
        removeClickItem(item,onClickedFunction);
        itemsList_click.push(item);
        itemsFunction_click.push(onClickedFunction);
        item.addEventListener(TouchEvent.TOUCH, onTouched);
        item.addEventListener(Event.REMOVED_FROM_STAGE, itemRemovedFromStage);
    }

    /**The action function can get Touch variable to*/
    public static function addMouseDownListener(item:DisplayObject,onMouseDownFunction:Function):void
    {
        removeMouseDownItem(item,onMouseDownFunction);
        itemsList_mouseDown.push(item);
        itemsFunction_mouseDown.push(onMouseDownFunction);
        item.addEventListener(TouchEvent.TOUCH, onTouched);
        item.addEventListener(Event.REMOVED_FROM_STAGE, itemRemovedFromStage);
    }

    public static function addMouseMoveListner(item:DisplayObject,onMouseMoveFunction:Function):void
    {
        removeMouseMoveItem(item,onMouseMoveFunction);
        itemsList_mouseMove.push(item);
        itemsFunction_mouseMove.push(onMouseMoveFunction);
        item.addEventListener(TouchEvent.TOUCH, onTouched);
        item.addEventListener(Event.REMOVED_FROM_STAGE, itemRemovedFromStage);
    }


    private static function itemRemovedFromStage(event:Event):void {
        removeClickItem(event.currentTarget as DisplayObject,null);
        removeMouseDownItem(event.currentTarget as DisplayObject,null);
        removeMouseMoveItem(event.currentTarget as DisplayObject,null);
    }

    /**Remove all older click listeners from this item*/
    public static function removeClickListeners(item:DisplayObject,func:Function=null):void
    {
        while(removeClickItem(item,func)){};
    }
    /**Remove all older mouse move listeners from this item*/
    public static function removeMouseMoveListeners(item:DisplayObject,func:Function=null):void
    {
        while(removeMouseMoveItem(item,func)){};
    }
    /**Remove all older mouse down listeners from this item*/
    public static function removeMouseDownListeners(item:DisplayObject,func:Function=null):void
    {
        while(removeMouseDownItem(item,func)){};
    }

    /**Remove item and function from list<br>
     * it will return true if item was exists on the itemsList_click*/
    private static function removeClickItem(item:DisplayObject,func:Function):Boolean {
        var I:int = itemsList_click.indexOf(item);
        if(func!=null)
        {
            var J:int = itemsFunction_click.indexOf(func);
            if(I!=J)
            {
                return false ;
            }
        }
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
    private static function removeMouseMoveItem(item:DisplayObject,func:Function):Boolean {
        var I:int = itemsList_mouseMove.indexOf(item);
        if(func!=null)
        {
            var J:int = itemsFunction_mouseMove.indexOf(func);
            if(I!=J)
            {
                return false ;
            }
        }
        if(I!=-1)
        {
            item.removeEventListener(Event.REMOVED_FROM_STAGE, itemRemovedFromStage);
            item.removeEventListener(TouchEvent.TOUCH, onTouched);
            itemsList_mouseMove.removeAt(I);
            itemsFunction_mouseMove.removeAt(I);
            return true ;
        }
        return false ;
    }

    /**Remove item and function from list<br>
     * it will return true if item was exists on the itemsList_click*/
    private static function removeMouseDownItem(item:DisplayObject,func:Function):Boolean {
        var I:int = itemsList_mouseDown.indexOf(item);
        if(func!=null)
        {
            var J:int = itemsFunction_mouseDown.indexOf(func);
            if(I!=J)
            {
                return false ;
            }
        }
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

    private static function callMoveFunctionFor(item:DisplayObject,touches:Touch):void
    {
        var I:int = itemsList_mouseMove.indexOf(item);
        if(I!=-1)
        {
            if(itemsFunction_mouseMove[I].length>0)
                itemsFunction_mouseMove[I](touches);
            else
                itemsFunction_mouseMove[I]();
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
                case TouchPhase.MOVED:
                    if(ObjStarling.isTouchableFromParents(clickedItem) && clickedItem.hitTest(clickedItem.globalToLocal(new Point(touches.globalX,touches.globalY))))
                        callMoveFunctionFor(clickedItem,touches);
                    break ;
            }
        }
    }
}
}
