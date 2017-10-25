package wrokersJob
{
	import contents.alert.Alert;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;

	public class WorkerFunctions
	{
		private static var worker1:Worker ;
		
		private static var bgWorker_JSON_Pars : MessageChannel;
		
		private static var isReady:Boolean = false ;
		
		private static var bgWorker:Worker;
		
		private static var bgWorkerCommandChannel : MessageChannel;
		private static var customeChannel         : MessageChannel;
		
		public static function setUp():void
		{
			
			var workerBytes:ByteArray = FileManager.loadFile(new File("D://Sepehr//gitHub/sepehrEngine/SaffronEngine/Data-sample/bgWork.swf"));
			bgWorker = WorkerDomain.current.createWorker(workerBytes);
			
			bgWorker.addEventListener(Event.WORKER_STATE, workerStateHandler);
			
			bgWorkerCommandChannel = Worker.current.createMessageChannel(bgWorker);
			bgWorker.setSharedProperty("incomingCommandChannel", bgWorkerCommandChannel);
			
			
			customeChannel = bgWorker.createMessageChannel(Worker.current);
			customeChannel.addEventListener(Event.CHANNEL_MESSAGE, handlecustomeChannel)
			bgWorker.setSharedProperty("customeChannel", customeChannel);
			
			
			bgWorker.start();
		}
		
		private static function handlecustomeChannel(event:Event):void
		{
			var _txt:String = customeChannel.receive();
			Alert.show(_txt);
		}
		
		/**Worker state*/
		private static function workerStateHandler(e:Event) {
			var worker:Worker = e.currentTarget as Worker ;
			trace("Worker State : "+worker.state);
		}
		
		public static function JSONPars(str:String):void
		{
			trace("Date sent");
			bgWorkerCommandChannel.send("test");
		}
	}
}