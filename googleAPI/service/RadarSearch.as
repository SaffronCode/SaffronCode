package googleAPI.service
{
	import googleAPI.GoogleServices;
	import googleAPI.type.RadarSearchRespond;
	
	import restDoaService.RestDoaServiceCaller;
	
	public class RadarSearch extends RestDoaServiceCaller
	{
		public var data:RadarSearchRespond = new RadarSearchRespond()
		public function RadarSearch(offlineDataIsOK_v:Boolean=true, instantOfflineData_v:Boolean=true)
		{
			var date:Date = new Date();
			date.date -= 300 ;
			super("https://maps.googleapis.com/maps/api/place/radarsearch/json", data, offlineDataIsOK_v, instantOfflineData_v, date,true);
		}
		
		/**location=35.7137559,51.4149215
		 * radius=100
		 * type=city or restaurants or cafe or museums
		 * key=AIzaSyCkbBuVTlafh74gzZnifaEL7cglAMv_Drs*/
		
		public function load(latitude:String,longitude:String,radius:String,type:String='city'):void
		{
			super.loadParam({location:latitude+','+longitude,radius:radius,type:type,key:GoogleServices.getAPIKey()})
		}
	}
}