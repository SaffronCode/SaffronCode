package webService
{
	import dataManager.SavedDatas2;
	
	import flash.utils.getQualifiedClassName;

	public class WebServiceSaver
	{
		public static function load(ClassObject:Object,Parameters:Array):String
		{
			var valueName:String = generateID(ClassObject,Parameters) ;
			return SavedDatas2.load(valueName) ;
		}
		
		/**Returns true if cashed data is older than acceptable date or it is not exists.*/
		public static function isExpired(ClassObject:Object,Parameters:Array,lastAcceptableDate:Date):Boolean
		{
			var valueName:String = generateID(ClassObject,Parameters) ;
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
		
		
		public static function save(ClassObject:Object,Parameters:Array,value:String):void
		{
			Constants.count(7.031);
			var valueName:String = generateID(ClassObject,Parameters);
			Constants.count(7.032);
			SavedDatas2.save(valueName,value);
			Constants.count(7.033);
		}
		
		
		private static function generateID(ClassObject:Object,Parameters:Array):String
		{
			var className:String = getQualifiedClassName(ClassObject) ;
			className = className.substring(className.lastIndexOf('::')+2);
			var paramVaue:String = Parameters.join('*');
			
			return paramVaue+':'+className;
		}
	}
}