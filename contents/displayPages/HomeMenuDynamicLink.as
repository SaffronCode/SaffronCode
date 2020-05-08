package contents.displayPages
	//contents.displayPages.HomeMenuDynamicLink
{
	import contents.Contents;
	
	import flash.utils.setTimeout;
	import contents.alert.Alert;

	public class HomeMenuDynamicLink extends DynamicLinks
	{
		public function HomeMenuDynamicLink()
		{
			super();
			setTimeout(loadHomeMenu,0);
		}
		
		private function loadHomeMenu():void
		{
			height = Contents.config.stageRect.height-this.y ;
			if(this.name.indexOf('instance')==-1)
			{
				setUp(Contents.getPage(this.name));
			}
			else
			{
				setUp(Contents.homePage);
			}
		}
	}
}