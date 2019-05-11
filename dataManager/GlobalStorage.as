package dataManager
{
	import com.mteamapp.Encrypt;
	import com.mteamapp.JSONParser;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	public class GlobalStorage
	{
		private static var storage:SharedObject ; 
		private static var bigDataStorage:SharedObject ;


		private static var cash:Object = {} ;
		
		/**Do not encrypt strings with length of more than this*/
		private static const maxLengthForEncryptableStrings:uint = 200 ;
		
		private static var myId:String ;
		
		private static var flushNeeded:Boolean = false ;
		
		private static function setUp():void
		{
			if(storage==null)
			{
				storage = SharedObject.getLocal("MyGlobalStorage2",'/');
				bigDataStorage = SharedObject.getLocal("MyGlobalStoragebigData",'/');
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE,flushAllIfNeeded);
			}
		}
		
		protected static function flushAllIfNeeded(event:Event):void
		{
			if(flushNeeded)
			{
				storage.flush();
				bigDataStorage.flush();
			}
		}
		
		private static function getId():String
		{
			if(myId==null)
			{
				myId = DevicePrefrence.DeviceUniqueId() ;
			}
			return myId ;
		}
		
		/**Boolean, Number, String supported*/
		public static function load(id:String):*
		{
			if(cash[id]!=undefined)
			{
				return cash[id];
			}
			setUp();
			id = Encrypt.encrypt(id,getId()) ;
			var loadedString:* = storage.data[id] ; 
			if( loadedString == undefined)
			{
				loadedString = bigDataStorage.data[id] ;
				if(loadedString == undefined)
				{
					return null ;
				}
				return loadedString ;
			}
			else
			{
				if(loadedString is String)
					return Encrypt.decrypt(loadedString,getId()) ;
				else
					return loadedString ;
			}
		}
		
		/**Boolean, Number, Stirng is supported*/
		public static function save(id:String,value:*,flush:Boolean=true):void
		{
			setUp();
			cash[id] = value ;
			id = Encrypt.encrypt(id,getId());
			if(value is String && value.length>maxLengthForEncryptableStrings)
			{
				bigDataStorage.data[id] = value ;
				if(storage.data[id]!=undefined)
				{
					storage.data[id] = undefined ;
					flushNeeded = true ;
				}
				if(flush)
				{
					flushNeeded = true ;
				}
			}
			else
			{
				if(value is String)
					storage.data[id] = Encrypt.encrypt(value,getId()) ;
				else
					storage.data[id] = value ;
					
				if(flush)
				{
					flushNeeded = true ;
				}
			}
		}
		
		
		public static function loadObject(id:String,catcherObject:*):*
		{
			var jsonObject:* = load(id);
			trace("object type is : "+getQualifiedClassName(jsonObject));
			if(jsonObject==null)
			{
				return null ;
			}
			//trace("jsonObject : "+jsonObject);
			if(jsonObject is String)
				return JSONParser.parse(jsonObject,catcherObject);
			else if(jsonObject is Obj.getObjectClass(catcherObject))
				return JSONParser.parse(JSON.stringify(jsonObject),catcherObject);
			else
			{
				JSONParser.parsParams({data:jsonObject},{data:catcherObject});
				return catcherObject ;
			}
		}
		public static function loadObject2(id:String):Vector.<uint>
		{
			var jsonObject:String = load(id);
			if(jsonObject==null || jsonObject=='')
			{
				return null ;
			}
			//trace('jsonObject :',jsonObject)
			var obj:Object = JSON.parse(jsonObject);
			var _list:Vector.<uint> = new Vector.<uint>
			for each(var value:uint in obj)
			{
				_list.push(value)
			}
			return _list
		}

		public static function saveObject(id:String,saverObject:*,flush:Boolean=true):void
		{
			save(id,saverObject,flush);
		}
		public static function Delete(id:String):void
		{
			setUp();
			delete storage.data[id];
		}
		
		public function Clear(id:String):void
		{
			setUp();
			storage.data[id] = null ;
			flushNeeded = true ;
		}
	}
}