/**
 * Created by mes on 20/10/2017.
 */
package animation {
import flash.display.Sprite;
import flash.events.Event;

public class Anim_swing extends Sprite {

    var object:Object ;

    var deg:Number ;

    private var degSpeedDown:Number = 5 ;

    private const oldSwingEventName:String = "removeOldSwingAnim" ;

    /**Dont pass firstDegree more than 90 or less than -90*/
    public function Anim_swing(displayObject:Object,firstDegree:Number) {
        displayObject.dispatchEvent(new Event(oldSwingEventName));
        this.addEventListener(Event.ENTER_FRAME,animate);
        object = displayObject ;
        object.addEventListener(Event.REMOVED_FROM_STAGE,unLoadMe);
        deg = firstDegree ;
        displayObject[removeOldSwingAnim] = unLoadMe ;
    }

    private function unLoadMe(event:*):void {
        object.removeEventListener(Event.REMOVED_FROM_STAGE,unLoadMe);
        this.removeEventListener(Event.ENTER_FRAME,animate);
    }

    private function animate(event:Event):void {
        deg += (0-deg)/degSpeedDown ;
        object.rotation = deg ;
    }
}
}
