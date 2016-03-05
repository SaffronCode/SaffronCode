package file
{
	import flash.events.Event;

	public class SwitchUrlEvent extends Event
	{
		public static const SWITCH_URL:String="SWITCH_URL"
		
		public static const SWITCH_ERROR_WRITE="SWITCH_ERROR_WRITE"
		
		public static const SWITCH_ERROR_DOWNLOAD="SWITCH_ERROR_DOWNLOAD"	
		
		public static const SWITCH_DOWNLOAD_PRECENT="SWITCH_DOWNLOAD_PRECENT"	
			
		private var _switchUrl:SwitchUrl;
		public function get switchUrl():SwitchUrl
		{
			return _switchUrl
		}
		
		private var _error:String;
		public function get error():String
		{
			return _error
		}
		private var _downLoadPrecent:int;
		public function get downLoadPrecent():int
		{
			return _downLoadPrecent	
		}
		public function SwitchUrlEvent(type:String,switchUrl:SwitchUrl=null,error:String='',downLoadPrecent:int=0,bbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type,bbles,cancelable);
			_switchUrl = switchUrl
			_error = error
			_downLoadPrecent = downLoadPrecent	
		}
		override public function clone():Event
		{
			return new SwitchUrlEvent(type,switchUrl,error,downLoadPrecent,bubbles,cancelable)
		}
	}
}