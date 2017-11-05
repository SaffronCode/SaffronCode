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
			Caution("You have to set <depthAndStencil>true</depthAndStencil>  to true to make masks works on starling.\n\n\n\n");
        }
    }
	
	/**Controll the video black screen problem*/
	public static function controlVideoProblem():void
	{
		var appXML:String = StringFunctions.clearSpacesAndTabs(DevicePrefrence.appDescriptor);
		if(appXML.indexOf("<containsVideo>true</containsVideo>")==-1)
		{
			Caution("You have to set <containsVideo>true</containsVideo> to true inside the <android></android> tag to prevent black screen bug\n\n\n\n");
		}
		
	}
	
	private static function Caution(str:String):void
	{
		if(DevicePrefrence.isItPC)
		{
			throw str ;
		}
		else
		{
			trace('***********************************************************');
			trace('***********************************************************');
			trace('***********************************************************');
			trace('***********************************************************\n\n');
			trace(str+'\n\n');
			trace('***********************************************************');
			trace('***********************************************************');
			trace('***********************************************************');
			trace('***********************************************************');
		}
	}
}
}
