package wrokersJob
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	public class BgWorker extends MovieClip
	{
		public static const id_jsonParser:int = 1 ;
		public static const id_byteToBitmap:int = 2 ;
		
		
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
			//trace("Receved data on bgWorker is : "+receveidData);
			var callerId:uint = receveidData[1] ;
			var callerData:Object = receveidData[2] ;
			
			/**0:Caller id, 1:Data*/
			var createdData:Array = [callerId];
			
			switch(receveidData[0])
			{
				case id_jsonParser:
					createdData.push(JSON.parse(String(callerData)))
					break ;
				case id_byteToBitmap:
					try
					{
						var loader:Loader = new Loader();
						loader.contentLoaderInfo.addEventListener(Event.COMPLETE,fileLoaded);
						loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,fileCantLoad);
						loader.loadBytes(callerData as ByteArray);
						
						function fileLoaded(e:Event):void
						{
							try
							{
								var loadedBitmap:BitmapData = (loader.content as Bitmap).bitmapData ;
								createdData.push([loadedBitmap.getPixels(loadedBitmap.rect),loadedBitmap.rect.width,loadedBitmap.rect.height]);
								sendTheData(createdData);
								return ;
							}
							catch(err:Error)
							{
								createdData.push("Image loader on worker error : "+err.getStackTrace());
								sendTheData(createdData);
								return;
							}
						}
						function fileCantLoad(e:Event=null):void
						{
							createdData.push(null);
							sendTheData(createdData);
						}
						return ;
					}
					catch(e:Error)
					{
						createdData.push(e.message);
					}
					break;
			}
			
			sendTheData(createdData);
			return;
		}
		
		/**Created datas first variable is receiverId and the second one is the data*/
		private function sendTheData(createdData:Array):void
		{
			if(DebugReceverFunction!=null)
			{
				DebugReceverFunction(createdData)
			}
			else
			{
				senderChannel.send(createdData);
			}
		}
	}
}