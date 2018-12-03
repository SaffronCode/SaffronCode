package socketJ
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class SocketJ
	{
		private static var socketListener:Socket ;
		
		private static var Ip:String,Port:uint ;
		
		private static var shouldBeConnect:Boolean = false ;
		
		private static var dispatcher:SocketJDispatcher;
		
		private static var connectionRetrierInterval:uint = 5000 ;
		private static var connectionRetrierTimeOutId:uint;
		
		
		private static var dataToSendList:Vector.<SocketJRequestModel> ;
		
		/**Pass true for ConnectInstantly variable to make it connect to server isntantly, otherwise, you should call Connect function by your self*/
		public static function setUp(ip:String,port:uint,connectInstantly:Boolean=false):void
		{
			if(socketListener==null)
			{
				socketListener = new Socket();
				dispatcher = new SocketJDispatcher();
			}
			else
			{
				disconnect();
			}
			
			dataToSendList = new Vector.<SocketJRequestModel>();
			
			Ip = ip ;
			Port = port ;
			
			socketListener.addEventListener(ProgressEvent.SOCKET_DATA,socketDataRecevied);
			socketListener.addEventListener(Event.CONNECT,socketConnected);
			socketListener.addEventListener(IOErrorEvent.IO_ERROR,noConnectionAvailable);
			socketListener.addEventListener(Event.CLOSE,socketClosed);
			socketListener.addEventListener(SecurityErrorEvent.SECURITY_ERROR,sercurityError);
			socketListener.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS,socketDataOutputOk);
			
			if(connectInstantly)
			{
				connect();
			}
		}
		
		protected static function socketClosed(event:Event):void
		{
			trace("* SocketJ disconnected *");
			if(shouldBeConnect)
			{
				connect();
			}
		}
		
		protected static function noConnectionAvailable(event:IOErrorEvent):void
		{
			trace("* SocketJ no connection available, try to connect again");
			tryToConnectLater();
		}
		
		protected static function socketConnected(event:Event):void
		{
			trace("* SocketJ connected!! *");
			tryToSendLastData();
		}
		
		protected static function socketDataRecevied(event:ProgressEvent):void
		{
			// TODO Auto-generated method stub
			trace("* SocketJ Some Data received *");
		}
		
		protected static function sercurityError(event:SecurityErrorEvent):void
		{
			trace("* SocketJ security Error, Socket should be disconnect *");
			disconnect();
		}
		
		/**From now, your server should allways be connect*/
		public static function connect():void
		{
			disconnect();

			trace("* SocketJ try connect "+Ip+":"+Port+" *");
			if(shouldBeConnect==false)
			{
				dispatcher.dispatchEvent(new Event(Event.CONNECT));
			}
			shouldBeConnect = true ;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,internetConnectionIsOK);
			loader.addEventListener(IOErrorEvent.IO_ERROR,noInternetConnectionStablished);
			loader.load(new URLRequest("https://google.com"));
		}
		
			/**There is no connection at all, try to connect later till disconnect function calls.*/
			protected static function noInternetConnectionStablished(event:IOErrorEvent):void
			{
				trace("* SocketJ no internet Connection Stablished *");
				tryToConnectLater();
			}
			
			/**Try to connect to server later*/
			private static function tryToConnectLater():void
			{
				clearTimeout(connectionRetrierTimeOutId);
				if(shouldBeConnect)
				{
					connectionRetrierTimeOutId = setTimeout(connect,connectionRetrierInterval);
				}
			}
			
			/**Stop connectiong*/
			private static function stopConnecting():void
			{
				clearTimeout(connectionRetrierTimeOutId);
			}
			
			private static function internetConnectionIsOK(e:Event)
			{
				trace("* SocketJ is connected to web, try to conect to your socket now");
				socketListener.connect(Ip,Port);
			}
		
		/**From this time, all connection should drop*/
		public static function disconnect():void
		{
			stopConnecting();
			shouldBeConnect = false ;
			if(socketListener.connected)
				socketListener.close();
			
			trace("* SockjetJ Disconnected *");
			
			if(shouldBeConnect==false)
			{
				dispatcher.dispatchEvent(new Event(Event.CLOSE));
			}
		}
		
		
		
		////////////////////////////////////////////////////////////////////////////
		
		/**Send data to server, it will open the connection if the connection was closed.*/
		public static function sendData(functinoId:uint,dataToSend:Object,replaceWithUnSentCommand:Boolean=true):void
		{
			if(replaceWithUnSentCommand)
			{
				for(var i:int = 0 ; i<dataToSendList.length ; i++)
				{
					if(functinoId == dataToSendList[i].FunctionId)
					{
						dataToSendList.splice(i,1);
						i--;
					}
				}
			}
			dataToSendList.push(new SocketJRequestModel(functinoId,dataToSend));
			if(socketListener.connected)
			{
				tryToSendLastData();
			}
			else
			{
				connect();
			}
		}
		
			/**Try to send data que*/
			private static function tryToSendLastData():void
			{
				if(dataToSendList.length>0)
				{
					trace("* SocketJ try to send first data *");
					socketListener.writeUTFBytes(JSON.stringify(dataToSendList[0]));
					socketListener.flush();
				}
				else
				{
					trace("* SocketJ No data left to send *");
				}
			}
			
			/**Socket data sent*/
			protected static function socketDataOutputOk(event:OutputProgressEvent):void
			{
				// TODO Auto-generated method stub
				trace("* Socket data sent *");
				if(event.bytesPending==0)
				{
					dataToSendList.shift();
					tryToSendLastData();
				}
			}
	}
}