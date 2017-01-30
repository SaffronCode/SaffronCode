package 
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	
	public class WebView extends MovieClip
	{
		public static const LOAD_URL:String = "LOAD_URL";
		public static const LOAD_STRING:String = "LOAD_STRING";
		private static var Me:WebView;
		private var _stageWebView:StageWebView;
		private var _area:MovieClip;
		private var _url:String;
		private var _stage:Stage;
		private var _loadStatus:String;
		public function WebView()
		{
			super();
		}
		public static function setup(area_p:MovieClip,url_p:String,stage_p:Stage,loadStatus_p:String=LOAD_URL):void
		{
			Me = new WebView();
			Me._area = area_p;	
			Me._url = url_p;
			Me._stage = stage_p;
			Me._loadStatus = loadStatus_p;
			Me.load();		
		}
		
		private function chekArea(event:Event):void
		{
			// TODO Auto-generated method stub
			_stageWebView.viewPort = getArea();
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
			else
			{
				_stageWebView.loadString(_url);
			}
			Me.addEventListener(Event.ENTER_FRAME,chekArea)
		}
		public static function unload():void
		{
			if(Me!=null)Me.remove();
		}
		private function remove():void
		{
			if(isActive())
			{
				_stageWebView.stage = null;
				_stageWebView.dispose();
				_stageWebView = null
				Me.removeEventListener(Event.ENTER_FRAME,chekArea)
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
			if(isActive())_stageWebView.stage = null;
		}
		private function _show():void
		{
			if(isActive())_stageWebView.stage = _stage;
		}
		public static function isActive():Boolean
		{
			return Me._stageWebView!=null
		}
	}
}