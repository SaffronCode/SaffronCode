package restDoaService
{
	import dataManager.SavedDatas2;
	

	internal class RestServiceSaver
	{
		public static var lastLoadedData:String ;
		
		public static var lastCashDate:Number ;
		
		public static function load(id:String,jsonParam:String):*
		{
			var valueName:String = generateID(id,jsonParam) ;
			var cash:* = SavedDatas2.load(valueName) ;

			lastCashDate = SavedDatas2.savedDate ;
			trace("Load > "+valueName+' ○ '+cash+' ○');
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

		
		
		public static function save(id:String,jsonParam:String,value:*):void
		{
			//trace("**Values saved");
			var valueName:String = generateID(id,jsonParam);
			trace("○ jsonParam is  :  "+jsonParam);
			trace("Save > "+valueName+" ○ "+value+' ○');
			SavedDatas2.save(valueName,value);
		}
		
		
		private static function generateID(Classid:String,Parameters:String):String
		{
			if(Parameters == null)
			{
				Parameters = '';
			}
			
			var headerString:String = "";
			for(var i:int = 0 ; i<RestDoaService.headers.length ; i++)
			{
				headerString += RestDoaService.headers[i].value ;
			}
			
			var ParametersArray:Array = Parameters.split('"').join('').split("{").join('').split("}").join('').split("[").join('').split("]").join('').split(',');
			ParametersArray.sort();
			Parameters = ParametersArray.join(',');
			//trace("Storage id is :    "+Parameters+':'+Classid)
			return Classid+':'+Parameters+':'+RestDoaService.serverDomain+headerString;
		}
	}
}