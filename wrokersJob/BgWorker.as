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
		
		public function BgWorker()
		{
			super();
			
			if(!Worker.current.isPrimordial){
				commandChannel = Worker.current.getSharedProperty("incomingCommandChannel") as MessageChannel;
				commandChannel.addEventListener(Event.CHANNEL_MESSAGE, handleCommandMessage);
				
				customeChannel   = Worker.current.getSharedProperty("bgWorker_JSON_Pars") as MessageChannel;
				
			}
		}
		
		public function handleCommandMessage(event:Event) : void
		{
			var receveidData:Array = commandChannel.receive();
			var callerId:uint = receveidData[0] ;
			var callerData:String = receveidData[1] ;
			
			customeChannel.send(
				[
					callerId
					,
					JSON.parse(String(callerData))
				]
			);//JSON.parse(r_message)
			return;
		}
	}
}