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
		
		private static var  funcList:Vector.<Function>,
							idList:Vector.<uint>;
							
		private static var lastID:uint = 0 ;
		
		public static function setUp():void
		{
			funcList = new Vector.<Function>() ;
			idList = new Vector.<uint>() ;
			
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
		
		/**Worker state*/
		private static function workerStateHandler(e:Event) {
			var worker:Worker = e.currentTarget as Worker ;
			trace("Worker State : "+worker.state);
			isReady = worker.state == WorkerState.RUNNING ;
		}
		
		/**You will recevie your objec on your receiver function.*/
		public static function JSONPars(str:String,receiver:Function):void
		{
			trace("Date sent");
			
			var currentId:uint = lastID++ ;
			
			funcList.push(receiver);
			idList.push(currentId);
			
			bgWorkerCommandChannel.send([currentId,str]);
		}
		
		/**Received data from worker*/
		private static function handlecustomeChannel(event:Event):void
		{
			var received:Array = bgWorker_JSON_Pars.receive();
			callFunction(received[0],received[1]);
		}
		
		/**Send this data to its recever*/
		private static function callFunction(callerId:uint,data:Object):void
		{
			Alert.show(callerId+' >> '+data);
			var I:int = idList.indexOf(callerId) ;
			if(I!=-1)
			{
				funcList[I](data);
				
				funcList.removeAt(I);
				idList.removeAt(I);
			}
		}
	}
}