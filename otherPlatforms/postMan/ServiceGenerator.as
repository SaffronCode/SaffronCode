package otherPlatforms.postMan
{
	internal class ServiceGenerator
	{
		public var ServiceName:String ;
		public var myWebServiceLocation:String ;
		public var IsGet:Boolean ;
		
		private var serviceString:String = "package\n{\n\timport restDoaService.RestDoaServiceCaller;\n\t\n\tpublic class [ServiceName] extends RestDoaServiceCaller\n\t{\n\t\tpublic var data:* = {};\n\t\t\n\t\t" +
			"public function [ServiceName](offlineDataIsOK_v:Boolean=true, instantOfflineData_v:Boolean=false, maximomOfflineData:Date=null)\n\t\t{\n\t\t\t" +
			"super([myWebServiceLocation], data, offlineDataIsOK_v, instantOfflineData_v, maximomOfflineData," +
			" [IsGet]);\n\t\t}\n\t\t\n\t\tpublic function load():void\n\t\t{\n\t\t\tsuper.loadParam();\n\t\t}\n\t}\n}";
		public function ServiceGenerator()
		{
		}
		
		public function toString():String
		{
			return serviceString.split("[ServiceName]").join(ServiceName)
				.split("[myWebServiceLocation]").join(myWebServiceLocation)
				.split("[IsGet]").join(String(IsGet));
		}
	}
}