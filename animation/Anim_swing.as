/**
 * Created by mes on 20/10/2017.
 */
package animation {
import flash.display.Sprite;
import flash.events.Event;

public class Anim_swing extends Sprite {

    var object:Object ;

    var deg:Number ;

    private var degSpeedDown:Number = 20 ;

    private var currentDeg:Number=0,
                V:Number=0,F:Number=8,M:Number=0.9;

    private var firstRotation:Number;

    /**Dont pass firstDegree more than 90 or less than -90*/
    public function Anim_swing(displayObject:Object,firstDegree:Number) {
        this.addEventListener(Event.ENTER_FRAME,animate);
        object = displayObject ;
        currentDeg = firstRotation = object.rotation ;
        object.addEventListener(Event.REMOVED_FROM_STAGE,unLoadMe);
        deg = firstDegree ;
    }

    /**Update the rotation animation*/
    public function updateDegree(value:Number):void
    {
        deg = value ;
    }

    public function unLoadMe(event:*=null):void {
        object.rotation = firstRotation ;
        object.removeEventListener(Event.REMOVED_FROM_STAGE,unLoadMe);
        this.removeEventListener(Event.ENTER_FRAME,animate);
    }

    private function animate(event:Event):void {
        deg += (0-deg)/degSpeedDown ;

        V += (deg-currentDeg)/F;
        V *= M ;
        currentDeg += V ;

        object.rotation = currentDeg ;
    }
}
}
