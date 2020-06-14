package socketService
{
	import com.mteamapp.JSONParser;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**Server connected and receveid data is ready to use*/
	[Event(name="complete", type="flash.events.Event")]
	/**Server connected but the input data was wrong*/
	[Event(name="error", type="flash.events.ErrorEvent")]
	/**Server is not connected*/
	[Event(name="unload", type="flash.events.Event")]
	/**Server data is changed*/
	[Event(name="change", type="flash.events.Event")]
	public class SocketCaller extends EventDispatcher
	{
		private var funcName:String ;
		
		private var socketListener:Socket ;
		
		private var sendThisJSON:String ;
		
		/**This will make jsons to pars again for debugging*/
		private const debug:Boolean = true ;
		
		private var offlineDataIsOK:Boolean,
					justLoadOffline:Boolean,
					maxAvailableDateForOffline:Date;
					private var dataSentOnce:Boolean;

					private var request:SocketRequestFormat;

					private var timeOutId:uint;

		/**This is the returned value from this service*/
		public var catchedData:SocketReceivedFormat;
		
		public function SocketCaller(theFunctionName:String,offlineDataIsOK_v:Boolean=false,justLoadOffline_v:Boolean=false,maxAvailableDateForOffline_v:Date=null)
		{
			funcName = theFunctionName ;
			offlineDataIsOK = offlineDataIsOK_v ;
			justLoadOffline = justLoadOffline_v ;
			maxAvailableDateForOffline = maxAvailableDateForOffline_v;
			
			socketListener = new Socket();
			//socketListener.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS,socketProggress);
		}
		
		/**Connection fails*/
		protected function noConnectionAvailable(event:IOErrorEvent):void
		{
			SaffronLogger.log("!! The connection fails");
			this.dispatchEvent(new Event(Event.UNLOAD));
		}
		
		/**Reload the request*/
		public function reLoad(delay:uint=20000):void
		{
			if(delay==0)
			{
				loadParam(request.Params);
			}
			else
			{
				timeOutId = setTimeout(loadParam,delay,request.Params);
			}
		}
		
		public function loadParam(sendData:Object):void
		{
			cansel();
			
			catchedData = null ;
			
			socketListener.addEventListener(ProgressEvent.SOCKET_DATA,socketDataRecevied);
			socketListener.addEventListener(Event.CONNECT,socketConnected);
			socketListener.addEventListener(IOErrorEvent.IO_ERROR,noConnectionAvailable);
			
			dataSentOnce = false ;
			request = new SocketRequestFormat(funcName,sendData);
			sendThisJSON = JSON.stringify(request); 
			
			if(offlineDataIsOK && justLoadOffline)
			{
				var oldData:String = SocketServiceSaver.load(funcName,sendThisJSON);
				if(oldData!=null)
				{
					socketDataRecevied(null,oldData);
					if(maxAvailableDateForOffline==null && SocketServiceSaver.isExpired(funcName,sendThisJSON,maxAvailableDateForOffline))
					{
						SaffronLogger.log("The offlie data dispatched but still need to get the new version of data from server");
					}
					else
					{
						SaffronLogger.log("The dispached data is updated");
						return ;
					}
				}
			}
			
			SaffronLogger.log("try to connect to server for "+funcName);
			socketListener.connect(SocketInit.ip,SocketInit.port);
		}
		
		/**Cansel the connection*/
		private function cansel():void
		{
			clearTimeout(timeOutId);
			socketListener.removeEventListener(ProgressEvent.SOCKET_DATA,socketDataRecevied);
			socketListener.removeEventListener(Event.CONNECT,socketConnected);
			socketListener.removeEventListener(IOErrorEvent.IO_ERROR,noConnectionAvailable);
			try
			{
				socketListener.close();
			}
			catch(e:Error)
			{
				//SocketListner.close error
			}
		}
		
			/**Socket connection is connected*/
			private function socketConnected(e:Event):void
			{
				SaffronLogger.log(">>Now send this : "+sendThisJSON);
				this.dispatchEvent(new Event(Event.CONNECT));
				socketListener.writeUTFBytes(sendThisJSON);
				socketListener.flush();
			}
			
			/**Dispatch error from server or cashed dat*/
				private function socketDataRecevied(e:ProgressEvent,myAbsolutData:String=null):void
				{
					var receivedData:String ;
					catchedData = new SocketReceivedFormat();
					if(myAbsolutData==null)
					{
						SaffronLogger.log("<<Socket data is : "+socketListener.bytesAvailable);
						if(socketListener.bytesAvailable>0)
						{							
							receivedData = socketListener.readUTFBytes(socketListener.bytesAvailable);
						}
						else
						{
							SaffronLogger.log("!!! there is no data on the socket !!!");	
							this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
							return;
						}
					}
					else
					{
						receivedData = myAbsolutData ;
					}
					
					if(receivedData.indexOf("error")==-1)
					{
						try
						{
							JSONParser.parse(receivedData,catchedData);
						}
						catch(e:Error)
						{
							SaffronLogger.log("The server data is not parsable");
							this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
							return ;
						}
					}
					else
					{
						SaffronLogger.log("error is :: "+receivedData);							
						this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
						return ;
					}
					
					if(offlineDataIsOK && myAbsolutData==null)
					{
						SocketServiceSaver.save(funcName,sendThisJSON,receivedData);
					}
					
					if(debug)
					{
						SaffronLogger.log("The returned data is : "+JSON.stringify(catchedData,null,' '));
					}
					var dataWasSentOnce:Boolean = dataSentOnce ;
					socketListener.close();
					dataSentOnce = true ;
					if(dataWasSentOnce)
					{
						this.dispatchEvent(new Event(Event.CHANGE));
					}
					else
					{
						this.dispatchEvent(new Event(Event.COMPLETE));
					}
				}
	}
}