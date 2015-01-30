package appManager.mains
{
	import contents.ContentsEvent;
	
	import flash.display.MovieClip;
	import contents.Contents;
	
	public class AppWithContent extends App
	{
		public function AppWithContent()
		{
			super();
			
			stopIntro();
			Contents.setUp(startApp);
		}
		
		/**Contents are load now*/
		protected function startApp()
		{
			stage.dispatchEvent(new ContentsEvent());
			playIntro();
		}
	}
}