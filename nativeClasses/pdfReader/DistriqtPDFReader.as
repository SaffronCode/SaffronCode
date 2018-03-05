package nativeClasses.pdfReader
{
	
	import com.distriqt.extension.pdfreader.PDFReader;
	import com.distriqt.extension.pdfreader.builders.PDFViewBuilder;
	import com.distriqt.extension.pdfreader.events.PDFViewEvent;
	import com.mteamapp.StringFunctions;
	
	import flash.display.Sprite;
	
	import permissionControlManifestDiscriptor.PermissionControl;
	
	public class DistriqtPDFReader extends Sprite
	{
		private static var satUp:Boolean = false ;
		
		public static var isSupport:Boolean = false ;
		
		public static function setUp(DistriqtId:String):void
		{
			if(satUp)
				return ;
			
			const neceraryLines:String = '•' ;
			
			var requiredNatives:Array = [	"com.distriqt.PDFReader",
											"com.distriqt.Core",
											"com.distriqt.androidsupport.V4"];
			
			var nativesToAdd:String = '' ;
			
			for(var i:int = 0 ; i<requiredNatives.length ; i++)
			{
				var check:String = PermissionControl.checkTheNativeLibrary(requiredNatives[i]) ; 
				if(check!='')
				{
					nativesToAdd+=check+'\n';
				}
			}
			
			if(nativesToAdd!='')
			{
				trace("******* You should add below extentions to your project for PDF to work\n\n\n"+nativesToAdd+"\n\n\n*********************");
			}
			
		//////////////////////////Android permission check ↓

			var AndroidPermission:String = neceraryLines+'<manifest android:installLocation="auto">\n' +
				'\t<uses-permission android:name="android.permission.INTERNET"/>\n' +
				neceraryLines+'\t<application>\n' +
				'\t\t<activity android:name="com.distriqt.extension.pdfreader.pdfview.activities.OpenPDFActivity" android:theme="@android:style/Theme.Translucent.NoTitleBar" />\n' +
				neceraryLines+'\t\t<provider android:name="android.support.v4.content.FileProvider" android:authorities="air.com.distriqt.test.dt_files" android:grantUriPermissions="true" android:exported="false">\n' +
				'\t\t\t<meta-data android:name="android.support.FILE_PROVIDER_PATHS" android:resource="@xml/distriqt_paths" />\n' +
				neceraryLines+'\t\t</provider>\n' +
				neceraryLines+'\t</application>\n' +
				neceraryLines+'</manifest>';
			
				
			
			var hintText:String = ("You have to add below permissions to the prject manifest on <android><manifestAdditions><![CDATA[... <:\n\n\n");
			var appleHintText:String = ("You have to add below permissions to the prject manifest <iPhone><InfoAdditions><![CDATA[... :\n\n\n");
			
			var isNessesaryToShow:Boolean ;
			
			var descriptString:String = StringFunctions.clearSpacesAndTabsAndArrows(DevicePrefrence.appDescriptor.toString()) ; 
			
			var allSplittedPermission:Array = AndroidPermission.split('\n');
			var leftPermission:String = '' ;

			var appleManifestMustUpdate:Boolean = false ;
			var androidManifestMustUpdate:Boolean = false ;
			
			for(i = 0 ; i<allSplittedPermission.length ; i++)
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
			if(androidManifestMustUpdate)
				PermissionControl.Caution(hintText+leftPermission);
			
			function isNessesaryLine(line:String):Boolean
			{
				return line.indexOf(neceraryLines)!=-1 ;
			}
			
			function removeNecessaryBoolet(line:String):String
			{
				return line.split(neceraryLines).join('') ;
			}
			
			
			var appleURLPermision:String = neceraryLines+'<key>UIDeviceFamily</key>\n' +
				neceraryLines+'<array>\n' +
				neceraryLines+'\t<string>1</string>\n' +
				neceraryLines+'\t<string>2</string>\n' +
				neceraryLines+'</array>\n' +
				'<key>NSAppTransportSecurity</key>\n' +
				neceraryLines+'<dict>\n' +
				'\t<key>NSAllowsArbitraryLoads</key><true/>\n' +
				neceraryLines+'</dict>'	
				
			
			allSplittedPermission = appleURLPermision.split('\n');
			leftPermission = '' ;
			
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
				PermissionControl.Caution(appleHintText+leftPermission);
			
		//////////////////////////Android permission check over ↑
			
			satUp = true ;
			
			
			
			
			
			//////PDF native
			
			try
			{
				PDFReader.init( DistriqtId );
				if (PDFReader.isSupported)
				{
					// Functionality here
					isSupport = true ;
				}
			}
			catch (e:Error)
			{
				trace("*******************\n\n\n"+ e );
				isSupport = false ;
			}

			trace("****\n\n\n\nPDF support status is : "+isSupport+"\n\n\n********");
			
		}
		
		public function DistriqtPDFReader(W:Number,H:Number)
		{
			super();
			this.graphics.beginFill(0xff0000,1);
			this.graphics.drawRect(0,0,W,H);
		}
		
		
		public function openPDF(PDR_URL:String):void
		{
			trace(">>>> > >> > >> > > >> > >Show this pdf : "+PDR_URL);
			
			var view:* = PDFReader.service.createView( 
				new PDFViewBuilder()
				.setPath( PDR_URL )
				.showDoneButton( true )
				.showTitle( false )
				.build()
			);
			
			trace("**** **** **** PDFview : "+view);
			
			view.setViewport( 50, 100, 400, 500 );//TODO
			view.addEventListener( PDFViewEvent.SHOWN, pdfView_shownHandler );
			view.addEventListener( PDFViewEvent.HIDDEN, pdfView_hiddenHandler );
			
			function pdfView_shownHandler( event:PDFViewEvent ):void
			{
				trace( "** ** ** ** * view shown" );
			}
			
			function pdfView_hiddenHandler( event:PDFViewEvent ):void
			{
				trace( "** ** ** ** * view hidden" );
			}

			
			view.show();

		}
	}
}