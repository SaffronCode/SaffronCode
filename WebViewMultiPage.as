package
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;

	public class WebViewMultiPage extends MovieClip
	{
		public static const LOAD_URL:String = "LOAD_URL";
		public static const LOAD_STRING:String = "LOAD_STRING";
		public static const LOAD_BITMAP:String = "LOAD_BITMAP";
		public  var autoShowHide:Boolean=true;
		private var _stageWebView:StageWebView;
		private var _area:MovieClip;
		private var _url:String;
		private var _stage:Stage;
		private var _loadStatus:String;
		private var _bitmapData:BitmapData;
		public function WebViewMultiPage()
		{
			super();
		}
		public  function setup(area_p:MovieClip,url_p:String,stage_p:Stage,loadStatus_p:String=LOAD_URL,bitmapData_p:BitmapData=null):void
		{
			_area = area_p;	
			_url = url_p;
			_stage = stage_p;
			_loadStatus = loadStatus_p;
			_bitmapData = bitmapData_p;
			load();		
		}
		private function chekArea(event:Event):void
		{
			// TODO Auto-generated method stub
			_stageWebView.viewPort = getArea();
			if(!Obj.isAccesibleByMouse(_area))
			{
				hide();
			}
			else
			{
				show();
			}
		}
		private  function load():void
		{
			_stageWebView = new StageWebView();
			_stageWebView.stage = _stage;
			_stageWebView.viewPort = getArea();
			if(_loadStatus==LOAD_URL)
			{
				_stageWebView.loadURL(_url);
			}
			else if(_loadStatus==LOAD_STRING)
			{
				_stageWebView.loadString(_url);
			}
			else if(_loadStatus == LOAD_BITMAP)
			{
				_stageWebView.drawViewPortToBitmapData(_bitmapData);
			}
			this.addEventListener(Event.ENTER_FRAME,chekArea)
		}
		public function reLoad(url_p:String):void
		{
			_url = url_p;
			if(_loadStatus==LOAD_URL)
			{
				_stageWebView.loadURL(_url);
			}
			else
			{
				_stageWebView.loadString(_url);
			}
		}

		public function unload():void
		{
			if(isActive())
			{
				this.removeEventListener(Event.ENTER_FRAME,chekArea)
				_stageWebView.stage = null;
				_stageWebView.dispose();
				_stageWebView = null;
			}
		}
		private function getArea():Rectangle
		{
			return _area.getBounds(_stage)
		}

		public function hide():void
		{
			if(isActive() && autoShowHide)_stageWebView.stage = null;
		}
		public function show():void
		{
			if(isActive()&& autoShowHide)_stageWebView.stage = _stage;
		}
		public function isActive():Boolean
		{
			return _stageWebView!=null
		}
	}
}