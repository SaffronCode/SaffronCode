package otherPlatforms.tablighan
	//otherPlatforms.tablighan.TablighanBanner
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.text.TextField;
	
	import permissionControlManifestDiscriptor.PermissionControl;
	
	import stageManager.StageManager;
	
	/**First you need to call TablighanBanner.setUp() function to pass main url for the Tablighan server, then pass it to the initialize function or add a textField to the object and pass the Tablighan id to it*/
	public class TablighanBanner extends MovieClip
	{
		private static var myDomain:String ;
		//private var Tablighanmc:MovieClip;
		//private static var swList:Vector.<SWObject> = new Vector.<SWObject>();
		
		public static var userAbsoluteNativeBrowser:Boolean = true ; 
		
		private var BannerId:String ;
		
		internal var mySW:SWObject ;
		
		private var isSatUpOnce:Boolean ;
		
		/**First you need to call TablighanBanner.setUp() function to pass main url for the Tablighan server, then pass it to the initialize function or add a textField to the object and pass the Tablighan id to it*/
		public function TablighanBanner(Width:Number=0,Height:Number=0,bannerId:String=null)
		{
			super();
			
			if(!isSatUpOnce)
			{
				PermissionControl.VideoTagForStageWebView();
				if(DevicePrefrence.isItPC)
					userAbsoluteNativeBrowser = false ; 
				isSatUpOnce = true ;
			}
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
					bannerId = idTFandroid.text
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
			//Debug line
				mySW = null ;
			/*for(var i:int = 0 ; i<swList.length ; i++)
			{
				if(swList[i].id == BannerId)
				{
					mySW = swList[i] ;
					break;
				}
			}*/
			if(mySW==null)
			{
				var newSW:SWObject = new SWObject(BannerId,userAbsoluteNativeBrowser);
				//swList.push(newSW);
				mySW = newSW ;
			}
			//if(mySW.isLoaded == false)
			//{
				mySW.load(myDomain,"&individual=true&App=true");
			//}
			
			updateMyPlace(null);
			
			this.addEventListener(Event.ENTER_FRAME,updateMyPlace);
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			//Tablighanmc.height = this.y
		}
		
		/**Removed from stage*/
		protected function unLoad(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME,updateMyPlace);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			mySW.sw.stage = null ;
			mySW.sw.dispose();
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
			/*if(false && userAbsoluteNativeBrowser)
			{
				//mySW.sw.viewPort = StageManager.createViewPortForNatives(this.getBounds(stage));
			}
			else
			{*/
			var rect:Rectangle = this.getBounds(stage); 
				rect.x = Math.round(rect.x);
				rect.y = Math.round(rect.y);
				rect.width = Math.round(rect.width);
				rect.height = Math.round(rect.height);
			mySW.sw.viewPort = rect ;
			//}
		}
		
	//////////////////////////////////////////////////////
		
		/**http://185.83.208.175:9095/api/feed?HostId=1d9163b3-fd60-415a-be59-6e92f832ff23*/
		private static function setDomain():void
		{
			myDomain = 'http://api.tablighon.com/'+"api/feed?HostId=" ;
		}
	}
}