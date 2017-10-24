/**
 * Created by mes on 24/10/2017.
 */
package starlingPack.event {
import starling.events.Event;

public class StarlingScrollEvent extends Event {

    public static const SCROLLING:String = "SCROLLING" ;

    public function StarlingScrollEvent(type:String, bubbles:Boolean = false, data:Object = null) {
        super(type, bubbles, data);
    }
}
}
