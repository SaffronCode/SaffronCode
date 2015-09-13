package dataManager
{
	import com.mteamapp.JSONParser;
	
	import flash.net.SharedObject;

	public class GlobalStorage
	{
		private static var storage:SharedObject ; 
		
		private static function setUp():void
		{
			if(storage==null)
			{
				storage = SharedObject.getLocal("MyGlobalStorage",'/');
			}
		}
		
		/**Boolean, Number, String supported*/
		public static function load(id:String):*
		{
			setUp();
			if(storage.data[id] == undefined)
			{
				return null ;
			}
			else
			{
				return storage.data[id] ;
			}
		}
		
		/**Boolean, Number, Stirng is supported*/
		public static function save(id:String,value:*,flush:Boolean=true):void
		{
			storage.data[id] = value ;
			if(flush)
			{
				storage.flush();
			}
		}
		
		
		public static function loadObject(id:String,catcherObject:*):*
		{
			var jsonObject:String = load(id);
			if(jsonObject==null)
			{
				return null ;
			}
			trace("jsonObject : "+jsonObject);
			return JSONParser.parse(jsonObject,catcherObject);
		}
		
		public static function saveObject(id:String,saverObject:*,flush:Boolean=true):void
		{
			var jsonString:String = JSONParser.stringify(saverObject);
			save(id,jsonString,flush);
		}
	}
}