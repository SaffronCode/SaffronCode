package darkBox
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	internal class WebOpener extends DefaultImage
	{
		private var myStageWeb:StageWebView ;

		private var pdftarget:File;
		
		private var stageVewIsOpened:Boolean = false ;
		
		
		public function WebOpener()
		{
			myStageWeb = new StageWebView();
			super();
		}
		
		override public function hide():void
		{
			super.hide();
			if(stageVewIsOpened)
			{
				myStageWeb.dispose();
			}
			try
			{
				myStageWeb.stage = null ;
			}catch(e){};
			stageVewIsOpened = false ;
			this.visible = false ;
			this.addEventListener(MouseEvent.CLICK,openPDF);
			this.addEventListener(Event.ENTER_FRAME,controllStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}
		
		private function unLoad(e:Event):void
		{
			this.removeEventListener(MouseEvent.CLICK,openPDF);
			this.removeEventListener(Event.ENTER_FRAME,controllStage);
		}
		
		private function controllStage(e:Event):void
		{
			if(stageVewIsOpened)
			{
				if(Obj.isAccesibleByMouse(this))
				{
					myStageWeb.stage = stage ;
				}
				else
				{
					myStageWeb.stage = null ;
				}
			}
		}
		
		/**Open the pdf for Android*/
		private function openPDF(e:MouseEvent=null):void
		{
			if(pdftarget)
			{
				trace("PDF target is : "+pdftarget.url);
				navigateToURL(new URLRequest(pdftarget.url));
			}
		}
		
		override public function setUp(newSize:Rectangle):void
		{
			super.setUp(newSize);
			this.graphics.clear();
			this.graphics.beginFill(0xffffff,1);
			this.graphics.drawRect(0,0,newSize.width,newSize.height);
			
			
			controllStageRect();
		}
		
		private function controllStageRect(e:Event=null):void
		{
			if(this.stage)
			{
				myStageWeb.viewPort = this.getBounds(stage);
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE,controllStageRect);
			}
		}
		
		override public function show(target:String=''):void
		{
			this.visible = true ;
			this.mouseEnabled = this.mouseChildren = true ;
			pdftarget = new File(target);
			if(DevicePrefrence.isAndroid())
			{
				openPDF();
			}
			else
			{
				stageVewIsOpened = true ;
				myStageWeb.stage = stage ;
				trace("PDF path : "+pdftarget.nativePath);
				myStageWeb.loadURL(pdftarget.url);
			}
		}
	}
}
