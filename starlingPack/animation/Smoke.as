/**
 * Created by mes on 03/11/2017.
 */
package starlingPack.animation {
import starling.display.Quad;
import starling.display.Sprite;

public class Smoke extends Sprite {
    public function Smoke() {
        super();
        var quad:Quad = new Quad(100,100,0xff0000);
        this.addChild(quad)
    }
}
}
