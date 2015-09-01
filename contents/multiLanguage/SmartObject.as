package contents.multiLanguage
{
	import contents.TextFile;
	
	import flash.filesystem.File;

	dynamic public class SmartObject extends Object
	{
		include "compilerValues.as"
		
		private var _____compilerValuesLocation:String ;
		private var _____compilerValsAre:String;
		
		public function SmartObject()
		{
			super();
			include "compilerValuesLocation.as"
			_____compilerValsAre = '' ;
		}
		
		/**This function will helps to save the values for compiler in the next run*/
		public function saveValue(valueName:String,value:String):void
		{
			_____compilerValsAre+='public var '+valueName+':String ;\n';
			this[valueName] = value ;
		}
		
		/**This will make values to save for the compiler use in the next run*/
		public function saveForCompiler():void
		{
			// TODO Auto Generated method stub
			if(!DevicePrefrence.isItPC)
			{
				return ;
			}
			var compilerValuesFile:File;
			compilerValuesFile = new File(_____compilerValuesLocation);
			//trace("compilerValuesFile : "+compilerValuesFile.url);
			//trace("compilerValuesFile is exists? :"+compilerValuesFile.exists);
			if(_____compilerValuesLocation!=null && compilerValuesFile!=null && compilerValuesFile.exists)
			{
				/*compilerValsAre = '';
				for(var i in this)
				{
					compilerValsAre+='public var '+i+':String ;\n';
				}*/
				//trace("compilerValsAre is : "+$compilerValsAre);
				
				TextFile.save(compilerValuesFile,_____compilerValsAre);
			}
		}
	}
}