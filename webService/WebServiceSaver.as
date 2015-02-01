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
		
		
		public static function save(ClassObject:Object,Parameters:Array,value:String):void
		{
			var valueName:String = generateID(ClassObject,Parameters);
			SavedDatas2.save(valueName,value);
		}
		
		
		private static function generateID(ClassObject:Object,Parameters:Array):String
		{
			var className:String = getQualifiedClassName(ClassObject) ;
			className = className.substring(className.lastIndexOf('::')+2);
			var paramVaue:String = Parameters.join('*');
			
			return className+':'+paramVaue;
		}
	}
}