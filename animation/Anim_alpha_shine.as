/**
 * Created by mes on 9/11/2017.
 */
package animation {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;



public class Anim_alpha_shine extends Sprite{

    var object:Object ;

    var I:Number ;

    public function Anim_alpha_shine(displayObject:Object) {
        this.addEventListener(Event.ENTER_FRAME,animate);
        object = displayObject ;
        object.addEventListener(Event.REMOVED_FROM_STAGE,unLoadMe);
        I = 0 ;
    }

    private function unLoadMe(event:*):void {
        object.removeEventListener(Event.REMOVED_FROM_STAGE,unLoadMe);
        this.removeEventListener(Event.ENTER_FRAME,animate);
    }

    public function stop():void
    {
        unLoadMe(null);
    }

    public function reset():void
    {
        stop();
        object.alpha = 1 ;
    }

    private function animate(e:Event):void
    {
        object.alpha = 1-(Math.cos(I)+1)/4 ;
        I+=0.1;
    }
}
}
