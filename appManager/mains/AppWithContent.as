package appManager.mains
{
	import appManager.event.AppEvent;
	import appManager.event.AppEventContent;
	
	import contents.Contents;
	import contents.ContentsEvent;
	import contents.History;
	
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
		
		override protected function managePages(event:AppEvent):Boolean
		{
			if(event is AppEventContent)
			{
				var event2:AppEventContent = event as AppEventContent ;
				if(!event2.SkipHistory)
				{
					History.pushHistory((event as AppEventContent).linkData);
				}
			}
			return super.managePages(event);
		}
		
		/**Contents are load now*/
		protected function startApp()
		{
			stage.dispatchEvent(new ContentsEvent());
			playIntro();
		}
	}
}