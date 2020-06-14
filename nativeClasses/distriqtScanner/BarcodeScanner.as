package nativeClasses.distriqtScanner
{//EjlasModiran.ui.pages.BarcodeReader
	import com.distriqt.extension.scanner.AuthorisationStatus;
	import com.distriqt.extension.scanner.Scanner;
	import com.distriqt.extension.scanner.ScannerOptions;
	import com.distriqt.extension.scanner.events.AuthorisationEvent;
	import com.distriqt.extension.scanner.events.ScannerEvent;
	
	import flash.events.Event;
	
	public class BarcodeScanner 
	{
		private var CancelButtonLabel:String ;
		private var ButtonColor:uint ;
		private var OnScan:Function ;
		
		public  var lastScannedCode:String;
		
		public function BarcodeScanner(distriqtId:String)
		{
			super();
			try
			{
				Scanner.init(distriqtId);
				if (Scanner.isSupported)
				{
					SaffronLogger.log("Distriqt Scanner supports");
				}
			}
			catch (e:Error)
			{
				SaffronLogger.log( "District Scanner unsupport" );
			}

		}
		
		/**The scanner will put scanned barcode throw the first input of onScanned*/
		public function scan(onScanned:Function,buttonColor:int=0xffffff,cancelButtonLabel:String = "Cancel"):void
		{
			CancelButtonLabel = cancelButtonLabel ;
			OnScan = onScanned ;
			ButtonColor = buttonColor;
			
			if(onScanned.length==0)
			{
				SaffronLogger.log("********* You should receive a paramerer throw your onScanned *********");
			}
			
			if (Scanner.isSupported)
			{
				SaffronLogger.log( "Scanner Authorisation Status: " + Scanner.service.authorisationStatus() );
				Scanner.service.addEventListener( AuthorisationEvent.CHANGED, authorisationChangedHandler );
				switch (Scanner.service.authorisationStatus())
				{
					case AuthorisationStatus.NOT_DETERMINED:
					case AuthorisationStatus.SHOULD_EXPLAIN:
						SaffronLogger.log( " REQUEST ACCESS: This will display the permission dialog");
						Scanner.service.requestAccess();
						return;
						
					case AuthorisationStatus.DENIED:
					case AuthorisationStatus.UNKNOWN:
					case AuthorisationStatus.RESTRICTED:
						SaffronLogger.log( "ACCESS DENIED: You should inform your user appropriately");
						return;
						
					case AuthorisationStatus.AUTHORISED:
						SaffronLogger.log( "AUTHORISED: Scanner will be available");
						break;						
				}
				
				SaffronLogger.log("I'm ready for your test");
				
				startScanning();
			}
			else
			{
				SaffronLogger.log("I'm not supporting your device");
			}
		}
		
		
		private function authorisationChangedHandler( event:AuthorisationEvent ):void
		{
			switch (event.status)
			{
				case AuthorisationStatus.SHOULD_EXPLAIN:
					SaffronLogger.log("Should display a reason you need this feature");
					break;
				
				case AuthorisationStatus.AUTHORISED:
					SaffronLogger.log("AUTHORISED: Camera will be available");
					startScanning();
					break;
				
				case AuthorisationStatus.RESTRICTED:
				case AuthorisationStatus.DENIED:
					SaffronLogger.log("ACCESS DENIED: You should inform your user appropriately");
					break;
			}
		}
		
		protected function startScanning():void
		{
			Scanner.service.addEventListener( ScannerEvent.CODE_FOUND, codeFoundHandler );
			Scanner.service.addEventListener( ScannerEvent.SCAN_START,backToHome);
			
			var options:ScannerOptions = new ScannerOptions();
			options.singleResult = true;
			options.torchMode = "off";
			//options.colour = ButtonColor;
			//options.cancelLabel = CancelButtonLabel;
			//options.symbologies = [] ;
			
			Scanner.service.startScan( options );
		}
		
		protected function backToHome(event:Event):void
		{
			SaffronLogger.log("Scanner oppened");
		}
		
		private function codeFoundHandler( event:ScannerEvent ):void
		{
			SaffronLogger.log("Data scanned : "+event.data);
			lastScannedCode = event.data ;
			if(OnScan.length>0)
			{
				OnScan(event.data);
			}
			else
			{
				OnScan();
			}
		}
	}
}




