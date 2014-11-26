package contents
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class ImageData
	{
		public var 	targURL:String ;
		
		public var width:Number = 0 ;
		
		public var height:Number = 0 ;
		
		public var x:Number=0;
		
		public var y:Number = 0 ;
		
		public var text:String = '';
		
		/**this function will load the swf in this object*/
		private var swfContainer:MovieClip;
		
		private var loader:Loader;
		
		/*<img text="" targ="" width="" height="" x="" y=""/>*/
		public function ImageData(imageXML:XML)
		{
			text = imageXML.@text ;
			targURL = imageXML.@targ ;
			
			width = Number(imageXML.@width);
			height = Number(imageXML.@height);
			x = Number(imageXML.@x);
			y = Number(imageXML.@y);
			
			swfContainer = new MovieClip();
		}
		
		public function export():XML
		{
			var xml:XML = XML('<img/>');
			xml.@text = text;
			xml.@targ = targURL;
			
			xml.@width = width;
			xml.@height = height;
			xml.@x = x;
			xml.@y = y;
			
			return xml;
		}
		
		
		/**this function will returns a MovieClip Object that will be fill with laoded content*/
		public function loadTarget():MovieClip
		{
			swfContainer.removeChildren();
			
			loader = new Loader();
			var loaderContex:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
			loaderContex.allowCodeImport = true ;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loadFaild);
			loader.load(new URLRequest(targURL),loaderContex);
			
			
			return swfContainer ;
		}
		
		
		
		/**tells load is faild*/
		private function loadFaild(e:IOErrorEvent)
		{
			trace(new Error('target '+targURL+' not found'));
		}

		/**load is complete*/
		private function loadComplete(e:Event)
		{
			swfContainer.addChild(loader.content);
			try
			{
				(loader.content as Bitmap).smoothing = true ;
			}
			catch(e){};
		}
	}
}