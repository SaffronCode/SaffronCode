package wrokersJob
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	
	public class BgWorker extends MovieClip
	{
		private var receiverChannel:MessageChannel;
		private var senderChannel:MessageChannel;
		
		private var DebugReceverFunction:Function ;
		
		public function BgWorker(debuggerReceverFunction:Function=null)
		{
			super();
			
			DebugReceverFunction = debuggerReceverFunction ;
			
			if(!Worker.current.isPrimordial){
				receiverChannel = Worker.current.getSharedProperty("senderChannel_fromMainProject") as MessageChannel;
				receiverChannel.addEventListener(Event.CHANNEL_MESSAGE, handleCommandMessage);
				
				senderChannel   = Worker.current.getSharedProperty("receiverChannel_fromMainProject") as MessageChannel;
				
			}
		}
		
		public function handleCommandMessage(eventOrValue:*) : void
		{
			var receveidData:Array;
			if(eventOrValue is Array)
			{
				receveidData = eventOrValue ;
			}
			else
			{
				receveidData = receiverChannel.receive() ;
			}
			var callerId:uint = receveidData[0] ;
			var callerData:String = receveidData[1] ;
			
			var createdData:Array = [
					callerId
					,
					JSON.parse(String(callerData))
				];
			
			if(DebugReceverFunction!=null)
			{
				DebugReceverFunction(createdData)
			}
			else
			{
				senderChannel.send(createdData);
			}
			return;
		}
	}
}