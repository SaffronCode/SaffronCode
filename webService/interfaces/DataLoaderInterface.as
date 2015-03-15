package webService.interfaces
{
	import flash.events.Event;
	import mx.rpc.AsyncToken;
	
	import webService.WebEvent;
	import webService.myWebService;
	
	import webService.WebServiceSaver;

	[Event(name="complete", type="flash.events.Event")]
	[Event(name="unload", type="flash.events.Event")]
	
	public interface DataLoaderInterface
	{
		function load(...params):void
		
		/**myWebService.eventListen.removeEventListener(WebEvent.EVENT_DISCONNECTED,noInternet);
			myWebService.eventListen.removeEventListener(WebEvent.Result,loaded);
			myWebService.Disconnect(onConnected,noInternet);
			myWebService.CanselThisToken(myToken);*/
		function cansel();
		/*{
		myWebService.eventListen.removeEventListener(WebEvent.EVENT_DISCONNECTED,noInternet);
		myWebService.eventListen.removeEventListener(WebEvent.GetUsersProfileResult,loaded);
		myWebService.Disconnect(onConnected,noInternet);
		myWebService.CanselThisToken(myToken);
		}*/
		
		/**Start to download erjaat*/
		//I remove this function from interface , because it prevents dataLoaders to get their own inputs on this function.
		//I can not take parameters from initialize function , because some time one data loader can load difrent type of dats
		/*function load(...param=null);
		{
		//connect to web services
		myWebService.Connect(onConnected,noInternet);
		}*/
		
		/**myWebService.eventListen.addEventListener(WebEvent.EVENT_DISCONNECTED,noInternet);
			myWebService.eventListen.addEventListener(WebEvent.Result,loaded);
			
			myToken = myWebService.GetMeetings(partiID,locatinID,fromDate,toDate,'','0','',pageSize);*/
		function onConnected();
		
		/**if(e == null || myToken == e.token)
			{
				cansel();
				dispatchEveryWhere(Event.UNLOAD);
				
				if(ofileDatasAreOK)
				{
					var cash:String = SavedDatas2.load(sotageID) ;
					if(cash!=null)
					{
						generateDataAndDispatchEvent(cash);
					}
				}
			}*/
		function noInternet(e:WebEvent=null);
		
		/**if(myToken == e.token)
			{
				SavedDatas2.save(sotageID,e.pureData);
				cansel();
				generateDataAndDispatchEvent(e.pureData);
			}*/
		function loaded(e:WebEvent);
		
		/**data = new Vector.<GetMeetings>();
			var cahsedData:Array = WebServiceParser.pars(pureData,GetMeetings);
			for(var i = 0 ; i<cahsedData.length ; i++)
			{
				data.push(cahsedData[i]);
			}
			dispatchEveryWhere(Event.COMPLETE);*/
		function generateDataAndDispatchEvent(pureData:String):void
			
		/**this.dispatchEvent(new Event(eventName));*/
		function dispatchEveryWhere(eventName:String);
	}
}