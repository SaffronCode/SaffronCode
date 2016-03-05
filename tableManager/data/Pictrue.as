package tableManager.data
{
	import database.RunRestServic;
	
	import eventMovie.ThumbnailEvent;
	
	import flash.display.*;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import restService.webCallers.FilesBinaryData;
	
	import tableManager.TableEvents;
	import tableManager.graphic.Cell;
	import tableManager.graphic.Location;

	public class Pictrue extends MovieClip
	{
		[Event(name="PICTRUE_TALBE",type="tableManager.TableEvents")]
		private var _url:String
		public function get url():String
		{
			return _url
		}
		public function set url(value:String):void
		{
			_url = value
		}
		private var _byteArray:ByteArray;
		public function get byteArray():ByteArray
		{
			return _byteArray
		}
		public function set byteArray(value:ByteArray):void
		{
			_byteArray = byteArray
		}
		
		private var _binaryDataUId:String
		public function get binaryDataUId():String
		{
			return _binaryDataUId
		}
		private var _Id:int;
		public function get Id():int
		{
			return _Id
		}
		private var _bitmap:Bitmap;
		public function get bitmap():Bitmap
		{
			return _bitmap
		}
		
		private var _type:String = "Pictrue"
		public function type():String
		{
			return _type
		}
		private var _locationCell:Location;
		public function locationCell():Location
		{
			return _locationCell
		}
		
		private var _clumSpan:Boolean
		
		private var _rowSpan:Boolean
		
		private var _Fix:Boolean
		
		private var _privateCellLocatoin:Location
		
		private var _loaderPage:Loader;		
		private var loaderContext:LoaderContext;
		private var UrlRequest:URLRequest;

		
		private var conterId:Cell = new Cell()
			
		private var runServic:RunRestServic;
		private var bytesArrayServic:FilesBinaryData;
		public function Pictrue(Url_p:String="",BinaryDataUId_p:String=null)
		{
			_url = Url_p
			_binaryDataUId = BinaryDataUId_p
		}
		public function load(locationCell_p:Location,PrivateCellLocatoin_p:Location,ClumSpan_p:Boolean,RowSpan_p:Boolean,Fix_p:Boolean,Id_p:int)
		{
			_Id = Id_p
			_locationCell = locationCell_p
			_clumSpan = ClumSpan_p	
			_rowSpan = 	RowSpan_p
			_Fix = Fix_p
			_privateCellLocatoin = PrivateCellLocatoin_p

			
			try
			{
			//	unLoad();
			}
			catch (error:Error)
			{
				trace("loader hasn't loaded yet");
			}
			
				
			
		//	UrlRequest = new URLRequest(_url);
		
			if(_binaryDataUId!=null && _binaryDataUId!="")
			{
				runServic = new RunRestServic()
				runServic.addEventListener(ThumbnailEvent.THUMB_CLICKED,LOAD_BYTESARRAY_fun)
				runServic.filesBinaryDataSetUp(_binaryDataUId)
			}
			else if(_url!="")
			{
				loadUrl_fun()
			}	
				
								

		}
		
		protected function LOAD_BYTESARRAY_fun(event:ThumbnailEvent):void
		{
			// TODO Auto-generated method stub
			bytesArrayServic = event.url
			_byteArray = bytesArrayServic.data
			loadBytes_fun()
		}		
		
		private function loadBytes_fun():void
		{
			_loaderPage = new Loader()
			loaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);	

			_loaderPage.loadBytes(_byteArray,loaderContext);
			_loaderPage.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplete_fun);
		}
		private function loadUrl_fun():void
		{
			_loaderPage = new Loader()
			loaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);	

			UrlRequest = new URLRequest(_url+'?'+getTimer());
			_loaderPage.load(UrlRequest,loaderContext);
			_loaderPage.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplete_fun);
		}
		
		
		private function loadComplete_fun(evt_p:Event):void
		{
			
			_bitmap = Bitmap(_loaderPage.content)
				
				if(_Fix)
				{
					_bitmap.width = sizePic().width	
				}
				
				if(_Fix)
				{
					_bitmap.height = sizePic().height
				}

			var pictrueLoader:Pictrue = this	
			this.dispatchEvent(new TableEvents(TableEvents.PICTRUE_TALBE,null,this))
			//trace( "nameeee =",getQualifiedClassName( evt_p.target.content) );
		}
		
		private function sizePic():Rectangle
		{
			var width:Number = _locationCell.rectangle.width
			var height:Number =  _locationCell.rectangle.height
			if(_privateCellLocatoin!=null)
			{
				if(!isNaN(_privateCellLocatoin.rectangle.width))
				{
					width = _privateCellLocatoin.rectangle.width
				}
				if(!isNaN(_privateCellLocatoin.rectangle.height))
				{
					height = _privateCellLocatoin.rectangle.height
				}
			}
			return new Rectangle(0,0,width,height)
		}
		public function unLoad()
		{
			trace("***ouLoad****");
			_loaderPage.unloadAndStop();
			_loaderPage.unload()				
		}

	}
}