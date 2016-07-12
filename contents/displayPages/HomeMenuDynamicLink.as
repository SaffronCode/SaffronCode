package contents.displayPages
	//contents.displayPages.HomeMenuDynamicLink
{
	import contents.Contents;
	
	import flash.utils.setTimeout;

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
			setUp(Contents.homePage);
		}
	}
}