package webService
{
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.rpc.AbstractOperation;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.LoadEvent;
	import mx.rpc.soap.WebService;
	
	
	
	
	
	public class myWebService
	{
		//private static const GAMEID:String = "Console";
		
		public static var DEBUG_DONOT_CONNECT:Boolean = false ;
		
		/**these variables are the variables that will help to send requests after ws is connects*/
		private static var operetionsList:Vector.<AbstractOperation>,
							operationsVariables:Vector.<Array>;
		
		public static var eventListen:WebEventDispatcher = new WebEventDispatcher();
		
		/**Two new list to manage list of functions that have to call after each event acts*/
		public static var 	onConnectFunctionList:Vector.<Function> = new Vector.<Function>(),
							onDisconnectedFunctionList:Vector.<Function> = new Vector.<Function>();
		
		//public static const webServiceWsdl:String = "192.168.0.130:85/STBWebServices.asmx?wsdl";
		public static var webServiceWsdl:String = Constants.appDomain+Constants.asmxurl;
		
		private static var 	ws:WebService,
							retryer:Timer,
							
							isitConnected:Boolean=false,
								
							newsID:uint,
							recevedNewsID:uint;;
							
		public static var	retrys:uint=2,
							connectiontimeOut:Number=6000;
							
							
		//private static var myHeader:String="myHeader";
						
		private static var activatedOperations:Array ;
		
		public static function setUp()
		{
			//myStage = MyStage ;
			
			if(operetionsList == null)
			{
				operetionsList = new Vector.<AbstractOperation>();
				operationsVariables = new Vector.<Array>();
			}
			
			newsID = 0 ;
			recevedNewsID = 0 ;
			
			isitConnected = false;
			ws = new WebService();
			activatedOperations = [] ;
			
			
			ws.addEventListener(LoadEvent.LOAD,webServiceReady);
			
			retryer = new Timer(connectiontimeOut,retrys);
			retryer.addEventListener(TimerEvent.TIMER,tryAgain);
			retryer.addEventListener(TimerEvent.TIMER_COMPLETE,connectionFails);
		}
		
		
		public static function activateOperation(operationName:String):void
		{
			if(activatedOperations.indexOf(operationName) == -1)
			{
				trace('activate operation');
				ws[operationName].resultFormat = "e4x" ;
				ws[operationName].addEventListener("result", Result) ;
				ws[operationName].addEventListener("fault", serviceNotFound) ;
				activatedOperations.push(operationName)
			}
		}
		
		
		
		/**this function start trying to connect to the web service*/
		public static function tryToConnect()
		{
			if(!isitConnected)
			{
				retryer.stop();
				retryer.reset();
				retryer.start();
				tryAgain();
			}
			else
			{
				eventListen.dispatchEvent(new WebEvent(WebEvent.EVENT_CONNECTED));
			}
		}
		
		/**new function to make easier to check internet connection with less addEventListeners<br>
		 * callDisconnect whenever you needs to cansel the checking*/
		public static function Connect(onConnected:Function,onDisconnected:Function)
		{
			if(isitConnected)
			{
				onConnected();
			}
			else
			{
				onConnectFunctionList.push(onConnected);
				onDisconnectedFunctionList.push(onDisconnected);
				myWebService.tryToConnect();
			}
		}
		
		/**Cansel these listeners from listenning to webservice connection from Connect function*/
		public static function Disconnect(onConnected:Object, noInternet:Object):void
		{
			// TODO Auto Generated method stub
			var I:int = onConnectFunctionList.indexOf(onConnected);
			if(I!=-1)
			{
				onConnectFunctionList.splice(I,1);
			}
			
			I = onDisconnectedFunctionList.indexOf(onDisconnectedFunctionList);
			if(I!=-1)
			{
				onDisconnectedFunctionList.splice(I,1);
			}
		}
		
		/**dispathch event to stage
		private static function dispathcer(event:String,Status:Boolean=true,xmlListData:XMLList=null,XMLIem:XML=null,ObjectItem:Object=null,pureString:String='')
		{
			
		}*/
		
		/**try to connect to web service again*/
		private static function tryAgain(e=null)
		{
			if(!isitConnected)
			{
				trace('try to connect : '+webServiceWsdl);
				if(DEBUG_DONOT_CONNECT)
				{
					ws.loadWSDL("no where");
				}
				else
				{
					//trace('send webServiceWsdl');
					ws.loadWSDL(webServiceWsdl);
				}
			}
		}
		
		/**stop trying*/
		private static function connectionFails(e=null)
		{
			if(!isitConnected)
			{
				trace('connection failds');
				for(var i = 0 ; i<onDisconnectedFunctionList.length ; i++)
				{
					onDisconnectedFunctionList[i]();
				}
				onDisconnectedFunctionList = new Vector.<Function>();
				
				eventListen.dispatchEvent(new WebEvent(WebEvent.EVENT_DISCONNECTED));
			}
		}
		
		/**web service is ready to use*/
		private static function webServiceReady(e)
		{
			trace('web service is ready to use');
			if(isitConnected==false)
			{
				isitConnected = true ;
				eventListen.dispatchEvent(new WebEvent(WebEvent.EVENT_CONNECTED)) ;
				callAllOperations() ;
				
				for(var i = 0 ; i<onConnectFunctionList.length ; i++)
				{
					onConnectFunctionList[i]();
				}
				onConnectFunctionList = new Vector.<Function>();
				onDisconnectedFunctionList = new Vector.<Function>();
			}
		}
		
		private static function callAllOperations():void
		{
			// TODO Auto Generated method stub
			for(var i = 0 ; i<operetionsList.length ; i++)
			{
				operetionsList[i].send.apply(operationsVariables[i]);
			}
			operetionsList = new Vector.<AbstractOperation>();
			operationsVariables = new Vector.<Array>();
		}		
		
		/**any connection failds*/
		private static function serviceNotFound(e:*=null)
		{
			trace('faild : '+e);
			//i dispatch event instant;ly
			var myTocken:AsyncToken ;
			if(e is FaultEvent)
			{
				myTocken = FaultEvent(e).token ;
			}
			eventListen.dispatchEvent(new WebEvent(WebEvent.EVENT_DISCONNECTED,'',myTocken));
		}

		
		
		
		/**Global resutl*/
		private static function Result(ev:ResultEvent)
		{
			var result:String = pureData(ev.result);
			trace('Result : '+result);
			eventListen.dispatchEvent(new WebEvent(WebEvent.Result,result.toString(),ev.token));
		}
		
		
		public static function callFunction(serviceName:String,params:Array):AsyncToken
		{
			trace(serviceName+" : "+params);
			var op:AbstractOperation = ws.getOperation(serviceName);
			op.arguments = params;
			return op.send()
		}
		
		
		
///////////////////////////////////////////////////////TOOLS	↓
		
		
		
		/**cansel this operation with this token*/
		public static function CanselThisToken(token:AsyncToken)
		{
			//var operation:AbstractOperation = ws.getOperation("GetContentListTotals");
			if(token == null)
			{
				return ;
			}
			
			for each(var i in ws.operations)
			{
				i.cancel(token.message.messageId);
			}
		}
		
		
		
		
		/**returns pure data of receved xml*/
		public static function pureData(putputXML:*):String
		{
			var xmldData:XML = XML(String(putputXML));
			return String(xmldData.*/*[0].*[0].*[0]*/);
		}
		
		
		
		
		/**returns time stamp to check if current news is up to date or not*/
		private static function timeStamp():String
		{
			var date:Date = new Date();
			var str:String = date.fullYear+':'+date.month+':'+date.day+':'+date.hours+':'+date.minutes;
			/*if(LEGO.debug)
			{
			//it will prevent to check time stamp of the news
			str+=String(Math.random());
			}*/
			return str ;
		}
		
		
		
		/**remove unused meta tags from xml*/
		private static function clearXML(str:String):XML
		{
			var i:int = str.indexOf('<');
			i = str.indexOf(' ',i);
			var j:int = str.indexOf('>',i);
			if(!str.indexOf('>')<i)
			{
				str = str.substring(0,i)+str.substring(j);
			}
			
			return XML(str);
		}
		
		
		
	}
}