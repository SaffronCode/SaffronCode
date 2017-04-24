package otherPlatforms.postMan
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	internal class ServiceGenerator
	{
		public var ServiceName:String ;
		public var myWebServiceLocation:String ;
		public var IsGet:Boolean ;
		
		private var serviceString:String = "package\n{\n\timport restDoaService.RestDoaServiceCaller;\n\t\n\tpublic class [ServiceName] extends RestDoaServiceCaller\n\t{\n\t\tpublic var data:* = {};\n\t\t\n\t\t" +
			"public function [ServiceName](offlineDataIsOK_v:Boolean=true, instantOfflineData_v:Boolean=false, maximomOfflineData:Date=null)\n\t\t{\n\t\t\t" +
			"super([myWebServiceLocation], data, offlineDataIsOK_v, instantOfflineData_v, maximomOfflineData," +
			" [IsGet]);\n\t\t}\n\t\t\n\t\tpublic function load([inputParam]):void\n\t\t{\n\t\t\tsuper.loadParam([inputParam2]);\n\t\t}\n\t}\n}";
		
		public var inputObject:Object;
		public var inputObjectClassName:String;
		
		public function ServiceGenerator()
		{
		}
		
		public function toString():String
		{
			var classString:String = serviceString.split("[ServiceName]").join(ServiceName)
				.split("[myWebServiceLocation]").join("'"+myWebServiceLocation+"'")
				.split("[IsGet]").join(String(IsGet));
			
			if(inputObject!=null)
			{
				var inputParams:String = "" ;
				var inputParamsFor:String = "" ;
				var parameters:Array = [] ;
				for(var i:String in inputObject)
				{
					trace('i+":"+getQualifiedClassName(inputObject[i]) : '+i+":"+getQualifiedClassName(inputObject[i]));
					parameters.push(i+":"+getQualifiedClassName(inputObject[i]));
				}
				parameters.sort();
				trace("params : "+parameters);
				inputParamsFor = '{';
				for(var j:uint ; j<parameters.length ; j++)
				{
					inputParams += parameters[j]+',' ;
					var inputVaraible:String = String(parameters[j]).split(':')[0] ;
					inputVaraible = inputVaraible+':'+inputVaraible ;
					inputParamsFor += inputVaraible+',' ;
					trace("0*** inputParams : "+inputParams);
				}
				
				inputParams = inputParams.substring(0,inputParams.length-1);
				inputParamsFor = inputParamsFor.substring(0,inputParamsFor.length-1);
				inputParamsFor += '}' ;
				trace("*** inputParams : "+inputParams);
				trace("*** inputParamsFor : "+inputParamsFor);
				classString = classString.split("[inputParam]").join(inputParams);
				classString = classString.split("[inputParam2]").join(inputParamsFor);
			}
			else
			{
				classString = classString.split("[inputParam]").join('');
				classString = classString.split("[inputParam2]").join('');
			}
			
			return classString ;
		}
	}
}