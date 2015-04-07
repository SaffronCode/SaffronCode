package webService.webCallers
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.soap.Operation;
	
	import webService.WebEvent;
	import webService.WebServiceSaver;
	import webService.myWebService;
	
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="unload", type="flash.events.Event")]
	
	public class WebServiceCaller extends EventDispatcher
	{
		public var connected:Boolean = false ;
		
		private var myToken:AsyncToken;
		
		private var myParam:Array ;
		
		//public var data:Vector.<GetPhotos>;
		
		//#0
		private var justLoadOffline:Boolean,
					offlineDataIsOK:Boolean;
					
		//private var myServiceFunction:Function ;
					
		private var myOperation:Operation ;
		
		private var myServiceName:String ;
		
		private var offlineDate:Date,
					loadAgainJustForDoubleControll:Boolean = false,
					doNotDispatchEventsAgain:Boolean = false;
		
		public function WebServiceCaller(myWebServiceName:String,offlineDataIsOK_v:Boolean=true,justLoadOfline_v:Boolean=false,maximomOfflineData:Date = null)
		{
			//TODO: implement function
			//#4
			offlineDate = maximomOfflineData ;
			
			myServiceName = myWebServiceName ;
			myWebService.activateOperation(myWebServiceName);
			offlineDataIsOK = offlineDataIsOK_v ;
			justLoadOffline = justLoadOfline_v ;
			super();
		}
		
		/**Create load function on extended class to call this function with its own parameters*/
		protected function loadParams(...params):void
		{
			cansel();
			//You have permition to dispatch events now.
			doNotDispatchEventsAgain = false ;
			myParam = params ;
			//#1
			if(justLoadOffline)
			{
				var cashedData:String = WebServiceSaver.load(this,myParam);
				if(offlineDate!=null && cashedData!=null)
				{
					loadAgainJustForDoubleControll = WebServiceSaver.isExpired(this,myParam,offlineDate)
				}
				
				if(cashedData != null)
				{
					generateDataAndDispatchEvent(cashedData);
					doNotDispatchEventsAgain = true ;
					if(loadAgainJustForDoubleControll)
					{
	 					myWebService.Connect(onConnected,noInternet);	
					}
				}
				else
				{
 					myWebService.Connect(onConnected,noInternet);	
				}
			}
			else
			{
				myWebService.Connect(onConnected,noInternet);
			}
		}
		
		public function cansel()
		{
			//TODO: implement function
			myWebService.eventListen.removeEventListener(WebEvent.EVENT_DISCONNECTED,noInternet);
			myWebService.eventListen.removeEventListener(WebEvent.Result,loaded);
			myWebService.Disconnect(onConnected,noInternet);
			myWebService.CanselThisToken(myToken);
		}
		
		private function onConnected()
		{
			trace("connected");
			//TODO: implement function
			myWebService.eventListen.addEventListener(WebEvent.EVENT_DISCONNECTED,noInternet);
			myWebService.eventListen.addEventListener(WebEvent.Result,loaded);
			
			myToken = myWebService.callFunction(myServiceName,myParam)
		}
		
		private function noInternet(e:WebEvent=null)
		{
			//TODO: implement function
			if(e == null || myToken == e.token)
			{
				cansel();
				
				//#2
				if(offlineDataIsOK)
				{
					generateDataAndDispatchEvent(null);
				}
				else
				{
					dispatchEveryWhere(Event.UNLOAD);
				}
			}
		}
		
		private function loaded(e:WebEvent)
		{
			//TODO: implement function
			if(myToken == e.token)
			{
				connected = true ;
				cansel();
				generateDataAndDispatchEvent(e.pureData);
			}
		}
		
		private function generateDataAndDispatchEvent(pureData:String):void
		{
			//#3
			if(pureData==null)
			{
				pureData = WebServiceSaver.load(this,myParam);
				trace('cash loads : '+pureData);
			}
			else if(offlineDataIsOK && pureData!=null)
			{
				WebServiceSaver.save(this,myParam,pureData);
			}
			if(pureData==null)
			{
				dispatchEveryWhere(Event.UNLOAD);
				return ;
			}
			
			//you can even controll the data value from overrided function
			var parsedSituation:Boolean = manageData(pureData);
			
			if(parsedSituation)
			{
				dispatchEveryWhere(Event.COMPLETE);
			}
			else
			{
				dispatchEveryWhere(Event.UNLOAD);
			}
		}
		
		/**Manage your special data here*/
		protected function manageData(pureData:String):Boolean
		{
			// TODO Auto Generated method stub
			
			//TODO: implement function
			//1- For first type of values
			//	data = Constants.checkWebServiceBoolean(pureData);
			//2- For secend type of values
			/*data = new Vector.<GetPhotos>();
			var cahsedData:Array = WebServiceParser.pars(pureData,GetPhotos);
			for(var i = 0 ; i<cahsedData.length ; i++)
			{
				data.push(cahsedData[i]);
			}*/
			return true ;
		}
		
		private function dispatchEveryWhere(eventName:String)
		{
			//TODO: implement function
			if(!doNotDispatchEventsAgain)
			{
				this.dispatchEvent(new Event(eventName));
			}
			else
			{
				trace("I cannot dispatch my events any more : "+eventName);
			}
		}
	}
}