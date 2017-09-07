/**
 * Created by mes on 8/30/2017.
 */
package starlingPack.core {
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Sprite;
import starling.events.Event;

public class ObjStarling {
   public static function remove(target:Sprite):void
   {
       if(target.parent!=null)
        target.parent.removeChild(target);
   }

    public static function zSort(targetParent:Sprite,sortBy:uint=0):void
    {
        targetParent.sortChildren(sortFunctionOnY);
        function sortFunctionOnY(a:DisplayObject,b:DisplayObject):int
        {
            if(a.y<b.y)
                    return -1 ;
            else if(a.y>b.y)
                    return 1;
            else
                    return 0;
        }
    }
    private static function swip(arr:Array , I:int){
        var komaki = arr[I-1]
        arr[I-1] = arr[I]
        arr[I] = komaki
    }

    /**Returns the object scale based on where it is*/
    public static function getAbsoluteScale(target:Sprite):Number
    {
        var scl:Number = target.scale ;
        var par:Sprite ;
        par = target.parent as Sprite;
        while(par!=null){
            scl*=par.scale ;
            par = par.parent as Sprite ;
        }
        return scl ;
    }


    /**Dispatch event to the target and its childs*/
    public static function dispatchEventReverse(target:DisplayObjectContainer,event:Event):void
    {
        event = new Event(event.type,false,event.data);
        target.dispatchEvent(event);
        for(var i:int=0 ; i<target.numChildren ; i++)
        {
            if(target.getChildAt(i) is DisplayObjectContainer){
                dispatchEventReverse(target.getChildAt(i) as DisplayObjectContainer,event) ;
            }
        }
    }

    /**Returns true if item was taouchable*/
    public static function isTouchableFromParents(target:DisplayObject):Boolean
    {
        while(target!=null)
        {
            if(!target.touchable)
            {
                return false ;
            }
            target = target.parent ;
        }
        return true ;
    }
}
}
