package appManager.mains
{
	import contents.Contents;
	import contents.ContentsEvent;
	
	import flash.display.MovieClip;
	
	public class AppWithContent extends App
	{
		/**AutoLanguageConvertion will enabled just when supportsMutilanguage was true*/
		public function AppWithContent(supportsMultiLanguage:Boolean=false,autoLanguageConvertEnabled:Boolean=true)
		{
			super();
			
			stopIntro();
			//Multilanguage support added to current version.
			Contents.setUp(startApp,supportsMultiLanguage,autoLanguageConvertEnabled,this.stage);
		}
		
		/**Contents are load now*/
		protected function startApp()
		{
			stage.dispatchEvent(new ContentsEvent());
			playIntro();
		}
	}
}