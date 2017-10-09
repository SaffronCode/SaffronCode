package otherPlatforms.tablighan
{
	import flash.events.Event;
	import flash.events.LocationChangeEvent;
	import flash.media.StageWebView;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	internal class SWObject
	{
		public var sw:StageWebView ;
		
		public var id:String ;
		
		public var isLoaded:Boolean = false ;
		
		public function SWObject(Id:String)
		{
			id = Id ;
			sw = new StageWebView();
			sw.addEventListener(Event.COMPLETE,bannerLoaded);
		}
		
		protected function preventChanging(event:LocationChangeEvent):void
		{
			trace("Request to change the location : "+event.location);
			navigateToURL(new URLRequest(event.location));
			sw.reload();
		}
		
		protected function bannerLoaded(event:Event):void
		{
			isLoaded = true ;
			sw.addEventListener(LocationChangeEvent.LOCATION_CHANGING,preventChanging);
			sw.addEventListener(LocationChangeEvent.LOCATION_CHANGE,preventChanging);
		}
		
		public function load(domain:String):void
		{
			sw.removeEventListener(LocationChangeEvent.LOCATION_CHANGING,preventChanging);
			sw.removeEventListener(LocationChangeEvent.LOCATION_CHANGE,preventChanging);
			isLoaded = false ;
			if(false)
			{
				//sw.loadURL("https://unsplash.it/768/150/?random");
				sw.loadURL("https://www.google.com/");
			}
			else
			{
				sw.loadURL(domain+id);
			}
		}
		
		public function reload():void
		{
			sw.removeEventListener(LocationChangeEvent.LOCATION_CHANGING,preventChanging);
			sw.removeEventListener(LocationChangeEvent.LOCATION_CHANGE,preventChanging);
			sw.reload();
		}
	}
}