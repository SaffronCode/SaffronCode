package otherPlatforms.tablighan
	//otherPlatforms.tablighan.TablighanBanner
{
	import appManager.displayContentElemets.LightImage;
	
	import contents.alert.Alert;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.Font;
	import flash.text.TextField;
	
	import permissionControlManifestDiscriptor.PermissionControl;
	
	import restDoaService.RestDoaEvent;
	
	/**First you need to call TablighanBanner.setUp() function to pass main url for the Tablighan server, then pass it to the initialize function or add a textField to the object and pass the Tablighan id to it*/
	public class TablighanBanner extends MovieClip
	{
		private var BannerId:String ;
		
		private var service_tablighanAPI:TablighanAPI ;
		
		private var bannerImage:LightImage ;
		
		/**First you need to call TablighanBanner.setUp() function to pass main url for the Tablighan server, then pass it to the initialize function or add a textField to the object and pass the Tablighan id to it*/
		public function TablighanBanner(Width:Number=0,Height:Number=0,bannerId:String=null)
		{
			super();
			
			
			if(Width==0 || Height==0)
			{
				Width = this.width;
				Height = this.height ;
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
			this.removeChildren();
			if(Width!=0 && Height!=0)
			{
				this.graphics.beginFill(0xff0000,0);
				this.graphics.drawRect(0,0,Width/this.scaleX,Height/this.scaleY);
			}
			bannerImage = new LightImage(0x000000,0);
			this.addChild(bannerImage);
			
			BannerId = bannerId ;
			loadService();
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE,loadService);
			this.addEventListener(MouseEvent.CLICK,openURL);
			this.buttonMode = true ;
		}
		
		protected function openURL(event:MouseEvent):void
		{
			if(service_tablighanAPI.data.length>0)
			{
				navigateToURL(new URLRequest(service_tablighanAPI.data[0].ReferenceURL));
			}
		}
		
			private function loadService(e:*=null):void
			{
				if(service_tablighanAPI)
				{
					service_tablighanAPI.cansel();
					service_tablighanAPI = null ;
				}
				service_tablighanAPI = new TablighanAPI();
				service_tablighanAPI.addEventListener(RestDoaEvent.SERVER_RESULT,tablighanLoaded);
				service_tablighanAPI.addEventListener(RestDoaEvent.CONNECTION_ERROR,reloadTablighan);
				
				this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
				
				service_tablighanAPI.load(BannerId);
			}
		
				protected function reloadTablighan(event:Event):void
				{
					service_tablighanAPI.reLoad(10000);
				}
		
		protected function tablighanLoaded(event:Event):void
		{
			if(service_tablighanAPI.data.length>0)
			{
				//bannerImage.setUp("http://tablighon.com/Uploads/"+service_tablighanAPI.data[0].AdFileName,true,this.width/this.scaleX,this.height/this.scaleY,0,0,false);
				bannerImage.setUp("http://tablighon.com/Uploads/ab643bb7-eb23-490c-b983-a66703e7207e.jpg?"+new Date().time,true,this.width/this.scaleX,this.height/this.scaleY,0,0,false);;
			}
		}
		
		/**Removed from stage*/
		protected function unLoad(event:Event):void
		{
			service_tablighanAPI.cansel();
			NativeApplication.nativeApplication.removeEventListener(Event.ACTIVATE,loadService);
		}
		
		
	}
}