package notification
{
	import com.milkmangames.nativeextensions.events.PNEvent;
	import com.milkmangames.nativeextensions.events.PNOSEvent;
	
	import flash.events.Event;
	
	public class NotificationEvent extends Event
	{
		public static const TOKEN_REGISTER_COMPELETED="TOKEN_REGISTER_COMPELETED"
		public static const TOKEN_REGISTER_START = "TOKEN_REGISTER_START"

		public static const NOTIFICATION:String = "NOTIFICATION"	

		private var _tokenRegistered:Boolean

		private  var _notificatoin:PNEventManager
		public  function get notificatoin():PNEventManager
		{
			return _notificatoin
		}
		public function NotificationEvent(type:String,notificatoin:PNEventManager=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);	
			_notificatoin = notificatoin	
		}
	}
}