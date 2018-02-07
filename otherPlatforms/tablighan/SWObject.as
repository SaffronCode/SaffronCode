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
		
		private var userAbsoluteNativeBrowser:Boolean ;
		
		public function SWObject(Id:String,UserAbsoluteNativeBrowser:Boolean)
		{
			id = Id ;
			sw = new StageWebView(UserAbsoluteNativeBrowser);
			sw.addEventListener(Event.COMPLETE,bannerLoaded);
			userAbsoluteNativeBrowser = UserAbsoluteNativeBrowser ;
		}
		
		protected function preventChanging(event:LocationChangeEvent):void
		{
			trace("*** Request to change the location : "+event.location);
			trace("firstLocation " +firstLocation);
			trace("event.location " +event.location);
			if(firstLocation!=event.location)
			{
				trace("*** Change the location");
				navigateToURL(new URLRequest(event.location));
				if(userAbsoluteNativeBrowser)
				{
					sw.stop();
					sw.loadURL(firstLocation);
				}
				else
				{
					sw.reload();
				}
			}
			else
			{
				trace("*** Prevent page change...");
			}
		}
		
		protected function bannerLoaded(event:Event):void
		{
			firstLocation = sw.location ;
			isLoaded = true ;
			sw.addEventListener(LocationChangeEvent.LOCATION_CHANGE,preventChanging);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function load(domain:String,moreParams:String=''):void
		{
			sw.removeEventListener(LocationChangeEvent.LOCATION_CHANGE,preventChanging);
			sw.mediaPlaybackRequiresUserAction = false ;
			isLoaded = true ;
			if(false)
			{
				//sw.loadURL("https://unsplash.it/768/150/?random");
				sw.loadURL("https://www.google.de/?gfe_rd=cr&dcr=0&ei=iIxgWpfFKPCP8QeQporgBw");
			}
			else
			{
				sw.loadURL(domain+id+moreParams);
			}
			//sw.reload();
		}
		
		public function reload():void
		{
			sw.removeEventListener(LocationChangeEvent.LOCATION_CHANGE,preventChanging);
			sw.reload();
		}
	}
}