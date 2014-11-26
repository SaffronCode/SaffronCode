package appManager.mains
{
	import contents.Contents;
	import contents.ContentsEvent;
	
	import flash.display.MovieClip;
	
	public class AppWithContent extends App
	{
		public function AppWithContent()
		{
			super();
			
			Contents.setUp(startApp);
			
			stopIntro();
		}
		
		/**Contents are load now*/
		protected function startApp()
		{
			stage.dispatchEvent(new ContentsEvent());
			playIntro();
		}
	}
}