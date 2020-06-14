package restService
{
	import com.adobe.crypto.MD5Stream;
	
	import dataManager.SavedDatas2;
	
	import flash.utils.getQualifiedClassName;

	internal class RestServiceSaver
	{
		public static function load(id:String,jsonParam:String):*
		{
			var valueName:String = generateID(id,jsonParam) ;
			var cash:* = SavedDatas2.load(valueName) ;
			//SaffronLogger.log("Load > "+valueName+' ○ '+cash+' ○');
			return cash;
		}
		
		/**Returns true if cashed data is older than acceptable date or it is not exists.*/
		public static function isExpired(id:String,jsonParam:String,lastAcceptableDate:Date):Boolean
		{
			var valueName:String = generateID(id,jsonParam) ;
			var cash:String = SavedDatas2.loadIfNewer(valueName,lastAcceptableDate);
			if(cash!=null)
			{
				return false ;
			}
			else
			{
				return true ;
			}
		}

		
		
		public static function save(id:String,jsonParam:String,value:*):void
		{
			//SaffronLogger.log("**Values saved");
			var valueName:String = generateID(id,jsonParam);
			SaffronLogger.log("○ jsonParam is  :  "+jsonParam);
		//	SaffronLogger.log("Save > "+valueName+" ○ "+value+' ○');
			SavedDatas2.save(valueName,value);
		}
		
		
		private static function generateID(Classid:String,Parameters:String):String
		{
			if(Parameters == null)
			{
				Parameters = '';
			}
			
			Parameters = Parameters.split('"').join('').split("{").join('').split("}").join('').split("[").join('').split("]").join('');
			//SaffronLogger.log("Storage id is :    "+Parameters+':'+Classid)
			return Classid+':'+Parameters+':'+RestService.UId+RestService.serverDomain;
		}
	}
}