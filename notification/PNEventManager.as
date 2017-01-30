package notification
{
	public class PNEventManager
	{
		public var alert:String,
					badgeValue:int,
					errorId:int,
					errorMsg:String,
					rawPayload:String,
					title:String,
					token:String,
					type:String;
					
		public var customPayload:Object ;
		
		
		public function PNEventManager()
		{
		}
	}
}