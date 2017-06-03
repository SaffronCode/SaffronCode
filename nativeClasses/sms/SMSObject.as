package nativeClasses.sms
{
	public class SMSObject
	{
		/**"id": 6884,*/
		public var id:uint;
		/** "type": 1*/
		public var type:String;
		/**"body": "Hi me",*/
		public var body:String;
		/**"date": "Sat Jun 3 11:36:52 GMT+0430 2017",*/
		public var date:String;
		/**"address": "+989127785180",*/
		public var address:String;
		/**"time": 1496473612,*/
		public var time:uint;
		/**"protocol": 0,*/
		public var protocol:uint;
		
		/** {
		  "body": "Hi me",
		  "date": "Sat Jun 3 11:36:52 GMT+0430 2017",
		  "time": 1496473612,
		  "protocol": 0,
		  "id": 6884,
		  "address": "+989127785180",
		  "type": 1
		 },*/
		public function SMSObject(obj:Object)
		{
			id = obj.id ;
			type = obj.type ;
			address = obj.address ;
			date = obj.date ;
			body = obj.body ;
			time = obj.time ;
			protocol = obj.protocol ;
		}
	}
}