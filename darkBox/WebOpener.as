﻿package darkBox
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.setTimeout;
	
	import nativeClasses.pdfReader.DistriqtPDFReader;
	
	internal class WebOpener extends DefaultImage
	{
		private var myStageWeb:StageWebView ;

		private var pdftarget:File;
		
		private var stageVewIsOpened:Boolean = false ;
		private var distriqtPDF:DistriqtPDFReader;
		
		
		public function WebOpener()
		{
			myStageWeb = new StageWebView();
			super();
		}
		
		override public function hide():void
		{
			super.hide();
			
			if(distriqtPDF)
				distriqtPDF.dispose();
			
			if(stageVewIsOpened && this.stage!=null)
			{
				myStageWeb.dispose();
				myStageWeb = new StageWebView();
				myStageWeb.viewPort = this.getBounds(stage);
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
			
			
			setTimeout(controllStageRect,0);
		}
		
		private function controllStageRect(e:Event=null):void
		{
			if(this.stage)
			{
				try
				{
					myStageWeb.viewPort = this.getBounds(stage);
				}
				catch(e:Error)
				{
					trace(e.message);
				}
				if(DistriqtPDFReader.isSupport && distriqtPDF==null)
				{
					distriqtPDF = new DistriqtPDFReader(this.width,this.height);
					this.addChild(distriqtPDF);
				}
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE,controllStageRect);
			}
		}
		
		override public function show(target:String=''):void
		{
			this.visible = true ;
			var onlineShow:Boolean = target.indexOf('http')!=-1;
			this.mouseEnabled = this.mouseChildren = !onlineShow ;
			if(!onlineShow)
			{
				pdftarget = new File(target);
			}
			if(DistriqtPDFReader.isSupport)
			{
				distriqtPDF.openPDF(onlineShow?target:pdftarget.nativePath);
			}
			else if(!onlineShow && DevicePrefrence.isAndroid())
			{
				if(NativePDF.isSupports())
				{
					trace("******* Open pdf with native");
					NativePDF.openPDFReader(pdftarget);
				}
				else
				{
					trace("******* Navigate to open pdf");
					openPDF();
					//On android, the pdf reader can share,save and do any thing that user need to do. so close the DarkBox
				}
				DarkBox.hide();
			}
			else
			{
				stageVewIsOpened = true ;
				myStageWeb.stage = stage ;
				//trace("PDF path : "+pdftarget.nativePath);
				myStageWeb.loadURL(onlineShow?target:pdftarget.url);
			}
		}
	}
}
