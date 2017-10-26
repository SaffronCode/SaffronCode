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
	import flash.utils.getQualifiedClassName;
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
					createdData.push([JSON.parse(String(callerData))]);
					break ;
				case id_byteToBitmap:
					try
					{
						var byte:ByteArray = callerData[0] ;
						var LoadInThisArea:Boolean = callerData[1] ;
						var W:Number = callerData[2] ;
						var H:Number = callerData[3] ;
						var keepImageRatio:Boolean = callerData[4] ;
						
						
						var loader:Loader = new Loader();
						loader.contentLoaderInfo.addEventListener(Event.COMPLETE,fileLoaded);
						loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,fileCantLoad);
						loader.loadBytes(byte);
						
						function fileLoaded(e:Event):void
						{
							try
							{
								var bitmapData:BitmapData = (loader.content as Bitmap).bitmapData ;
								
								if(W!=0 && H!=0)
								{
									trace("Change image size to : "+W,H);
									bitmapData = BitmapEffects.changeSize(bitmapData,W,H,keepImageRatio,LoadInThisArea);
								}
								else if(W!=0)
								{
									bitmapData = BitmapEffects.changeSize(bitmapData,W,bitmapData.height*(W/bitmapData.width),keepImageRatio,LoadInThisArea);
									H = bitmapData.height;
								}
								else if(H!=0)
								{
									bitmapData = BitmapEffects.changeSize(bitmapData,bitmapData.width*(H/bitmapData.height),H,keepImageRatio,LoadInThisArea);
									W = bitmapData.width;
								}
								
								createdData.push([bitmapData.getPixels(bitmapData.rect),bitmapData.rect.width,bitmapData.rect.height]);
								sendTheData(createdData);
								return ;
							}
							catch(err:Error)
							{
								createdData.push(["Image loader on worker error : "+err.getStackTrace()]);
								sendTheData(createdData);
								return;
							}
						}
						function fileCantLoad(e:Event=null):void
						{
							createdData.push([null]);
							sendTheData(createdData);
						}
						return ;
					}
					catch(e:Error)
					{
						createdData.push([e.message]);
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