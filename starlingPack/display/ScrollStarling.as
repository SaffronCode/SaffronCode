/**
 * Created by mes on 22/10/2017.
 */
package starlingPack.display {
import com.mteamapp.StringFunctions;

import flash.geom.Rectangle;

import permissionControlManifestDiscriptor.PermissionControl;

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

        PermissionControl.controlDescriptorForMasks();

        target = Target ;
        maskArea = MaskArea ;

        var mask:Quad = new Quad(maskArea.width,maskArea.height);
        target.mask = mask;
    }

}
}
