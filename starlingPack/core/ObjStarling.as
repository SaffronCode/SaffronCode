/**
 * Created by mes on 8/30/2017.
 */
package starlingPack.core {
import starling.display.DisplayObject;
import starling.display.Sprite;

public class ObjStarling {
   public static function remove(target:Sprite):void
   {
       if(target.parent!=null)
        target.parent.removeChild(target);
   }

    public static function zSort(targetParent:Sprite,sortBy:uint=0):void
    {
        var chi:DisplayObject ;
        var sorter:Array = new Array()
        for(var i=targetParent.numChildren-1 ; i>=0 ; i--){
            chi = targetParent.getChildAt(i);
            switch(sortBy)
            {
                case(0):
                    sorter[i] = (chi.y)
                    break;
                case(1):
                    sorter[i] = (chi.scaleX)
                    break;
            }
        }
        for(i=0;i<sorter.length;i++){
            for(var j=i;j<sorter.length;j++){
                if(sorter[j-1]>sorter[j]){
                    swip(sorter,j)
                    targetParent.swapChildrenAt(j-1,j)
                }
            }
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
}
}
