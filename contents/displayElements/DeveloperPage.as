package contents.displayElements
	//contents.displayElements.DeveloperPage
{
	import contents.Contents;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	
	import popForm.PopMenu;
	
	public class DeveloperPage extends MovieClip
	{
		private var storeMC:MovieClip,
					closeMC:MovieClip,
					appNameTF:TextField;
					
		private var appNameContainerMC:MovieClip ;
					
		private var versionTF:TextField ;
					
		/*[Embed(source="src/AppIconsForPublish/128.png")]
		private var applicationIcon:Class;*/
		
		public function DeveloperPage()
		{
			super();
			
			/*var appIcon:Bitmap = new applicationIcon();
			appIcon.smoothing = true ;
			this.addChild(appIcon);*/
			
			
			storeMC = Obj.get("store_mc",this);
			closeMC = Obj.get("close_mc",this);
			appNameTF = Obj.get("app_name_txt",this);
			versionTF = Obj.get("version_txt",this);
			
			storeMC.buttonMode = true ;
			closeMC.buttonMode = true ;
			
			storeMC.addEventListener(MouseEvent.CLICK,openTheStore);
			closeMC.addEventListener(MouseEvent.CLICK,justClosePopMenu);
			
			appNameContainerMC = new  MovieClip();
			this.addChild(appNameContainerMC);
			appNameContainerMC.x = appNameTF.x ;
			appNameContainerMC.y = appNameTF.y ;
			appNameContainerMC.addChild(appNameTF);
			appNameTF.x = appNameTF.y = 0 ;
			
			TextPutter.OnButton(appNameTF,DevicePrefrence.appName,true,true,false,false);
			if(versionTF)
			{
				versionTF.text = DevicePrefrence.appVersion ;
			}
		}
		
		protected function justClosePopMenu(event:MouseEvent):void
		{
			PopMenu.close();
		}
		
		protected function openTheStore(event:MouseEvent):void
		{
			var rankPageURL:String = '' ;
			if(DevicePrefrence.isIOS())
			{
				rankPageURL = DevicePrefrence.downloadLink_iOS ;
			}
			else
			{
				if(DevicePrefrence.downloadLink_playStore!='')
				{
					rankPageURL = DevicePrefrence.downloadLink_playStore;
				}
				else if(DevicePrefrence.downloadLink_cafeBazar!='')
				{
					rankPageURL = DevicePrefrence.downloadLink_cafeBazar;
				}
				else if(DevicePrefrence.downloadLink_myketStore!='')
				{
					rankPageURL = DevicePrefrence.downloadLink_myketStore;
				}
			}
			if(rankPageURL!='')
			{
				navigateToURL(new URLRequest(rankPageURL));
			}
		}
	}
}