/**
 * Created by mes on 8/26/2017.
 */
package starlingPack.event {
import starling.events.Event;

public class StarlingZoomEvent extends Event {
    public static const LOCK_UNTIL_TOUCH_UP:String = "LOCK_UNTIL_TOUCH_UP" ;

    public function StarlingZoomEvent(type:String, bubbles:Boolean = false, data:Object = null) {
        super(type, bubbles, data);
    }
}
}
