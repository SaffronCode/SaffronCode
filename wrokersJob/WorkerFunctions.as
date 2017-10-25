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
		
		public static function setUp():void
		{
			
			var workerBytes:ByteArray = FileManager.loadFile(File.applicationDirectory.resolvePath("Data/bgWork.swf"));
			worker1 = WorkerDomain.current.createWorker(workerBytes);
			
			worker1.addEventListener(Event.WORKER_STATE, workerStateHandler);
			
			bgWorker_JSON_Pars = Worker.current.createMessageChannel(worker1);
			bgWorker_JSON_Pars.addEventListener(Event.CHANNEL_MESSAGE, handlecustomeChannel)
			worker1.setSharedProperty("bgWorker_JSON_Pars", bgWorker_JSON_Pars);
			
			
			worker1.start();
		}
		
		private static function handlecustomeChannel(event:Event):void
		{
			trace("Data received");
			var data:String ;
			try
			{
				data = String(bgWorker_JSON_Pars.receive()) ;
			}
			catch(e:Error)
			{
				Alert.show(e.getStackTrace());
			}
		}
		
		/**Worker state*/
		private static function workerStateHandler(e:Event) {
			var worker:Worker = e.currentTarget as Worker ;
			trace("Worker State : "+worker.state);
		}
		
		public static function JSONPars(str:String):void
		{
			trace("Date sent");
			bgWorker_JSON_Pars.send(str);
		}
	}
}