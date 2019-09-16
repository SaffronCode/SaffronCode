package 
{
	import appManager.event.PageControllEvent;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	
	public class WebView extends MovieClip
	{
		public static const LOAD_URL:String = "LOAD_URL";
		public static const LOAD_STRING:String = "LOAD_STRING";
		public static const LOAD_BITMAP:String = "LOAD_BITMAP";
		private static var Me:WebView;
		public static var autoShowHide:Boolean=true;
		private var _stageWebView:StageWebView;
		private var _area:MovieClip;
		private var _url:String;
		private var _stage:Stage;
		private var _loadStatus:String;
		private var _bitmapData:BitmapData;
		private var _preventerDisplayObject:DisplayObject;
		public function WebView()
		{
			super();
		}
		public static function setup(area_p:MovieClip,url_p:String,stage_p:Stage,loadStatus_p:String=LOAD_URL,bitmapData_p:BitmapData=null,PreventerDisplayObject:DisplayObject=null):void
		{
			Me = new WebView();
			Me._area = area_p;	
			Me._url = url_p;
			Me._stage = stage_p;
			Me._loadStatus = loadStatus_p;
			Me._bitmapData = bitmapData_p;
			Me._preventerDisplayObject = PreventerDisplayObject;
			if(PreventerDisplayObject!=null)
			{
				PreventerDisplayObject.dispatchEvent(new PageControllEvent(PageControllEvent.PREVENT_PAGE_CHANGING,letPageChange,PreventerDisplayObject));
			}
			
			Me.load();	

		}
		protected static function letPageChange():void
		{
			if(isActive())
			{
				unload();
			}
			else
			{
				Me._preventerDisplayObject.dispatchEvent(new PageControllEvent(PageControllEvent.LET_PAGE_CHANGE));	
			}
			
			
		}
		private function chekArea(event:Event):void
		{
			// TODO Auto-generated method stub
			_stageWebView.viewPort = getArea();
			if(!Obj.isAccesibleByMouse(_area))
			{
				_hide();
			}
			else
			{
				_show();
			}
		}
		private  function load():void
		{
			_stageWebView = new StageWebView(true);
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
			Me.addEventListener(Event.ENTER_FRAME,chekArea)
		}
		public static function reLoad(url_p:String):void
		{
			Me._url = url_p;
			Me.reLoad();
		}
		private function reLoad():void
		{
			if(_loadStatus==LOAD_URL)
			{
				_stageWebView.loadURL(_url);
			}
			else
			{
				_stageWebView.loadString(_url);
			}
		}
		public static function unload():void
		{
			if(Me!=null)Me.remove();
		}
		private function remove():void
		{

			if(isActive())
			{
				Me.removeEventListener(Event.ENTER_FRAME,chekArea)
				_stageWebView.stage = null;
				_stageWebView.dispose();
				_stageWebView = null

			}
		}
		private function getArea():Rectangle
		{
			return _area.getBounds(_stage)
		}
		public static function hide():void
		{
			if(Me!=null)Me._hide();
		}
		public static function show():void
		{
			if(Me!=null)Me._show();
		}
		private function _hide():void
		{
			if(isActive() && autoShowHide)_stageWebView.stage = null;
		}
		private function _show():void
		{
			if(isActive()&& autoShowHide)_stageWebView.stage = _stage;
		}
		public static function isActive():Boolean
		{
			return Me._stageWebView!=null
		}
	}
}