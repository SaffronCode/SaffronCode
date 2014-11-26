package netManager.urlSaver
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class URLSaverEvent extends Event
	{
		public static const LOADING:String = "LOADING";
		
		public static const NO_INTERNET:String = "NO_INTERNET";
		
		public static const LOAD_COMPLETE:String = "LOAD_COMPLETE";
		
		public var precent:Number ; 
		public var loadedBytes:ByteArray;
		public var offlineTarget:String;
		
		public function URLSaverEvent(type:String,Precent:Number = 0 , LoadedBytes:ByteArray=null,OfflineTarget:String='')
		{
			precent = Precent ;
			loadedBytes = LoadedBytes ;
			offlineTarget = OfflineTarget ;
			super(type, false);
		}
	}
}