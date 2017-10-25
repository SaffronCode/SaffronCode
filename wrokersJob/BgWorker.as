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
				
				customeChannel   = Worker.current.getSharedProperty("customeChannel") as MessageChannel;
				
			}
		}
		
		public function handleCommandMessage(event:Event) : void
		{
			var r_message = commandChannel.receive();
			if (r_message == "test") {
				
				for (var i = 1; i <= 500;i++){
					customeChannel.send("SepehrXXX"+Math.random()*999999999);
				}	
				
			}
			return;
		}
	}
}