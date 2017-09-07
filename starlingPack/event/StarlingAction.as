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

public class StarlingAction {

    private static var itemsList:Vector.<DisplayObject> = new Vector.<DisplayObject>();
    private static var itemsFunction:Vector.<Function> = new Vector.<Function>();



    public static function addClickListener(item:DisplayObject, onClickedFunction:Function):void
    {
        removeItem(item);
        itemsList.push(item);
        itemsFunction.push(onClickedFunction);
        item.addEventListener(TouchEvent.TOUCH, onTouched);
        item.addEventListener(Event.REMOVED_FROM_STAGE, itemRemovedFromStage);
    }

    private static function itemRemovedFromStage(event:Event):void {
        removeItem(event.currentTarget as DisplayObject);
    }

    /**Remove item and function from list*/
    private static function removeItem(item:DisplayObject):void {
        var I:int = itemsList.indexOf(item);
        if(I!=-1)
        {
            item.removeEventListener(Event.REMOVED_FROM_STAGE, itemRemovedFromStage);
            item.removeEventListener(TouchEvent.TOUCH, onTouched);
            itemsList.removeAt(I);
            itemsFunction.removeAt(I);
        }
    }

    private static function callFunctionFor(item:DisplayObject):void
    {
        var I:int = itemsList.indexOf(item);
        if(I!=-1)
        {
            itemsFunction[I]();
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
                    break ;
                case TouchPhase.ENDED:
                    if(clickedItem.hitTest(clickedItem.globalToLocal(new Point(touches.globalX,touches.globalY))))
                        callFunctionFor(clickedItem);
                    break ;
            }
        }
    }
}
}
