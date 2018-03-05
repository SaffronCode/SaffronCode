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
	
	public static function controlURLShemePermission(URISchemId:String):void
	{
		var neceraryLines:String = '•' ;
		
		var AndroidPermission:String = 	neceraryLines+'<activity>\n'+
										neceraryLines+'\t<intent-filter>\n'+
										'\t\t<action android:name="android.intent.action.MAIN"/>\n'+
										'\t\t<category android:name="android.intent.category.LAUNCHER"/>\n'+
										neceraryLines+'\t</intent-filter>\n'+
										neceraryLines+'\t<intent-filter>\n'+
										'\t\t<action android:name="android.intent.action.VIEW"/>\n'+
										'\t\t<category android:name="android.intent.category.BROWSABLE"/>\n'+
										'\t\t<category android:name="android.intent.category.DEFAULT"/>\n'+
										'\t\t<data android:scheme="'+URISchemId+'"/>\n'+
										neceraryLines+'\t</intent-filter>\n'+
										neceraryLines+'</activity>\n\n';
		
		var hintText:String = ("You have to add below permissions to the prject manifest on <android><manifestAdditions><![CDATA[... <:\n\n\n");
		var appleHintText:String = ("You have to add below permissions to the prject manifest <iPhone><InfoAdditions><![CDATA[... :\n\n\n");
		
		var isNessesaryToShow:Boolean ;
		
		var descriptString:String = StringFunctions.clearSpacesAndTabsAndArrows(DevicePrefrence.appDescriptor.toString()) ; 
		
		var allSplittedPermission:Array = AndroidPermission.split('\n');
		var leftPermission:String = '' ;
		var androidManifestMustUpdate:Boolean = false ;
		for(var i:int = 0 ; i<allSplittedPermission.length ; i++)
		{
			isNessesaryToShow = isNessesaryLine(allSplittedPermission[i]);
			if(descriptString.indexOf(StringFunctions.clearSpacesAndTabsAndArrows(removeNecessaryBoolet(allSplittedPermission[i])))==-1)
			{
				trace("I couldnt find : "+allSplittedPermission[i]);
				androidManifestMustUpdate = true ;
				leftPermission += removeNecessaryBoolet(allSplittedPermission[i])+'\n' ;
			}
			else if(isNessesaryToShow)
			{
				leftPermission += removeNecessaryBoolet(allSplittedPermission[i])+'\n' ;
			}
			else
			{
				//leftPermission += '-'+allAndroidPermission[i]+'\n' ;
			}
		}
		
		function isNessesaryLine(line:String):Boolean
		{
			return line.indexOf(neceraryLines)!=-1 ;
		}
		
		function removeNecessaryBoolet(line:String):String
		{
			return line.split(neceraryLines).join('') ;
		}
		
		if(androidManifestMustUpdate)
			Caution(hintText+leftPermission);
		
		
		var appleURLPermision:String = 		neceraryLines+'<key>CFBundleURLTypes</key>\n'+
											neceraryLines+'\t<array>\n'+
											neceraryLines+'\t\t<dict>\n'+
											neceraryLines+'\t\t\t<key>CFBundleURLName</key>\n'+
											'\t\t\t<string>'+DevicePrefrence.appID+'</string>\n'+
											neceraryLines+'\t\t\t<key>CFBundleURLSchemes</key>\n'+
											neceraryLines+'\t\t\t<array>\n'+
											'\t\t\t\t<string>'+URISchemId+'</string>\n'+
											neceraryLines+'\t\t\t</array>\n'+
											neceraryLines+'\t\t</dict>\n'+
											neceraryLines+'\t</array>\n\n';
		
		allSplittedPermission = appleURLPermision.split('\n');
		leftPermission = '' ;
		var appleManifestMustUpdate:Boolean = false ;
		
		for(i = 0 ; i<allSplittedPermission.length ; i++)
		{
			isNessesaryToShow = isNessesaryLine(allSplittedPermission[i]);
			if(descriptString.indexOf(StringFunctions.clearSpacesAndTabsAndArrows(removeNecessaryBoolet(allSplittedPermission[i])))==-1)
			{
				trace("I couldnt find : "+allSplittedPermission[i]);
				appleManifestMustUpdate = true ;
				leftPermission += removeNecessaryBoolet(allSplittedPermission[i])+'\n' ;
			}
			else if(isNessesaryToShow)
			{
				leftPermission += removeNecessaryBoolet(allSplittedPermission[i])+'\n' ;
			}
			else
			{
				//leftPermission += '-'+allAndroidPermission[i]+'\n' ;
			}
		}

		if(appleManifestMustUpdate)
			Caution(appleHintText+leftPermission);
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
	
	/**Returns '' if the native was added to the project befor otherwise it return the required line of extensionID*/
	public static function checkTheNativeLibrary(nativeLibraryName:String):String
	{
		var descriptString:String = StringFunctions.clearSpacesAndTabsAndArrows(DevicePrefrence.appDescriptor.toString()) ;
		var requiredParameterOnManifest:String = "<extensionID>"+nativeLibraryName+"</extensionID>" ;
		if(descriptString.indexOf(requiredParameterOnManifest)==-1)
		{
			return requiredParameterOnManifest ;
		}
		else
		{
			return '' ;
		}
	}
	
	/**Control the video tag on the stage*/
	public static function VideoTagForStageWebView():void
	{
		if(DevicePrefrence.isItPC && DevicePrefrence.appDescriptor.toString().indexOf("<android>")!=-1 &&  DevicePrefrence.appDescriptor.toString().indexOf('android:hardwareAccelerated="true')==-1)
		{
			throw 'You have to add below permition to Android manifest to make StageVideo works:\n<application android:enabled="true" android:hardwareAccelerated="true"/>\n\nor\n\n<application android:enabled="true" android:hardwareAccelerated="true">'
		}
	}
}
}
