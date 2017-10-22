/**
 * Created by mes on 22/10/2017.
 */
package starlingPack.display {
import com.mteamapp.StringFunctions;

import flash.geom.Rectangle;

import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;
import starling.display.Canvas; // NEW!

public class ScrollStarling {

    private var target:DisplayObject;
   //private var mask:Image ;
    private var maskArea:Rectangle ;

    public function ScrollStarling(Target:DisplayObject,MaskArea:Rectangle) {
        super();

        controlDescriptor();

        target = Target ;
        maskArea = MaskArea ;

        var mask:Quad = new Quad(maskArea.width,maskArea.height);
        target.mask = mask;
    }

    private function controlDescriptor():void {
        var appXML:String = StringFunctions.clearSpacesAndTabs(DevicePrefrence.appDescriptor);
        if(appXML.indexOf("<depthAndStencil>true</depthAndStencil>")==-1)
        {
            throw "You have to set <depthAndStencil>true</depthAndStencil>  to true to make masks works on starling."
        }
    }

}
}
