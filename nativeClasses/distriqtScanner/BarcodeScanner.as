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
					trace("Distriqt Scanner supports");
				}
			}
			catch (e:Error)
			{
				trace( "District Scanner unsupport" );
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
				trace("********* You should receive a paramerer throw your onScanned *********");
			}
			
			if (Scanner.isSupported)
			{
				trace( "Scanner Authorisation Status: " + Scanner.service.authorisationStatus() );
				Scanner.service.addEventListener( AuthorisationEvent.CHANGED, authorisationChangedHandler );
				switch (Scanner.service.authorisationStatus())
				{
					case AuthorisationStatus.NOT_DETERMINED:
					case AuthorisationStatus.SHOULD_EXPLAIN:
						trace( " REQUEST ACCESS: This will display the permission dialog");
						Scanner.service.requestAccess();
						return;
						
					case AuthorisationStatus.DENIED:
					case AuthorisationStatus.UNKNOWN:
					case AuthorisationStatus.RESTRICTED:
						trace( "ACCESS DENIED: You should inform your user appropriately");
						return;
						
					case AuthorisationStatus.AUTHORISED:
						trace( "AUTHORISED: Scanner will be available");
						break;						
				}
				
				trace("I'm ready for your test");
				
				startScanning();
			}
			else
			{
				trace("I'm not supporting your device");
			}
		}
		
		
		private function authorisationChangedHandler( event:AuthorisationEvent ):void
		{
			switch (event.status)
			{
				case AuthorisationStatus.SHOULD_EXPLAIN:
					trace("Should display a reason you need this feature");
					break;
				
				case AuthorisationStatus.AUTHORISED:
					trace("AUTHORISED: Camera will be available");
					startScanning();
					break;
				
				case AuthorisationStatus.RESTRICTED:
				case AuthorisationStatus.DENIED:
					trace("ACCESS DENIED: You should inform your user appropriately");
					break;
			}
		}
		
		protected function startScanning():void
		{
			Scanner.service.addEventListener( ScannerEvent.CODE_FOUND, codeFoundHandler );
			Scanner.service.addEventListener( ScannerEvent.SCAN_START,backToHome);
			
			var options:ScannerOptions = new ScannerOptions();
			options.singleResult = true;
			options.colour = ButtonColor;
			options.cancelLabel = CancelButtonLabel;
			options.symbologies = [] ;
			
			Scanner.service.startScan( options );
		}
		
		protected function backToHome(event:Event):void
		{
			trace("Scanner oppened");
		}
		
		private function codeFoundHandler( event:ScannerEvent ):void
		{
			trace("Data scanned : "+event.data);
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




