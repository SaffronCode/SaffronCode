package restService
{
	
	import com.mteamapp.JSONParser;
	
	import flash.display.MovieClip;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	

	/**All vectors, Arrays and Objects had to be initialized on the main class and all values had to be in public type.*/
	internal class RestFullJSONParser
	{
		
		/**This stringiy will make server standard date on json*/
		public static function stringify(object:Object):String
		{
			SaffronLogger.log("*** use the JSONParser instead of RestFullJSONParsers");
			return JSONParser.stringify(object);
		}
		
		public var error:Boolean = true  ;
		
		public var modelType:String = '';
		
		public var exceptionType:int ;
		
		public var msgs:Vector.<ClientMessageViewModel> = new Vector.<ClientMessageViewModel>();
		
		/**sample value
		public var numbers:Array = [];*/
		
		/**This is dynamic class*/
		public var model:* ;
		
		private var parsed:Object;
		
		
		/**Returns true if the json is paresd<br>
		 * serverData is unknown type , it can be json or byte array and its depend on fillThisObject type*/
		public function RestFullJSONParser(serverData:*/*,classType:Class*/,fillThisObject:Object)
		{
			if(fillThisObject is ByteArray)
			{
				SaffronLogger.log("Type is byte array : "+getQualifiedClassName(serverData));
				try
				{
					//(fillThisObject as ByteArray).endian = Endian.LITTLE_ENDIAN ;
					(fillThisObject as ByteArray).writeBytes(serverData);
					SaffronLogger.log("Byte length is : "+(fillThisObject as ByteArray).length);
					(fillThisObject as ByteArray).position = 0 ;
					error = false ;
				}
				catch(e)
				{
					SaffronLogger.log("Byte array parse error ");
					exceptionType = ErrorEnum.BinaryError ;
				}
				return ;
			}
			else if(fillThisObject is Vector.<*>)
			{
				//Clear vector if it is full
				//SaffronLogger.log("(model as Vector.<*>).length : "+(fillThisObject as Vector.<*>).length);
				while((fillThisObject as Vector.<*>).length)
				{
					(fillThisObject as Vector.<*>).pop();
				}

			}
			
			model = fillThisObject;

			try
			{
				JSONParser.parse(serverData,this);
				//parsed = JSONParser.parse(serverData,parsed);
			}
			catch(e)
			{
				SaffronLogger.log("JSON is not parsable");
				exceptionType = ErrorEnum.JsonParsProblem ;
			}
		}
		
		public static function parse(text:String,catcherObject:*):void
		{
			JSONParser.parse(text,catcherObject);
			//parsParams(JSON.parse(text,reviver),catcherObject);
		}
	}
}