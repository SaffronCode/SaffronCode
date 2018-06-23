package nativeClasses.cameraUI
{
	import com.distriqt.extension.cameraui.AuthorisationStatus;
	import com.distriqt.extension.cameraui.CameraUI;
	import com.distriqt.extension.cameraui.CameraUIOptions;
	import com.distriqt.extension.cameraui.MediaType;
	import com.distriqt.extension.cameraui.QualityType;
	import com.distriqt.extension.cameraui.events.AuthorisationEvent;
	import com.distriqt.extension.cameraui.events.CameraUIEvent;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public class DistriqtCameraUI
	{
		public static var fileByte:ByteArray;
		private static var onDone:Function;
		
		public static function setUp(APPLICATION_KEY:String):void
		{
			try
			{
				CameraUI.init( APPLICATION_KEY );
				if (CameraUI.isSupported)
				{
					trace("******** Distriqt is sat up *********");
				}
			}
			catch (e:Error)
			{
				trace( "*** Distriqt camera UI not support : "+e );
			}
		}
		
		public static function captureVideo(OnDone:Function):void
		{
			onDone = OnDone ;
			controllPermission();
		}
		
			private static function controllPermission():void
			{
				if(CameraUI.service.hasAuthorisation())
				{
					startCapture(null);
					return ;
				}
				CameraUI.service.addEventListener( AuthorisationEvent.CHANGED, startCapture );
				
				switch (CameraUI.service.authorisationStatus())
				{
					case AuthorisationStatus.SHOULD_EXPLAIN:
					case AuthorisationStatus.NOT_DETERMINED:
						trace("** REQUEST ACCESS: This will display the permission dialog **");
						CameraUI.service.requestAuthorisation();
						return;
						
					case AuthorisationStatus.DENIED:
					case AuthorisationStatus.UNKNOWN:
					case AuthorisationStatus.RESTRICTED:
						trace("** ACCESS DENIED: You should inform your user appropriately **")
						return;
						
					case AuthorisationStatus.AUTHORISED:
						trace("** AUTHORISED: Camera will be available **");
						break;						
				}
				
				trace("** Distriqt camera ui : CameraUI.service.requestAuthorisation(); ");
				CameraUI.service.requestAuthorisation();
			}	
				
				
				private static function startCapture( event:AuthorisationEvent ):void
				{
					trace( "authorisationStatus_changedHandler: "+event );
					CameraUI.service.addEventListener( CameraUIEvent.COMPLETE, cameraUI_completeHandler );
					CameraUI.service.addEventListener( CameraUIEvent.CANCEL, cameraUI_cancelHandler );
					
					var options:CameraUIOptions = new CameraUIOptions();
					options.videoQuality = QualityType.TYPE_LOW;
					options.videoMaximumDuration = 60 ;
					trace("Launch the camera");
					CameraUI.service.launch( MediaType.VIDEO, options );
						
				}
				
				
					/**Video loaded*/
					private static function cameraUI_completeHandler( event:CameraUIEvent ):void
					{
						trace("** camera closed **");
						CameraUI.service.removeEventListener( CameraUIEvent.COMPLETE, cameraUI_completeHandler );
						CameraUI.service.removeEventListener( CameraUIEvent.CANCEL, cameraUI_cancelHandler );
						fileByte = FileManager.loadFile(new File(event.path));
						trace("*** The file size is : "+fileByte.length);
						onDone();
					}
					
					/**Camera closed by user*/
					private static function cameraUI_cancelHandler( event:CameraUIEvent ):void
					{
						CameraUI.service.removeEventListener( CameraUIEvent.COMPLETE, cameraUI_completeHandler );
						CameraUI.service.removeEventListener( CameraUIEvent.CANCEL, cameraUI_cancelHandler );
						trace( "user cancel" );
					}
		
		public static function isSupport():Boolean
		{
			return CameraUI.isSupported ;
		}
	}
}