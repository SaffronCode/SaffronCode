/**
 * Created by mes on 22/10/2017.
 */
package starlingPack.display {
import flash.geom.Rectangle;

import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;

public class ScrollStarling {

    private var target:Sprite;
    private var mask:Image ;
    private var maskArea:Rectangle ;

    public function ScrollStarling(Target:Sprite,MaskArea:Rectangle) {
        super();
        target = Target ;
        maskArea = MaskArea ;
        
        target.addEventListener(Event.ENTER_FRAME,anim);
        anim(null)
    }

    private function anim(e:Event):void
    {
        mask = new Image(Texture.fromColor(maskArea.width,maskArea.height));
        //var maskStyle:TextureMask
        //mask.x = MaskArea.x ;
        //mask.y = MaskArea.y ;
        //target.parent.addChild(mask);
        target.mask = mask ;
    }
}
}
