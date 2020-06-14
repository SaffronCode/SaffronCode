package webService3
{
	
	import contents.Contents;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.rpc.AsyncToken;
	

	
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="unload", type="flash.events.Event")]
	/**On server error*/
	[Event(name="error", type="flash.events.ErrorEvent")]
	
	//Global event direcly from myWebService ↓
	/**This will not dispatches*/
	[Event(name="NO_CONNECTTION", type="webService2.WebEvent2")]
	
	public class WebServiceCaller3 extends EventDispatcher
	{
		/**Global event dispatcher*/
		public static var globalEventDispatcher:WebServiceCaller3 = new WebServiceCaller3(null);
		
		
		/**This is reload time out id*/
		private var timerId:int ;
		
		
		public var connected:Boolean = false ;
		
		private var myToken:AsyncToken;
		
		private var myParam:Array ;
		
		//public var data:Vector.<GetPhotos>;
		
		//#0
		private var offlineDate:Date,
					_justLoadOffline:Boolean,
					offlineDataIsOK:Boolean;
					
		//private var myServiceFunction:Function ;
		private var serviceName:String ;

		private var connectinError:WebEvent3;
		
		
		
		public function get justLoadOffline():Boolean
		{
			return _justLoadOffline;
		}

		public function set justLoadOffline(value:Boolean):void
		{
			_justLoadOffline = value;
			if(_justLoadOffline && offlineDate == null)
			{
				offlineDate = new Date();
				offlineDate.minutes-=Number(Contents.config.max_available_service_data);
			}
			else
			{
				offlineDate = null ;
			}
		}

		/**This function will change the maximomOfflineData value to new date<br>
		 * null will remove date controller condition*/
		public function changeOfflineDate(newDate:Date=null):void
		{
			offlineDate = newDate ;
		}
		
		
		public function WebServiceCaller3(webServiceName:String,offlineDataIsOK_v:Boolean=true,justLoadOfline_v:Boolean=false,maximomOfflineData:Date=null)
		{
			//TODO: implement function
			//#4
			//myServiceFunction = myWebService ;
			//New line ↓
			if(justLoadOfline_v && maximomOfflineData == null)
			{
				maximomOfflineData = new Date();
				maximomOfflineData.minutes-= Number(Contents.config.max_available_service_data);
			}
			offlineDate = maximomOfflineData ;
			myWebService3.setOperation(webServiceName);
			
			serviceName = webServiceName ;
			offlineDataIsOK = offlineDataIsOK_v ;
			_justLoadOffline = justLoadOfline_v ;
			super();
		}
		
		protected function loadParams(...params):void
		{
			SaffronLogger.log(serviceName+' - offlineDataIsOK:'+offlineDataIsOK+' _justLoadOffline:'+_justLoadOffline);
			connectinError = null ;
			myParam = params ;
			//#1
			reLoadLastRequest();
		}
		
		/**I created this function to make reload available*/
		private function reLoadLastRequest()
		{
			if(_justLoadOffline && generateDataAndDispatchEvent(null,false,true))
			{
				//Cashed data sent to user class on generateDataAndDispatchEvent function
			}
			else
			{
				//If no oflinte data requests or no oflinte data avaiable
				myWebService3.Connect(onConnected,noInternet);
			}
		}
		
		
		/**Make this service reloads again<br>
		 * After few tests, I noticed that the 10 second delay is not enaugh
		 * <br>
		 * This is on beta testing yet*/
		public function reLoad(delay:uint=20000):void
		{
			//I prefer to dont cansel the current webservice
			//cansel();
			clearTimeout(timerId);
			
			//LoadForDoubleControll = false,
			//	offlineValuesToSend = null;
			
			if(delay==0)
			{
				reLoadLastRequest();
			}
			else
			{
				timerId = setTimeout(reLoadLastRequest,delay);
			}
		}
		
		public function cansel()
		{
			clearTimeout(timerId);
			//TODO: implement function
			myWebService3.eventListen.removeEventListener(WebEvent3.NO_CONNECTTION,noInternet);
			myWebService3.eventListen.removeEventListener(WebEvent3.RESULT,loaded);
			myWebService3.Disconnect(onConnected,noInternet);
			myWebService3.CanselThisToken(myToken);
		}
		
		private function onConnected()
		{
			//SaffronLogger.log("connected");
			//TODO: implement function
			myWebService3.eventListen.addEventListener(WebEvent3.NO_CONNECTTION,noInternet) ;
			myWebService3.eventListen.addEventListener(WebEvent3.RESULT,loaded) ;
			myToken = myWebService3.sentParamsToOperation(serviceName,myParam) ;
			//myToken = myServiceFunction.apply(this,myParam)
		}
		
		private function noInternet(e:WebEvent3=null)
		{
			//TODO: implement function
			if(e == null || myToken == e.token)
			{
				cansel();
				connectinError = new WebEvent3(WebEvent3.NO_CONNECTTION) ;
				if(e!=null)
				{
					connectinError.problemHint = e.problemHint ;
					connectinError.connectionProblemCode = e.connectionProblemCode ;
				}
				//#2
				if(offlineDataIsOK)
				{
					//I will save conntectionError to dispatch it if no cashed data will load
					generateDataAndDispatchEvent(null,false);
				}
				else
				{
					//dispatch pure event on global variable to manage error type ↓
						
					this.dispatchEvent(connectinError) ;
					//This should call after local connection error
					globalEventDispatcher.dispatchEvent(connectinError.clone()) ;
						
					dispatchEveryWhere(Event.UNLOAD);
				}
			}
		}
		
		private function loaded(e:WebEvent3)
		{
			//TODO: implement function
			if(myToken == e.token)
			{
				connected = true ;
				cansel();
				generateDataAndDispatchEvent(e.pureData);
			}
		}
		
		/**returns true if the proccess was successfuly complete*/
		private function generateDataAndDispatchEvent(pureData:Array,dispatchConnectionErrorNow:Boolean=true,controllCashDate:Boolean=false):Boolean
		{
			//#3
			if(pureData==null)
			{
				//This was on version 1 of WebServiceSaver 
				//var jsonString:String = WebServiceSaver.load(this,myParam) ;
				/*if(jsonString!=null)
				{
					//null will return on pureData whenever ofline data is requests and it is the first call of it
					pureData = JSON.parse(jsonString) as Array;
				}*/
				var cashingDate:Date ;
				if(controllCashDate)
				{
					cashingDate = offlineDate ;
				}
				pureData = WebServiceSaver3.load(this,myParam,cashingDate) as Array ;
				SaffronLogger.log("try to load cash : ");
				SaffronLogger.log("pure data loaded : "+pureData);
				//From now , if no null receved from services , it will replace pureData with [] array
			}
			else if(offlineDataIsOK && pureData!=null)
			{
				//Versoin 1 of the pureData 
				WebServiceSaver3.save(this,myParam,/*JSON.stringify(*/pureData/*)*/);
			}
			SaffronLogger.log("pureData is null : "+(pureData==null)+'  >>>>>  '+pureData);
			
			if(pureData==null)
			{
				SaffronLogger.log("Close this sevice");
				if(dispatchConnectionErrorNow)
				{
					dispatchEveryWhere(Event.UNLOAD);
					
					//This should call after local connection error ↓
					if(connectinError!=null)
					{
						globalEventDispatcher.dispatchEvent(connectinError.clone()) ;
					}
				}
				else
				{
					SaffronLogger.log("Try to load onlie data");
				}
				return false ;
			}
			
			if(manageData(pureData))
			{
				dispatchEveryWhere(Event.COMPLETE);
			}
			else
			{
				if(this.hasEventListener(ErrorEvent.ERROR))
				{
					this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
				}
				else
				{
					SaffronLogger.log("No error connection listener created");
					dispatchEveryWhere(Event.UNLOAD)
				}
			}
			return true ;
		}
		
		/**Manage your special data here*/
		protected function manageData(pureData:Array):Boolean
		{
			
			/*var cash:Array = WebServiceParser2.pars(pureData,FolderCount);
			data = new Vector.<FolderCount>();
			for(var i = 0 ; i < cash.length ; i++)
			{
			data[i] = cash[i];
			}*/
			return true;
		}
		
		/**Add header*/
		public function addHeader(userName:String, password:String, tocken:String, uid:String):void
		{
			myWebService3.setHeader(userName,password,tocken,uid);
		}
		
		/**Clear header*/
		public function clearHeader():void
		{
			myWebService3.clearHeader();
		}
		
		private function dispatchEveryWhere(eventName:String)
		{
			//TODO: implement function
			this.dispatchEvent(new Event(eventName));
		}
	}
}