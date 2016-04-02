/***Version 2 : from now , this class will get original object and it will return original Object on load time*/

package webService2
{
	import contents.Contents;
	
	import dataManager.SavedDatas2;
	
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;

	public class WebServiceSaver2
	{
		private static var currentIndex1:String = "";
		private static var currentIndex2:String = "";
		
		public static function changeGlobalIndex1(newIndex:String='')
		{
			if(newIndex!='')
			{
				currentIndex1 = newIndex+"_" ;
			}
			else
			{
				currentIndex1 = '';
			}
		}
		
		public static function changeGlobalIndex2(newIndex:String='')
		{
			if(newIndex!='')
			{
				currentIndex2 = newIndex+"_" ;
			}
			else
			{
				currentIndex2 = '';
			}
		}
		
		/**version 2*/
		public static function load(ClassObject:Object,Parameters:Array,requiredDate:Date=null):Object
		{
			var valueName:String = currentIndex1+currentIndex2+generateID(ClassObject,Parameters) ;
			/*var loadedString:String = SavedDatas2.load(valueName) ;
			
			if(loadedString == null)
			{
				trace("no data is saved befor");
				return null;
			}*/
			
			var foundedObject:Object ;
			//trace("id is : "+valueName);
			
			var ba:ByteArray = SavedDatas2.loadIfNewer(valueName,requiredDate) ;
			//ba.writeUTF(loadedString);
			try
			{
				ba.position = 0 ;
				foundedObject = ba.readObject();
			}
			catch(e)
			{
				trace("un tracable object");
				return null;
			};
			
			return foundedObject ;
		}
		
		/*public static function load(ClassObject:Object,Parameters:Array):String
		{
		
		var valueName:String = currentIndex1+currentIndex2+generateID(ClassObject,Parameters) ;
		return SavedDatas2.load(valueName) ;
		}*/
		
		/**version 2*/
		public static function save(ClassObject:Object,Parameters:Array,object:Object):void
		{
			//Debug lines to controll performance
			//return ;
			
			
			var ba:ByteArray = new ByteArray();
			var tim:Number = getTimer();
			ba.writeObject(object);
			ba.position = 0 ;
			
			var valueName:String = currentIndex1+currentIndex2+generateID(ClassObject,Parameters);
			//trace("Save my datas : "+valueName);
			
			SavedDatas2.save(valueName,ba);
			
		}
		
		/*public static function save(ClassObject:Object,Parameters:Array,value:String):void
		{
			//Debug lines to controll performance
			//return ;
			
			
			var valueName:String = currentIndex1+currentIndex2+generateID(ClassObject,Parameters);
			SavedDatas2.save(valueName,value);
		}*/
		
		
		private static function generateID(ClassObject:Object,Parameters:Array):String
		{
			var className:String = getQualifiedClassName(ClassObject) ;
			className = className.substring(className.lastIndexOf('::')+2);
			var paramVaue:String = Parameters.join('*');
			
			return className+':'+paramVaue+':'+myWebService2.IP;
		}
	}
}