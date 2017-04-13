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
		
		public var 	totalBytes:Number,
					loadedBytesLenght:Number ;
		
		public function URLSaverEvent(type:String,Precent:Number = 0 , LoadedBytes:ByteArray=null,OfflineTarget:String='',TotalBytes:Number=0,LoadedBytesL:Number=0)
		{
			precent = Precent ;
			loadedBytesLenght = LoadedBytesL ;
			offlineTarget = OfflineTarget ;
			totalBytes = TotalBytes ;
			loadedBytes = LoadedBytes ;
			super(type, false);
		}
	}
}