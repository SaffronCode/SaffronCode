package contents.displayPages
	//contents.displayPages.URLPage
{
	import contents.PageData;
	import contents.interFace.DisplayPageInterface;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class URLPage extends MovieClip implements DisplayPageInterface
	{
		private static var sw:StageWebView = new StageWebView();
		protected var myPage:PageData;
		
		
		private var openInWeb:MovieClip ;
		
		public function URLPage()
		{
			super();
			this.visible = false ;
			
			openInWeb = Obj.get("open_mc",this);
			if(openInWeb)
			{
				openInWeb.addEventListener(MouseEvent.CLICK,openInWebBrowser);
				this.visible = true;
			}
		}
		
		protected function openInWebBrowser(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			navigateToURL(new URLRequest(myPage.content));
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
			var rect:Rectangle = this.getBounds(stage);
			if(openInWeb)
			{
				var buttonRect:Rectangle = openInWeb.getBounds(stage);
				rect.bottom = buttonRect.top ;
			}
			sw.viewPort = rect;
		}
			
	}
}