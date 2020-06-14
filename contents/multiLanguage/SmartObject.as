package contents.multiLanguage
{
	import contents.TextFile;
	
	import flash.filesystem.File;

	dynamic public class SmartObject extends Object
	{
		include "compilerValues.as"
		
		private var _____compilerValuesLocation:String ;
		private var _____compilerValsAre:String;
		public var about_lable:*;
		
		public function SmartObject()
		{
			super();
			include "compilerValuesLocation.as"
			_____compilerValsAre = '' ;
		}
		
		/**This function will helps to save the values for compiler in the next run*/
		public function saveValue(valueName:String,value:String):void
		{
			_____compilerValsAre+='public var '+cleanValName(valueName)+':String ;\n';
			this[valueName] = value ;
		}
		
		private function cleanValName(valName:String):String
		{
			return valName.split('(').join('').split(')').join('');
		}
		
		/**This will make values to save for the compiler use in the next run*/
		public function saveForCompiler():void
		{
			
			if(!DevicePrefrence.isItPC)
			{
				return ;
			}
			var compilerValuesFile:File;
			if(_____compilerValuesLocation)
			{
				compilerValuesFile = new File(_____compilerValuesLocation);
			}
			//SaffronLogger.log("compilerValuesFile : "+compilerValuesFile.url);
			//SaffronLogger.log("compilerValuesFile is exists? :"+compilerValuesFile.exists);
			if(_____compilerValuesLocation!=null && compilerValuesFile!=null && compilerValuesFile.exists)
			{
				/*compilerValsAre = '';
				for(var i in this)
				{
					compilerValsAre+='public var '+i+':String ;\n';
				}*/
				//SaffronLogger.log("compilerValsAre is : "+$compilerValsAre);
				
				TextFile.save(compilerValuesFile,_____compilerValsAre);
			}
		}
	}
}