/**
 * Created by mes on 20/10/2017.
 */
package animation {
import flash.display.Sprite;
import flash.events.Event;

public class Anim_swing {

    var object:Object ;

    var deg:Number ;

    private const degSpeedDown:Number = 20 ;

    private var currentDeg:Number=0,
                V:Number=0;
    private var F:Number,M:Number;

    private var firstRotation:Number;
	
	private var myEnterFramer:Sprite ;

    /**Dont pass firstDegree more than 90 or less than -90. Pass Radian instead of degree for starling*/
    public function Anim_swing(displayObject:Object,firstDegree:Number,Fparam:Number=8,Mparam:Number=0.9) {
		F = Fparam ;
		M = Mparam ;
		myEnterFramer = new Sprite();
		myEnterFramer.addEventListener(Event.ENTER_FRAME,animate);
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
		myEnterFramer.removeEventListener(Event.ENTER_FRAME,animate);
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
