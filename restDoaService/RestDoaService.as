package restDoaService
{
	import flash.net.SharedObject;


	public class RestDoaService
	{
		internal static const debug_show_results:Boolean = false ;
		
		
		/**This will take all errors on it*/
		public static var eventDispatcher:RestDoaEventDispatcher = new RestDoaEventDispatcher();
		
		/**located server domain*/
		internal static var serverDomain:String = null ;
		
		//private static var 	id_UId:String = "UId",
						//	id_UIdAuth:String = "UIdAuth";
		
		//private static var _UId:String = '';//"226e4187-4135-4733-bfe2-8fc526d6971c";
		
		//private static var _UIdAuth:String = '';//"29d46f85-1fb5-4ff2-8c36-6d70744eaf45" ;
		
		private static var sharedObject:SharedObject;
		
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
		
		
		/*internal static function get UIdAuth():String
		{
			if(_UIdAuth=='')
			{
				_UIdAuth = get(id_UIdAuth);
			}
			return _UIdAuth;
		}*/
		
		/*internal static function get UId():String
		{
			if(_UId=='')
			{
				_UId = get(id_UId);
			}
			//trace("♠ Get _UId : "+_UId);
			return _UId;
		}*/
		
		

		/*private static function setUIdAuth(value:String):void
		{
			//trace("♠ set id_UIdAuth from "+_UIdAuth+" To "+value);
			if(_UIdAuth!=value)
			{
				set(id_UIdAuth,value);
				_UIdAuth = value;
				//trace("♠ done");
			}
		}*/

		/*private static function setUId(value:String):void
		{
			//trace("♠ set _UId from "+_UId+" To "+value);
			if(_UId!=value)
			{
				set(id_UId,value);
				_UId = value;
				//trace("♠ done");
			}
		}*/

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
		
		/**Feal these values from signInViewModel to make user knownAsLoged in
		public static function setUid(uId:String,uIdAuth:String):void
		{
			setUId(uId) ;
			setUIdAuth(uIdAuth) ;
			trace("User is logged in");
		}*/
		
		/*public static function logOut():void
		{
			setUId('');
			setUIdAuth('');
			trace("User is logged out");
		}*/
		
		/**Returns true if user is logged in.
		public static function get isLogedIn():Boolean
		{
			if(UId=='' || UIdAuth=='')
			{
				return false ;
			}
			else
			{
				return true ;
			}
		}*/
	}
}