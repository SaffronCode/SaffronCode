package
{
	import restDoaService.RestDoaServiceCaller;
	
	public class enc extends RestDoaServiceCaller
	{
		public var data:* ;
		
		/***/
		public function enc(offlineDataIsOK_v:Boolean=true, instantOfflineData_v:Boolean=false, maximomOfflineData:Date=null)
		{
			super('////api/enc', data, offlineDataIsOK_v, instantOfflineData_v, maximomOfflineData, true);
		}
		
		public function load(key:String,val:String):void
		{
			super.loadParam({key:key,val:val});
		}
	}
}