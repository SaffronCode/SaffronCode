package restDoaService
{
	import flash.net.SharedObject;
	import flash.net.URLRequestHeader;


	public class RestDoaService
	{
		internal static const debug_show_results:Boolean = false ;
		
		
		public static var isOnline:Boolean = false ;
		
		
		/**This will take all errors on it*/
		public static var eventDispatcher:RestDoaEventDispatcher = new RestDoaEventDispatcher();
		
		/**located server domain*/
		internal static var serverDomain:String = null ;
		
		/**Default headers list*/
		internal static var headers:Vector.<URLRequestHeader> = new Vector.<URLRequestHeader>();
		
		
		private static var sharedObject:SharedObject;
		
		/**You can add your own error message stye here to this array. like "warning!", "caution", {"Message":null,"StackTrace":null}, ...*/
		public static var serverErrorModels:Array = ['{"Message":"An error has occurred."}'] ;
		
		private static function setUpStorage():void
		{
			if(sharedObject == null)
			{
				//trace("♠ Set up shared Object");
				sharedObject = SharedObject.getLocal('restMelkFullCash','/');
			}
		}
		
		private static function get(id:String):String
		{
			setUpStorage();
			var cash:String = sharedObject.data[id];
			//trace("♠ Load "+id+" from tht shared object");
			if(cash == null)
			{
				return '';
			}
			//trace("♠ Loaded id is : "+cash);
			return cash ;
		}
		
		private static function set(id:String,value:String):void
		{
			setUpStorage();
			//trace("♠ set the "+id+" to "+value);
			sharedObject.data[id] = value ;
			sharedObject.flush();
		}
		

		internal static function get domain():String
		{
			if(serverDomain==null)
			{
				throw "You Should setUp RestService first!\nUse RestService.setUp() function.";	
			}
			return serverDomain;
		}
		
		
		public static function setUp(ServerDomain:String):void
		{
			if(ServerDomain.charAt(ServerDomain.length-1)!='/')
			{
				ServerDomain+='/';
			}
			serverDomain = ServerDomain ;
			//UId;
			//UIdAuth;
			trace("Rest service is starts on : "+serverDomain);
		}
		
		
		
		/**Reset header list*/
		public static function resetHeaders():void
		{
			headers = new Vector.<URLRequestHeader>();
		}
		
		/**Add a static header to all services*/
		public static function addHeader(name:String, value:String):void
		{
			for(var i:int = 0 ; i<headers.length ; i++)
			{
				if((headers[i] as URLRequestHeader).name == name)
				{
					headers.removeAt(i);
					break;
				}
			}
			headers.push(new URLRequestHeader(name,value));
		}
	}
}