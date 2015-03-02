package appManager.mains
{
	import contents.Contents;
	import contents.ContentsEvent;
	
	import flash.display.MovieClip;
	
	public class AppWithContent extends App
	{
		public function AppWithContent(supportsMultiLanguage:Boolean=false)
		{
			super();
			
			stopIntro();
			//Multilanguage support added to current version.
			Contents.setUp(startApp,supportsMultiLanguage,this.stage);
		}
		
		/**Contents are load now*/
		protected function startApp()
		{
			stage.dispatchEvent(new ContentsEvent());
			playIntro();
		}
	}
}