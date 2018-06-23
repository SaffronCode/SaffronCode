package nativeClasses.cameraUI
{
	/*import com.distriqt.extension.cameraui.AuthorisationStatus;
	import com.distriqt.extension.cameraui.CameraUI;
	import com.distriqt.extension.cameraui.CameraUIOptions;
	import com.distriqt.extension.cameraui.MediaType;
	import com.distriqt.extension.cameraui.QualityType;
	import com.distriqt.extension.cameraui.events.AuthorisationEvent;
	import com.distriqt.extension.cameraui.events.CameraUIEvent;*/
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;

	public class DistriqtCameraUI
	{
		/**com.distriqt.extension.cameraui.AuthorisationStatus*/
		private static var AuthorisationStatusC:Class ;
		/**com.distriqt.extension.cameraui.CameraUI*/
		private static var CameraUIC:Class ;
		/**com.distriqt.extension.cameraui.CameraUIOptions*/
		private static var CameraUIOptionsC:Class ;
		/**com.distriqt.extension.cameraui.MediaType*/
		private static var MediaTypeC:Class ;
		/**com.distriqt.extension.cameraui.QualityType*/
		private static var QualityTypeC:Class ;
		/**com.distriqt.extension.cameraui.events.AuthorisationEvent*/
		private static var AuthorisationEventC:Class ;
		/**com.distriqt.extension.cameraui.events.CameraUIEvent*/
		private static var CameraUIEventC:Class ;
		
		
		public static var fileByte:ByteArray;
		private static var onDone:Function;
		
		public static function setUp(APPLICATION_KEY:String):void
		{
			if(!isSupport())
			{
				trace("* Distriqt classes are not working here.");
				return ;
			}
			try
			{
				(CameraUIC as Object).init( APPLICATION_KEY );
				if (CameraUIC.isSupported)
				{
					trace("******** Distriqt is sat up *********");
				}
			}
			catch (e:Error)
			{
				trace( "*** Distriqt camera UI not support : "+e );
			}
		}
		
		/**Create classes*/
		private static function createClasses():void
		{
			if(CameraUIC!=null)
			{
				return ;
			}
			try
			{
				/**com.distriqt.extension.cameraui.AuthorisationStatus*/
				AuthorisationStatusC = getDefinitionByName("com.distriqt.extension.cameraui.AuthorisationStatus") as Class ;
				/**com.distriqt.extension.cameraui.CameraUI*/
				CameraUIC = getDefinitionByName("com.distriqt.extension.cameraui.CameraUI") as Class ;
				/**com.distriqt.extension.cameraui.CameraUIOptions*/
				CameraUIOptionsC = getDefinitionByName("com.distriqt.extension.cameraui.CameraUIOptions") as Class ;
				/**com.distriqt.extension.cameraui.MediaType*/
				MediaTypeC = getDefinitionByName("com.distriqt.extension.cameraui.MediaType") as Class ;
				/**com.distriqt.extension.cameraui.QualityType*/
				QualityTypeC = getDefinitionByName("com.distriqt.extension.cameraui.QualityType") as Class ;
				/**com.distriqt.extension.cameraui.events.AuthorisationEvent*/
				AuthorisationEventC = getDefinitionByName("com.distriqt.extension.cameraui.events.AuthorisationEvent") as Class ;
				/**com.distriqt.extension.cameraui.events.CameraUIEvent*/
				CameraUIEventC = getDefinitionByName("com.distriqt.extension.cameraui.events.CameraUIEvent") as Class ;
			}
			catch(e)
			{
				CameraUIC = null ;
			}
		}
		
		public static function captureVideo(OnDone:Function):void
		{
			onDone = OnDone ;
			controllPermission();
		}
		
			private static function controllPermission():void
			{
				if(CameraUIC.service.hasAuthorisation())
				{
					startCapture(null);
					return ;
				}
				CameraUIC.service.addEventListener( (AuthorisationEventC as Object).CHANGED, startCapture );
				
				switch (CameraUIC.service.authorisationStatus())
				{
					case (AuthorisationStatusC as Object).SHOULD_EXPLAIN:
					case (AuthorisationStatusC as Object).NOT_DETERMINED:
						trace("** REQUEST ACCESS: This will display the permission dialog **");
						(CameraUIC as Object).service.requestAuthorisation();
						return;
						
					case (AuthorisationStatusC as Object).DENIED:
					case (AuthorisationStatusC as Object).UNKNOWN:
					case (AuthorisationStatusC as Object).RESTRICTED:
						trace("** ACCESS DENIED: You should inform your user appropriately **")
						return;
						
					case (AuthorisationStatusC as Object).AUTHORISED:
						trace("** AUTHORISED: Camera will be available **");
						break;						
				}
				
				trace("** Distriqt camera ui : (CameraUIC as Object).service.requestAuthorisation(); ");
				(CameraUIC as Object).service.requestAuthorisation();
			}	
				
				
				/**AuthorisationEvent*/
				private static function startCapture( event:* ):void
				{
					trace( "(AuthorisationStatusC as Object)_changedHandler: "+event );
					(CameraUIC as Object).service.addEventListener( (CameraUIEventC as Object).COMPLETE, cameraUI_completeHandler );
					(CameraUIC as Object).service.addEventListener( (CameraUIEventC as Object).CANCEL, cameraUI_cancelHandler );
					
					var options:* = new CameraUIOptionsC();
					options.videoQuality = (QualityTypeC as Object).TYPE_LOW;
					options.videoMaximumDuration = 60 ;
					trace("Launch the camera");
					(CameraUIC as Object).service.launch( (MediaTypeC as Object).VIDEO, options );
						
				}
				
				
					/**Video loaded event:CameraUIEventC*/
					private static function cameraUI_completeHandler( event:* ):void
					{
						trace("** camera closed **");
						(CameraUIC as Object).service.removeEventListener( (CameraUIEventC as Object).COMPLETE, cameraUI_completeHandler );
						(CameraUIC as Object).service.removeEventListener( (CameraUIEventC as Object).CANCEL, cameraUI_cancelHandler );
						fileByte = FileManager.loadFile(new File(event.path));
						trace("*** The file size is : "+fileByte.length);
						onDone();
					}
					
					/**Camera closed by user. event:CameraUIEventC*/
					private static function cameraUI_cancelHandler( event:* ):void
					{
						(CameraUIC as Object).service.removeEventListener( (CameraUIEventC as Object).COMPLETE, cameraUI_completeHandler );
						(CameraUIC as Object).service.removeEventListener( (CameraUIEventC as Object).CANCEL, cameraUI_cancelHandler );
						trace( "user cancel" );
					}
		
		public static function isSupport():Boolean
		{
			createClasses();
			return CameraUIC!=null && CameraUIC.isSupported ;
		}
	}
}