package wrokersJob
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	
	public class BgWorker extends MovieClip
	{
		private var commandChannel:MessageChannel;
		private var customeChannel:MessageChannel;
		
		private var DebugReceverFunction:Function ;
		
		public function BgWorker(debuggerReceverFunction:Function=null)
		{
			super();
			
			DebugReceverFunction = debuggerReceverFunction ;
			
			if(!Worker.current.isPrimordial){
				commandChannel = Worker.current.getSharedProperty("incomingCommandChannel") as MessageChannel;
				commandChannel.addEventListener(Event.CHANNEL_MESSAGE, handleCommandMessage);
				
				customeChannel   = Worker.current.getSharedProperty("bgWorker_JSON_Pars") as MessageChannel;
				
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
				receveidData = commandChannel.receive() ;
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
				customeChannel.send(createdData);
			}
			return;
		}
	}
}