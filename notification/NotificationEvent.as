package notification
{
	import flash.events.Event;
	
	public class NotificationEvent extends Event
	{
		public static const TOKEN_REGISTER_COMPELETED="TOKEN_REGISTER_COMPELETED"
		public static const TOKEN_REGISTER_START = "TOKEN_REGISTER_START"
		
		public static const NOTIFICATION:String = "NOTIFICATION";
		public static const FOREGROUND_NOTIFICATION:String = "FOREGROUND_NOTIFICATION";	

		private var _tokenRegistered:Boolean

		private  var _notificatoin:PNEventManager;
		
		public var notifData:Object ;
		
		public  function get notificatoin():PNEventManager
		{
			return _notificatoin
		}
		public function NotificationEvent(type:String,notificatoin:PNEventManager=null, bubbles:Boolean=false, cancelable:Boolean=false,notifDataInStringForman:Object=null)
		{
			super(type, bubbles, cancelable);	
			_notificatoin = notificatoin	;
			notifData = notifDataInStringForman ;
		}
	}
}