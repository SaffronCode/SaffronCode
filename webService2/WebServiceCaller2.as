package webService2
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
	
	public class WebServiceCaller2 extends EventDispatcher
	{
		/**Global event dispatcher*/
		public static var globalEventDispatcher:WebServiceCaller2 = new WebServiceCaller2(null);
		
		
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

		private var connectinError:WebEvent2;
		
		
		private var offlineDataDispatchedOnce:Boolean=false;
		
		
		
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
				offlineDate.minutes-=uint(Contents.config.max_available_service_data);
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
		
		
		public function WebServiceCaller2(webServiceName:String,offlineDataIsOK_v:Boolean=true,justLoadOfline_v:Boolean=false,maximomOfflineData:Date=null)
		{
			//TODO: implement function
			//#4
			//myServiceFunction = myWebService ;
			//New line ↓
				/*if(justLoadOfline_v && maximomOfflineData == null)
				{
					maximomOfflineData = new Date();
					maximomOfflineData.minutes-= uint(Contents.config.max_available_service_data);
				}
				offlineDate = maximomOfflineData ;*/
			myWebService2.setOperation(webServiceName);
			
			serviceName = webServiceName ;
			offlineDataIsOK = offlineDataIsOK_v ;
			_justLoadOffline = justLoadOfline_v ;
			super();
		}
		
		protected function loadParams(...params):void
		{
			trace(serviceName+' - offlineDataIsOK:'+offlineDataIsOK+' _justLoadOffline:'+_justLoadOffline);
			connectinError = null ;
			offlineDataDispatchedOnce = false ;
			myParam = params ;
			//#1
			reLoadLastRequest();
		}
		
		/**I created this function to make reload available*/
		private function reLoadLastRequest()
		{
			var needReload:Boolean ;
			if(_justLoadOffline)
			{
				//Cashed data sent to user class on generateDataAndDispatchEvent function
				needReload = generateDataAndDispatchEvent(null,false,true);
			}
			if(needReload || offlineDate==null)
			{
				//If no oflinte data requests or no oflinte data avaiable
				myWebService2.Connect(onConnected,noInternet);
			}
		}
		
		
		/**Make this service reloads again<br>
		 * After few tests, I noticed that the 10 second delay is not enaugh
		 * <br>
		 * This is on beta testing yet*/
		public function reLoad(delay:uint=20000):void
		{
			//I prefer to dont cancel the current webservice
			//cancel();
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
		
		public function cancel()
		{
			cansel();
		}
		public function cansel()
		{
			clearTimeout(timerId);
			//TODO: implement function
			myWebService2.eventListen.removeEventListener(WebEvent2.NO_CONNECTTION,noInternet);
			myWebService2.eventListen.removeEventListener(WebEvent2.RESULT,loaded);
			myWebService2.Disconnect(onConnected,noInternet);
			myWebService2.CancelThisToken(myToken);
		}
		
		private function onConnected()
		{
			//trace("connected");
			//TODO: implement function
			myWebService2.eventListen.addEventListener(WebEvent2.NO_CONNECTTION,noInternet) ;
			myWebService2.eventListen.addEventListener(WebEvent2.RESULT,loaded) ;
			myToken = myWebService2.sentParamsToOperation(serviceName,myParam) ;
			//myToken = myServiceFunction.apply(this,myParam)
		}
		
		private function noInternet(e:WebEvent2=null)
		{
			//TODO: implement function
			if(e == null || myToken == e.token)
			{
				cancel();
				connectinError = new WebEvent2(WebEvent2.NO_CONNECTTION) ;
				if(e!=null)
				{
					connectinError.problemHint = e.problemHint ;
					connectinError.connectionProblemCode = e.connectionProblemCode ;
				}
				//#2
				if(offlineDataIsOK)
				{
					//I will save conntectionError to dispatch it if no cashed data will load
					if(!offlineDataDispatchedOnce)
					{
						generateDataAndDispatchEvent(null,false);
					}
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
		
		private function loaded(e:WebEvent2)
		{
			//TODO: implement function
			if(myToken == e.token)
			{
				connected = true ;
				cancel();
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
				pureData = WebServiceSaver2.load(this,myParam,cashingDate) as Array ;
				trace("try to load cash : ");
				trace("pure data loaded : "+pureData);
				//From now , if no null receved from services , it will replace pureData with [] array
			}
			else if(offlineDataIsOK && pureData!=null)
			{
				//Versoin 1 of the pureData 
				WebServiceSaver2.save(this,myParam,/*JSON.stringify(*/pureData/*)*/);
			}
			trace("pureData is null : "+(pureData==null)+'  >>>>>  '+pureData);
			
			if(pureData==null)
			{
				trace("Close this sevice");
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
					trace("Try to load onlie data");
				}
				return false ;
			}
			
			if(manageData(pureData))
			{
				offlineDataDispatchedOnce = true ;
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
					trace("No error connection listener created");
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
			myWebService2.setHeader(userName,password,tocken,uid);
		}
		
		/**Clear header*/
		public function clearHeader():void
		{
			myWebService2.clearHeader();
		}
		
		private function dispatchEveryWhere(eventName:String)
		{
			//TODO: implement function
			this.dispatchEvent(new Event(eventName));
		}
	}
}