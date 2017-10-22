/**
 * Created by mes on 22/10/2017.
 */
package permissionControlManifestDiscriptor {
import com.mteamapp.StringFunctions;

/**You can pass all permission controls to this class to check the manifest file*/
public class PermissionControl {


    /**Controlls mask descriptor*/
    public static function controlDescriptorForMasks():void {
        var appXML:String = StringFunctions.clearSpacesAndTabs(DevicePrefrence.appDescriptor);
        if(appXML.indexOf("<depthAndStencil>true</depthAndStencil>")==-1)
        {
            throw "You have to set <depthAndStencil>true</depthAndStencil>  to true to make masks works on starling."
        }
    }
}
}
