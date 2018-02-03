package otherPlatforms.tablighan
	//otherPlatforms.tablighan.TablighanBanner
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.StageWebView;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	/**First you need to call TablighanBanner.setUp() function to pass main url for the Tablighan server, then pass it to the initialize function or add a textField to the object and pass the Tablighan id to it*/
	public class TablighanBanner extends MovieClip
	{
		private var myDomain:String ;
		
		private var BannerId:String ;
		
		private var sw:StageWebView ;
		
		private var urlLoader:URLLoader ;
		
		/**First you need to call TablighanBanner.setUp() function to pass main url for the Tablighan server, then pass it to the initialize function or add a textField to the object and pass the Tablighan id to it*/
		public function TablighanBanner(Width:Number=0,Height:Number=0,bannerId:String=null)
		{
			super();
			//Tablighanmc = Obj.get("Tablighan_mc",this);
			if(Width!=0 && Height!=0)
			{
				this.graphics.beginFill(0,0);
				this.graphics.drawRect(0,0,Width,Height);
			}
			
			if(bannerId==null)
			{
				var idTFios:TextField = Obj.get('idTFios_mc',this);
				var idTFandroid:TextField = Obj.get('idTFandroid_mc',this);
				if(idTFios!=null && DevicePrefrence.isIOS() == true)
				{
					bannerId = idTFios.text ;
				}
				else if (idTFandroid!=null && DevicePrefrence.isAndroid() == true)
				{
					bannerId = idTFandroid.text ;
				}
				else
				{
					idTFandroid = Obj.findThisClass(TextField,this);
					bannerId = idTFandroid.text;
				}
			}
			
			if(myDomain==null || bannerId==null)
			{
				//throw "First you need to call TablighanBanner.setUp() function to pass main url for the Tablighan server, then pass it to the initialize function or add a textField to the object and pass the Tablighan id to it" ;
				setDomain();
			}
			this.alpha = 0 ; 
			BannerId = bannerId ;
			controlStage();
		}
		
		private function controlStage():void
		{
			if(stage==null)
			{
				this.addEventListener(Event.ADDED_TO_STAGE,setUp);
			}
			else
			{
				setUp();
			}
		}
		
		/**Set my banner*/
		private function setUp(e:*=null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,setUp);
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			this.addEventListener(Event.ENTER_FRAME,updateMyPlace);
			
			urlLoader = new URLLoader(new URLRequest(myDomain));
			urlLoader.addEventListener(Event.COMPLETE,fullBannerHTMLLoaded);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,reloadURLHTML);
			
			updateMyPlace(null);
		}
		
		protected function fullBannerHTMLLoaded(event:Event):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function reloadURLHTML(event:IOErrorEvent):void
		{
			trace("No internet connection to load stageWebView Content
		}
		
		/**Removed from stage*/
		protected function unLoad(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME,updateMyPlace);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			mySW.sw.stage = null ;
			//mySW.reload();
		}
		
		/**Update place of banner*/
		protected function updateMyPlace(event:Event):void
		{
			if(mySW.isLoaded && Obj.isAccesibleByMouse(this))
			{
				mySW.sw.stage = this.stage ;
			}
			else
			{
				mySW.sw.stage = null ;
			}
			mySW.sw.viewPort = this.getBounds(stage);
		}
		
	//////////////////////////////////////////////////////
		
		/**http://185.83.208.175:9095/api/feed?HostId=1d9163b3-fd60-415a-be59-6e92f832ff23*/
		private function setDomain():void
		{
			myDomain = 'http://api.tablighon.com/'+"api/feed?HostId="+bannerId+"&individual=true" ;
		}
	}
}