package wrokersJob
{
	import contents.alert.Alert;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.system.Capabilities;
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
		
		/**This variable uses when you are in debugging mode*/
		private static var bgEmulator:BgWorker ;
		
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
			
			if(Capabilities.isDebugger)
			{
				bgEmulator = new BgWorker(handlecustomeChannel);
			}
			else
			{
				worker1.start();
			}
		}
		
		/**Worker state*/
		private static function workerStateHandler(e:Event) {
			var worker:Worker = e.currentTarget as Worker ;
			trace("Worker State : "+worker.state);
			isReady = worker.state == WorkerState.RUNNING ;
		}
		
		
		/**The receiver function will receive BitmapData or null*/
		public static function createBitmapFromByte(byte:ByteArray,receiver:Function):void
		{
			var currentId:uint = lastID++ ;
			
			funcList.push(receiver);
			idList.push(currentId);
			
			var toSendValue:Array = [currentId,byte] ;
			
			
			if(!Capabilities.isDebugger)
			{
				bgWorkerCommandChannel.send(toSendValue);
			}
			else
			{
				bgEmulator.handleCommandMessage(toSendValue);
			}
		}
		
		
		/**You will recevie your objec on your receiver function.*/
		public static function JSONPars(str:String,receiver:Function):void
		{
			var currentId:uint = lastID++ ;
			
			funcList.push(receiver);
			idList.push(currentId);
			
			var toSendValue:Array = [currentId,str] ;
			
			if(!Capabilities.isDebugger)
			{
				bgWorkerCommandChannel.send(toSendValue);
			}
			else
			{
				bgEmulator.handleCommandMessage(toSendValue);
			}
		}
		
		/**Received data from worker*/
		private static function handlecustomeChannel(eventOrDebugValue:*):void
		{
			trace('Receved event is : '+eventOrDebugValue);
			var received:Array;
			if(eventOrDebugValue is Array)
			{
				received = eventOrDebugValue ;
			}
			else
			{
				received = bgWorker_JSON_Pars.receive();
			}
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