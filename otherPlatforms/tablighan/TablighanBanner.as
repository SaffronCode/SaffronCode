package otherPlatforms.tablighan
	//otherPlatforms.tablighan.TablighanBanner
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.StageWebView;
	import flash.text.TextField;
	
	/**First you need to call TablighanBanner.setUp() function to pass main url for the Tablighan server, then pass it to the initialize function or add a textField to the object and pass the Tablighan id to it*/
	public class TablighanBanner extends MovieClip
	{
		private static var myDomain:String ;
		
		private static var swList:Vector.<SWObject> = new Vector.<SWObject>();
		
		private var BannerId:String ;
		
		internal var mySW:SWObject ;
		
		/**First you need to call TablighanBanner.setUp() function to pass main url for the Tablighan server, then pass it to the initialize function or add a textField to the object and pass the Tablighan id to it*/
		public function TablighanBanner(Width:Number=0,Height:Number=0,bannerId:String=null)
		{
			super();
			if(Width!=0 && Height!=0)
			{
				this.graphics.beginFill(0,0);
				this.graphics.drawRect(0,0,Width,Height);
			}
			
			if(bannerId==null)
			{
				var idTF:TextField = Obj.findThisClass(TextField,this);
				if(idTF!=null)
				{
					bannerId = idTF.text ;
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
			for(var i:int = 0 ; i<swList.length ; i++)
			{
				if(swList[i].id == BannerId)
				{
					mySW = swList[i] ;
					break;
				}
			}
			if(mySW==null)
			{
				var newSW:SWObject = new SWObject(BannerId);
				swList.push(newSW);
				mySW = newSW ;
			}
			if(mySW.isLoaded == false)
			{
				mySW.load(myDomain);
			}
			
			updateMyPlace(null);
			
			this.addEventListener(Event.ENTER_FRAME,updateMyPlace);
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}
		
		/**Removed from stage*/
		protected function unLoad(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME,updateMyPlace);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			mySW.sw.stage = null ;
			mySW.reload();
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
		private static function setDomain():void
		{
			myDomain = 'http://api.tablighon.com/'+"api/feed?HostId=" ;
		}
	}
}