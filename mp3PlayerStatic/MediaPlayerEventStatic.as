package mp3PlayerStatic
{
	import flash.events.Event;
	
	public class MediaPlayerEventStatic extends Event
	{
		public static const PLAY:String="PLAY";
		public static const PAUSE:String = "PAUSE";
		public static const STOP:String = "STOP";
		public static const VOLUME:String = "VOLUME";
		public static const CURRENT_PRECENT:String = "CURRENT_PRECENT";
		public static const SOUND_PRESENT:String = "SOUND_PRESENT";
		
			
		private var _volumeNumber:Number
		public function get volumeNumber():Number
		{
			return _volumeNumber
		}
		private var _currentPrecent:Number
		public function get currentPrecent():Number
		{
			return _currentPrecent
		}
		private var _soundPrecent:Number;
		public function get soundPrecent():Number
		{
			return _soundPrecent
		}
			
		
		public function MediaPlayerEventStatic(type:String,volumeNumber:Number=1,currentPrecent:Number=1,soundPrecent:Number=1, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_volumeNumber = volumeNumber
			_currentPrecent = currentPrecent
			_soundPrecent = soundPrecent	
		}
	}
}