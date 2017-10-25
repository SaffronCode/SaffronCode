package wrokersJob
{
	import contents.alert.Alert;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.system.WorkerState;
	import flash.utils.ByteArray;

	public class WorkerFunctions
	{
		private static var worker1:Worker ;
		
		private static var bgWorker_JSON_Pars : MessageChannel;
		
		private static var isReady:Boolean = false ;
		
		
		private static var bgWorkerCommandChannel : MessageChannel;
		
		public static function setUp():void
		{
			
			var workerBytes:ByteArray = FileManager.loadFile(new File("D://Sepehr//gitHub/sepehrEngine/SaffronEngine/Data-sample/bgWork.swf"));
			worker1 = WorkerDomain.current.createWorker(workerBytes);
			
			worker1.addEventListener(Event.WORKER_STATE, workerStateHandler);
			
			bgWorkerCommandChannel = Worker.current.createMessageChannel(worker1);
			worker1.setSharedProperty("incomingCommandChannel", bgWorkerCommandChannel);
			
			
			bgWorker_JSON_Pars = worker1.createMessageChannel(Worker.current);
			bgWorker_JSON_Pars.addEventListener(Event.CHANNEL_MESSAGE, handlecustomeChannel)
			worker1.setSharedProperty("bgWorker_JSON_Pars", bgWorker_JSON_Pars);
			
			
			worker1.start();
		}
		
		private static function handlecustomeChannel(event:Event):void
		{
			var _txt:* = bgWorker_JSON_Pars.receive();
			Alert.show(JSON.stringify(_txt));
		}
		
		/**Worker state*/
		private static function workerStateHandler(e:Event) {
			var worker:Worker = e.currentTarget as Worker ;
			trace("Worker State : "+worker.state);
			isReady = worker.state == WorkerState.RUNNING ;
		}
		
		public static function JSONPars(str:String):void
		{
			trace("Date sent");
			bgWorkerCommandChannel.send(str);
		}
	}
}