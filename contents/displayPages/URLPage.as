package contents.displayPages
	//contents.displayPages.URLPage
{
	import contents.PageData;
	import contents.interFace.DisplayPageInterface;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.StageWebView;
	
	public class URLPage extends MovieClip implements DisplayPageInterface
	{
		private static var sw:StageWebView = new StageWebView();
		private var myPage:PageData;
		
		public function URLPage()
		{
			super();
			this.visible = false ;
		}
		
		public function setUp(pageData:PageData):void
		{
			myPage = pageData ;
			controllStage();
		}
		
		private function controllStage(e:Event=null)
		{
			if(this.stage!=null)
			{
				createHTMLPage();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE,controllStage);
			}
		}
		
		private function createHTMLPage()
		{
			sw.stage = stage ;
			controllStagePlace();
			sw.loadURL(myPage.content);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			this.addEventListener(Event.ENTER_FRAME,controllStagePlace);
		}
		
		/**Unload this item from web*/
		protected function unLoad(event:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			this.removeEventListener(Event.ENTER_FRAME,controllStagePlace);
			sw.stage = null ;
		}
		
		private function controllStagePlace(e:Event=null)
		{
			sw.viewPort = this.getBounds(stage);
		}
			
	}
}