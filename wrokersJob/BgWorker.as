package wrokersJob
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	
	import mx.utils.Base64Decoder;
	import mx.utils.Base64Encoder;
	
	public class BgWorker extends MovieClip
	{
		public static const id_jsonParser:int = 1 ;
		public static const id_byteToBitmap:int = 2 ;
		public static const id_base64ToByte:int = 3 ;
		public static const id_byteToBase64:int = 4 ;
		
		
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
			var targetFile:File;
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
				case id_base64ToByte:
					if(callerData is String)
					{
						trace("*** File catched by worker : "+callerData);
						try
						{
							targetFile = new File(callerData as String);
							var fileStreamBase64:FileStream = new FileStream();
							trace("*** Read file ");
							fileStreamBase64.open(targetFile,FileMode.READ);
							var loadedString:String = fileStreamBase64.readUTFBytes(fileStreamBase64.bytesAvailable)  ;
							var baseDecoder:Base64Decoder = new Base64Decoder();
							baseDecoder.decode(loadedString);
							var decodedBytes:ByteArray = baseDecoder.toByteArray() ;
							fileStreamBase64.close();
							trace("*** File loaded");
							try
							{
								targetFile.deleteFile();
							}
							catch(e:Error){};
							
							fileStreamBase64.open(targetFile,FileMode.WRITE);
							fileStreamBase64.writeBytes(decodedBytes,0,decodedBytes.length);
							fileStreamBase64.close();
							
							createdData.push([targetFile.nativePath]);
							
							break;
						}
						catch(e:Error)
						{
							createdData.push([e.message]);
						}
					}
					else
					{
						createdData.push([null]);
					}
					break ;
				case id_byteToBase64:
					if(callerData is String)
					{
						trace("*** File catched by worker : "+callerData);
						try
						{
							targetFile = new File(callerData as String);
							var fileStreamByte:FileStream = new FileStream();
							trace("*** Read file ");
							fileStreamByte.open(targetFile,FileMode.READ);
							var baseEncoder:Base64Encoder = new Base64Encoder();
							var loadedBytes:ByteArray = new ByteArray();
							fileStreamByte.readBytes(loadedBytes,0,fileStreamByte.bytesAvailable)
							baseEncoder.encodeBytes(loadedBytes);
							fileStreamByte.close();
							trace("*** File loaded");
							createdData.push([baseEncoder.toString()]);
							try
							{
								targetFile.deleteFile();
							}
							catch(e:Error){};
						}
						catch(e:Error)
						{
							createdData.push([e.message]);
						}
					}
					else
					{
						createdData.push([null]);
					}
					break ;
				case id_byteToBitmap:
					try
					{
						var byte:ByteArray ;
						var fileTarget:String ;
						if(callerData[0] is ByteArray)
							byte = callerData[0];
						else
							fileTarget = callerData[0];
						var LoadInThisArea:Boolean = callerData[1] ;
						var W:Number = callerData[2] ;
						var H:Number = callerData[3] ;
						var keepImageRatio:Boolean = callerData[4] ;
						
						
						var loader:Loader = new Loader();
						var loaderContext:LoaderContext = new LoaderContext(true,ApplicationDomain.currentDomain);
						loaderContext.allowLoadBytesCodeExecution = true ;
						trace("- loader created ");
						loader.contentLoaderInfo.addEventListener(Event.COMPLETE,fileLoaded);
						loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,fileCantLoad);
						
						var fileLoader:FileStream ;
						
						if(fileTarget!=null)
						{
							trace("-The file should load to load it with loader");
							try
							{
								fileLoader = new FileStream();
								trace("-fileTarget : "+fileTarget);
								targetFile = new File(fileTarget);
								trace("-target file created");
								fileLoader.open(targetFile,FileMode.READ);
								byte = new ByteArray();
								fileLoader.readBytes(byte,0,fileLoader.bytesAvailable);
							}
							catch(e:Error)
							{
								createdData.push(["load byte error for image target "+fileTarget+" : "+e.getStackTrace()]);
								sendTheData(createdData);
								return ;
							}
						}
						
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
								bitmapData.dispose();
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
						function fileCantLoad(e:IOErrorEvent=null):void
						{
							createdData.push([fileTarget+' was '+new File(fileTarget).exists+' . '+e.toString()]);
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