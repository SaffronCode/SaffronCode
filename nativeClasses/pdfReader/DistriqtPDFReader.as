package nativeClasses.pdfReader
{
	
	//import com.distriqt.extension.pdfreader.PDFReader;
	//import com.distriqt.extension.pdfreader.builders.PDFViewBuilder;
	//import com.distriqt.extension.pdfreader.events.PDFViewEvent;
	import com.mteamapp.StringFunctions;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	import permissionControlManifestDiscriptor.PermissionControl;
	
	import stageManager.StageManager;
	
	public class DistriqtPDFReader extends Sprite
	{
		private static var satUp:Boolean = false ;
		
		/**import com.distriqt.extension.pdfreader.PDFReader*/
		private static var PDFReaderClass:Class ;
		
		/**com.distriqt.extension.pdfreader.builders.PDFViewBuilder*/
		private static var PDFViewBuilderClass:Class
		
		public static var isSupport:Boolean = false ;

		private var view:*;
		
		
		private static var 	scl:Number = 0,
							deltaX:Number,
							deltaY:Number;
							private var isShowing:Boolean;
							private var lastArea:Rectangle;
		
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
				PDFReaderClass = getDefinitionByName("com.distriqt.extension.pdfreader.PDFReader") as Class ;
				PDFViewBuilderClass = getDefinitionByName("com.distriqt.extension.pdfreader.builders.PDFViewBuilder") as Class ;
				(PDFReaderClass as Object).init( DistriqtId );
				if ((PDFReaderClass as Object).isSupported)
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
			this.graphics.beginFill(0xffffff,1);
			this.graphics.drawRect(0,0,W,H);
		}
		
		public function dispose():void
		{
			//TODO dispose the pdf
			this.removeEventListener(Event.ENTER_FRAME,updatePDFPosition);
			if(view)
			{
				view.dispose();
				view = null ;
			}
		}
		
		private function createViewPort():Rectangle
		{
			var rect:Rectangle = this.getBounds(stage);
			//trace("****Create view port");
			if(scl==0)
			{
				var stageRect:Rectangle = StageManager.stageRect ;
				trace("stageRect : "+stageRect);
				var sclX:Number ;
				var sclY:Number ;
				deltaX = 0 ;
				deltaY = 0 ;
				var _fullScreenWidth:Number,
				_fullScreenHeight:Number;
				if(stageRect.width==0)
				{
					trace("+++default size detection")
					sclX = (stage.fullScreenWidth/stage.stageWidth);
					sclY = (stage.fullScreenHeight/stage.stageHeight);
					if(sclX<=sclY)
					{
						scl = sclX ;
						deltaY = stage.fullScreenHeight-(stage.stageHeight)*scl ;
					}
					else
					{
						scl = sclY ;
						deltaX = stage.fullScreenWidth-(stage.stageWidth)*scl ;
					}
				}
				else
				{
					trace("+++advvanced size detection");
					_fullScreenWidth = stageRect.width*StageManager.stageScaleFactor() ;
					_fullScreenHeight = stageRect.height*StageManager.stageScaleFactor() ;
					sclX = (_fullScreenWidth/stage.stageWidth);
					sclY = (_fullScreenHeight/stage.stageHeight);
					trace("sclX : "+sclX);
					trace("sclY : "+sclY);
					if(sclX<=sclY)
					{
						scl = sclX ;
						deltaY = _fullScreenHeight-(stage.stageHeight)*scl ;
					}
					else
					{
						scl = sclY ;
						deltaX = _fullScreenWidth-(stage.stageWidth)*scl ;
					}
					trace("deltaX : "+deltaX);
					trace("deltaY : "+deltaY);
					trace("scl : "+scl);
				}
			}
			
			//trace("Old rect : " +rect);
			//trace("scl : "+scl);
			//trace("deltaX : "+deltaX);
			//trace("deltaY : "+deltaY);
			
			rect.x*=scl;
			rect.y*=scl;
			rect.x += deltaX/2;
			rect.y += deltaY/2;
			rect.width*=scl;
			rect.height*=scl;
			
			rect.x = round(rect.x);
			rect.y = round(rect.y);
			rect.width = round(rect.width);
			rect.height = round(rect.height);
			
			//trace("new rect : " +rect);
			
			if(rect.x<0)
			{
				if(-rect.x<rect.width)
				{
					rect.width += rect.x ;
					rect.x = 0 ;
				}
				else
				{
					rect = null ;
				}
			}
			
			if(rect!=null && rect.y<0)
			{
				if(-rect.y<rect.height)
				{
					rect.height += rect.y ;
					rect.y = 0 ;
				}
				else
				{
					rect = null ;
				}
			}
			
			return rect;
		}
		
		private function round(num:Number):Number
		{
			return Math.round(num);
		}
		
		public function openPDF(PDR_URL:String):void
		{
			trace(">>>> > >> > >> > > >> > >Show this pdf : "+PDR_URL);
			//trace("The PDF target is changig with "+(PDR_URL="http://oncolinq.ir/UploadImages/Pdf/Pdf48641pdf%20test.pdf"));
			
			dispose();
			
			view = (PDFReaderClass as Object).service.createView( 
				new PDFViewBuilderClass()
				.setPath( PDR_URL )
				.showDoneButton( false )
				.showTitle( false )
				.setFitMode(1)
				.setScrollDirection(1)
				.showSearch(true)
				.showExport(true)
				.build()
			);
			
			trace("**** **** **** PDFview : "+view);
			
			//view.addEventListener( PDFViewEvent.SHOWN, pdfView_shownHandler );
			//view.addEventListener( PDFViewEvent.HIDDEN, pdfView_hiddenHandler );
			this.addEventListener(Event.ENTER_FRAME,updatePDFPosition);
			lastArea = null ;
			updatePDFPosition();
			
			/*function pdfView_shownHandler( event:PDFViewEvent ):void
			{
				trace( "** ** ** ** * view shown" );
			}
			
			function pdfView_hiddenHandler( event:PDFViewEvent ):void
			{
				trace( "** ** ** ** * view hidden" );
			}*/

		}
		
		/**Set tue pdf position*/
		private function updatePDFPosition(e:*=null):void
		{
			var currentArea:Rectangle = createViewPort();
			
			if(lastArea==null || lastArea.x != currentArea.x || lastArea.y != currentArea.y || lastArea.width != currentArea.width || lastArea.height!=currentArea.height)
				view.setViewport( currentArea.x, currentArea.y, currentArea.width, currentArea.height );
			
			lastArea = currentArea.clone();
			
			if(Obj.isAccesibleByMouse(this))
			{
				if(!isShowing)
					view.show();
				isShowing = true ;
			}
			else
			{
				if(isShowing)
					view.hide();
				isShowing = false ;
			}
		}
	}
}