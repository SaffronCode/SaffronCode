package restService
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**Cannot connect to server*/
	[Event(name="CONNECTION_ERROR", type="restService.RestEvent")]
	/**Server returns error, use Error code or msg list*/
	[Event(name="SERVER_ERROR", type="restService.RestEvent")]
	/**Result returned*/
	[Event(name="SERVER_RESULT", type="restService.RestEvent")]
	/**Result updated - this event uses when you requested for offline datas*/
	[Event(name="SERVER_RESULT_UPDATE", type="restService.RestEvent")]
	public class RestServiceCaller extends EventDispatcher 
	{
		private var instantOfflineData:Boolean,
					offlineDataIsOK:Boolean,
					lastPureData:String,
					onUpdateProccess:Boolean;
					
		public function get pureData():String
		{
			return lastPureData ;
		}
		
		/**main loader class*/
		private var requestLoader:URLLoader;
		
		/**This is the webservice file on RestService.domain
		private var serviceName:String ;*/
		
		/**This is the request you need to send*/
		private var pureRequest:URLRequest ;
		
		/**Reload timeOut ID*/
		private var timerId:uint ;
		
		/**This is the last acceptable date for loaded value*/
		private var offlineDate:Date ;
		
		/**This is the value*/
		private var parser:RestFullJSONParser ;
		
		public var requestedData:Object ;
		
		/**Service id*/
		private var myId:String,
					myParams:String='';
		
		
		
		/**Do not pass null value as RequestedData, it will cause an Error!!<br>
		 * Integer or numeric values will loose*/
		public function RestServiceCaller(myWebServiceLocation:String,RequestedData:Object,offlineDataIsOK_v:Boolean=true,instantOfflineData_v:Boolean=false,maximomOfflineData:Date = null,useGetMethode:Boolean=false)
		{
			if(maximomOfflineData==null)
			{
				maximomOfflineData = new Date();
			}
			offlineDate = maximomOfflineData ;
			
			offlineDataIsOK = offlineDataIsOK_v ;
			instantOfflineData = instantOfflineData_v ;
			myId = myWebServiceLocation ;
			requestedData = RequestedData ;
			if(requestedData == null)
			{
				throw "Dont pass null value as RequestedData";
			}
			//serviceName = myWebServiceLocation ;
			
			pureRequest = new URLRequest(RestService.domain+myWebServiceLocation);
			if(useGetMethode)
			{
				pureRequest.method = URLRequestMethod.GET ;
			}
			else
			{
				pureRequest.method = URLRequestMethod.POST ;
			}
			
			var newHeader:URLRequestHeader = new URLRequestHeader('api-key','A4593387-2C4F-4FB6-8AFC-5AC3F3C6B80EEAD9075D-394C-4463-B4B2-C677F5CAA04B');
			var newHeader2:URLRequestHeader = new URLRequestHeader('Content-Type','application/json');
			
				//headers.Add("dh-U", signIn.Member.UId.ToString());
				//headers.Add("dh-UAuth", signIn.Member.UIdAuth.ToString());
			if(RestService.UId == '' || RestService.UIdAuth == '')
			{
				trace("*** Warning, User is not logged in yet ***");
			}
			
			var newHeader3:URLRequestHeader = new URLRequestHeader('dh-U',RestService.UId);
			var newHeader4:URLRequestHeader = new URLRequestHeader('dh-UAuth',RestService.UIdAuth);
			
			pureRequest.requestHeaders.push(newHeader);
			pureRequest.requestHeaders.push(newHeader2);
			pureRequest.requestHeaders.push(newHeader3);
			pureRequest.requestHeaders.push(newHeader4);
			
			requestLoader = new URLLoader();
			if(requestedData is ByteArray)
			{
				trace("Requested type is Bitnary");
				requestLoader.dataFormat = URLLoaderDataFormat.BINARY ;
			}
			else
			{
				requestLoader.dataFormat = URLLoaderDataFormat.TEXT ;
			}
			requestLoader.addEventListener(Event.COMPLETE,requestLoaded);
			requestLoader.addEventListener(IOErrorEvent.IO_ERROR,noInternet);
		}
		
		/**This function will change the maximomOfflineData value to new date<br>
		 * null changes with new Date();*/
		public function changeOfflineDate(newDate:Date=null):void
		{
			if(newDate == null)
			{
				newDate = new Date();
			}
			offlineDate = newDate ;
		}
		
		private function noInternet(e:IOErrorEvent=null,controllData:Boolean=true)
		{
			trace("No internet connection");
			if(controllData && offlineDataIsOK)
			{
				var savedData:* = RestServiceSaver.load(myId,myParams);
				if(savedData != null)
				{
					trace("Saved data is not null");
					if(RestService.debug_show_results)
					{
						trace("* cashed data for "+myId+" : "+savedData);
					}
					parsLoadedData(savedData,true);
					return ;
				}
			}
			//this.dispatchEvent(new RestEvent(RestEvent.CONNECTION_ERROR));
			//RestService.eventDispatcher.dispatchEvent(new RestEvent(RestEvent.CONNECTION_ERROR,null,ErrorEnum.ConnectionError));
			dispatch(new RestEvent(RestEvent.CONNECTION_ERROR,null,ErrorEnum.ConnectionError));
		}
		
		private function requestLoaded(event:Event):void
		{
			// TODO Auto-generated method stub
			//parser = new JSONParser();
			if(RestService.debug_show_results)
			{
				try
				{
					trace("* fresh data for "+myId+" : "+JSON.stringify(JSON.parse(requestLoader.data),null,' '));
				}
				catch(e)
				{
					trace("* JSON model had problem : "+requestLoader.data);
				}
			}
			
			parsLoadedData(requestLoader.data);
		}
		
		private function parsLoadedData(loadedData:*,alreadyLoadedFromCash:Boolean=false):void
		{
			parser = new RestFullJSONParser(loadedData,requestedData);
			
			if(parser.error)
			{
				trace("Server problem");
				//if(this.hasEventListener(RestEvent.SERVER_ERROR))
				var serverError:RestEvent = new RestEvent(RestEvent.SERVER_ERROR,parser.msgs,parser.exceptionType) ;
				if(hasErrorListenerAndDispatchOnglobal(serverError))
				{	
					//this.dispatchEvent(new RestEvent(RestEvent.SERVER_ERROR,parser.msgs));
					//RestService.eventDispatcher.dispatchEvent(new RestEvent(RestEvent.SERVER_ERROR,parser.msgs,parser.exceptionType));
					dispatch(serverError);
				}
				else
				{
					trace("User is not listening to ServerError, so ConnectionError Dispatches");
					noInternet(null,false);
				}
			}
			else
			{
				//Save the server data
				if(offlineDataIsOK && !alreadyLoadedFromCash)
				{
					RestServiceSaver.save(myId,myParams,loadedData);
				}
				trace("Data is ready to use");
				if(onUpdateProccess)
				{
					if(lastPureData!=loadedData)
					{
						trace("* This update is new");
						dispatch(new RestEvent(RestEvent.SERVER_RESULT_UPDATE));
						//this.dispatchEvent(new RestEvent(RestEvent.SERVER_RESULT_UPDATE));
					}
					else
					{
						trace("* Nothing change on this update");
					}
				}
				else
				{
					//this.dispatchEvent(new RestEvent(RestEvent.SERVER_RESULT));
					dispatch(new RestEvent(RestEvent.SERVER_RESULT))
				}
			}
			lastPureData = loadedData ;
		}
		
		/**Values are not case sencitive*/
		protected function loadParam(obj:Object=null):void
		{
			cansel();
			
			onUpdateProccess = false ;
			if(obj!=null)
			{
				myParams = RestFullJSONParser.stringify(obj) ;
				pureRequest.data = myParams ;
			}
			trace("instantOfflineData : "+instantOfflineData);
			if(instantOfflineData)
			{
				var savedData:* = RestServiceSaver.load(myId,myParams);
				if(savedData != null)
				{
					var expired:Boolean = RestServiceSaver.isExpired(myId,myParams,offlineDate);
					if(RestService.debug_show_results)
					{
						trace("* instant cashed data for "+myId+" : "+savedData);
					}
					parsLoadedData(savedData);
					if(expired)
					{
						onUpdateProccess = true ;
					}
					else
					{
						trace("* no need to update instant data")
						return ;
					}
				}
			}
			
			
			cansel();
			trace(myId+" : "+myParams);
			
			//debug line
				requestLoader.load(pureRequest);
				//noInternet();
		}
		
		public function reLoad(delay:uint=20000):void
		{
			cansel();
			
			timerId = setTimeout(loadParam,delay)
		}
		
		/**Cansel all process*/
		public function cansel()
		{
			clearTimeout(timerId);
			if(requestLoader!=null)
			{
				try
				{
					requestLoader.close();
				}
				catch(e)
				{
					//trace("No stream opened :\n"+e);
				}
			}
		}
		
		/**If no listener added to errors, it will return false and dispatch current error to global dispatcher on RestService*/
		private function hasErrorListenerAndDispatchOnglobal(event:Event):Boolean
		{
			if(this.hasEventListener(event.type))
			{
				return true ;
			}
			else
			{
				RestService.eventDispatcher.dispatchEvent(event);
				return false ;
			}
		}
		
		private function dispatch(event:Event):void
		{
			trace("Dispatch : "+event.type);
			this.dispatchEvent(event);
			RestService.eventDispatcher.dispatchEvent(event);
		}
		
	}
}