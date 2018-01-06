package otherPlatforms.tablighan
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.LocationChangeEvent;
	import flash.media.StageWebView;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	[Event(name="complete", type="flash.events.Event")]
	internal class SWObject extends EventDispatcher
	{
		public var sw:StageWebView ;
		
		public var id:String ;
		
		public var isLoaded:Boolean = false ;
		
		private var firstLocation:String = '' ;
		
		public function SWObject(Id:String)
		{
			id = Id ;
			sw = new StageWebView();
			sw.addEventListener(Event.COMPLETE,bannerLoaded);
		}
		
		protected function preventChanging(event:LocationChangeEvent):void
		{
			trace("*** Request to change the location : "+event.location);
			if(firstLocation!=event.location)
			{
				trace("*** Change the location");
				navigateToURL(new URLRequest(event.location));
			}
			else
			{
				trace("*** Prevent page change...");
			}
			sw.reload();
		}
		
		protected function bannerLoaded(event:Event):void
		{
			firstLocation = sw.location ;
			isLoaded = true ;
			sw.addEventListener(LocationChangeEvent.LOCATION_CHANGE,preventChanging);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function load(domain:String):void
		{
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
			sw.removeEventListener(LocationChangeEvent.LOCATION_CHANGE,preventChanging);
			sw.reload();
		}
	}
}