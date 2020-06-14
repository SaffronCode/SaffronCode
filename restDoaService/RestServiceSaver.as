package restDoaService
{
	import com.adobe.crypto.MD5;
	
	import dataManager.SavedDatas2;
	
	import flash.net.URLRequestHeader;
	

	internal class RestServiceSaver
	{
		public static var lastLoadedData:String ;
		
		public static var lastCashDate:Number ;
		
		public static function load(id:String,jsonParam:String,headerArray:Array=null):*
		{
			var valueName:String = generateID(id,jsonParam,headerArray) ;
			var cash:* = SavedDatas2.load(valueName) ;

			lastCashDate = SavedDatas2.savedDate ;
			SaffronLogger.log("Load > "+valueName+' ○ '+cash+' ○');
			return cash;
		}
		
		/**Returns true if cashed data is older than acceptable date or it is not exists.*/
		public static function isExpired(id:String,jsonParam:String,lastAcceptableDate:Date):Boolean
		{
			var valueName:String = generateID(id,jsonParam) ;
			lastLoadedData = SavedDatas2.loadIfNewer(valueName,lastAcceptableDate);
			if(lastLoadedData!=null)
			{
				return false ;
			}
			else
			{
				return true ;
			}
		}

		
		
		public static function save(id:String,jsonParam:String,value:*,headerArray:Array=null):void
		{
			//SaffronLogger.log("**Values saved");
			var valueName:String = generateID(id,jsonParam,headerArray);
			SaffronLogger.log("○ jsonParam is  :  "+jsonParam);
			SaffronLogger.log("Save > "+valueName+" ○ "+value+' ○');
			SavedDatas2.save(valueName,value);
		}
		
		
		private static function generateID(Classid:String,Parameters:String,headerArray:Array=null):String
		{
			if(Parameters == null)
			{
				Parameters = '';
			}
			
			var headerString:String = "";
			for(var i:int = 0 ; i<RestDoaService.headers.length ; i++)
			{
				headerString += MD5.hash(RestDoaService.headers[i].name+RestDoaService.headers[i].value) ;
			}
			for(i = 0 ; i<headerArray.length ; i++)
			{
				var currentHeader:URLRequestHeader = headerArray[i] as URLRequestHeader ;
				if(currentHeader.name!="Accept")
				{
					headerString += MD5.hash(currentHeader.name+currentHeader.value) ;
				}
			}
			
			var ParametersArray:Array = Parameters.split('"').join('').split("{").join('').split("}").join('').split("[").join('').split("]").join('').split(',');
			ParametersArray.sort();
			Parameters = ParametersArray.join(',');
			//SaffronLogger.log("Storage id is :    "+Parameters+':'+Classid)
			return Classid+':'+Parameters+':'+RestDoaService.serverDomain+headerString;
		}
	}
}