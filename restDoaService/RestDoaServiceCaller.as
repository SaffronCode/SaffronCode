package restDoaService
{
	import com.mteamapp.JSONParser;
	import com.mteamapp.StringFunctions;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.utils.Base64Encoder;
	
	import contents.alert.Alert;
	import contents.alert.SaffronLogger;
	
	/**Cannot connect to server*/
	[Event(name="CONNECTION_ERROR", type="restDoaService.RestDoaEvent")]
	/**Server returns error, use Error code or msg list*/
	[Event(name="SERVER_ERROR", type="restDoaService.RestDoaEvent")]
	/**Result returned*/
	[Event(name="SERVER_RESULT", type="restDoaService.RestDoaEvent")]
	/**Result updated - this event uses when you requested for offline datas*/
	[Event(name="SERVER_RESULT_UPDATE", type="restDoaService.RestDoaEvent")]
	/**The web service result was update, no need to change the result*/
	[Event(name="SERVER_WAS_UPDATED", type="restDoaService.RestDoaEvent")]
	/**Result Title value is Error user when one parmas is invalid*/
	[Event(name="TITLE_ERROR", type="restDoaService.RestDoaEvent")]
	/**Dispatch progress event*/
	[Event(name="progress", type="flash.events.ProgressEvent")]
	public class RestDoaServiceCaller extends EventDispatcher 
	{
		/**200:Ok<br>
		 * 404:NotFound<br>
		 * 400:Bad Request<br>
		 * 401:Unautorized<br>
		 * 502:Connection Failed<br>
		 * For read full list, please visit <a href="https://en.wikipedia.org/wiki/List_of_HTTP_status_codes">https://en.wikipedia.org/wiki/List_of_HTTP_status_codes</a>*/
		public var HTTPStatus:int ;
		
		protected var instantOfflineData:Boolean,
					offlineDataIsOK:Boolean,
					lastPureData:String,
					onUpdateProccess:Boolean;
					
		public var isConnected:Boolean = false ;
		
		
		private static var webServiceId:uint = 0 ;
					
		public function get pureData():String
		{
			return lastPureData ;
		}
		
		/**main loader class*/
		private var requestLoader:URLLoader;
		
		/**This is the webservice file on RestService.domain
		private var serviceName:String ;*/
		
		/**This is the request you need to send*/
		protected var pureRequest:URLRequest ;
		
		/**Reload timeOut ID*/
		private var timerId:uint ;
		
		/**This is the last acceptable date for loaded value*/
		private var offlineDate:Date ;
		
		/**This is the value*/
		//private var parser:RestFullJSONParser ;
		
		public var requestedData:Object ;
		
		/**Service id*/
		protected var myId:String,
					myParams:String='';
		
					
		private var isGet:Boolean ;
		private var _isLoading:Boolean;
		private var getRequestedData:Object;
		
		/**Active or deactive web service logs for system*/
		internal static var logger:Boolean = false ;
		
		
		/**Do not pass null value as RequestedData, it will cause an Error!!<br>
		 * Integer or numeric values will loose*/
		public function RestDoaServiceCaller(myWebServiceLocation:String,RequestedData:Object,offlineDataIsOK_v:Boolean=true,instantOfflineData_v:Boolean=false,maximomOfflineData:Date = null,useGetMethod:Boolean=false)
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
			/*if(requestedData == null)
			{
				throw "Dont pass null value as RequestedData";
			}*/
			//serviceName = myWebServiceLocation ;

			if(myWebServiceLocation.indexOf('http')==0)
			{
                pureRequest = new URLRequest(myWebServiceLocation);
			}
			else
			{
				pureRequest = new URLRequest(RestDoaService.domain+myWebServiceLocation);
			}
			
			isGet = useGetMethod;
			if(useGetMethod)
			{
				pureRequest.method = URLRequestMethod.GET;
			}
			else
			{
				pureRequest.method = URLRequestMethod.POST;
				pureRequest.contentType = 'application/json';
			}
			
			updateHeaders();
			
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
			requestLoader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,serverHeaderReceived);
			requestLoader.addEventListener(IOErrorEvent.IO_ERROR,noInternet);
			requestLoader.addEventListener(ProgressEvent.PROGRESS,dispatchProgress);
		}
		
		private function serverHeaderReceived(e:HTTPStatusEvent):void
		{
			trace("******** ***  *** * ** HTTP headers received : "+e.status);
			HTTPStatus = e.status ;
			RestDoaService.eventDispatcher.dispatchEvent(e.clone());
			if(logger)
			SaffronLogger.log("RESPOND\nRestService ID:"+webServiceId+"\nHTTP Status"+e.status);
		}
		
		/**Update full headers*/
		private function updateHeaders():void
		{
			pureRequest.requestHeaders = [] ;
			addHeader();
			
			for(var i = 0 ; i<RestDoaService.headers.length ; i++)
			{
				pureRequest.requestHeaders.push(RestDoaService.headers[i]);
			}
		}
			protected function addHeader():void
			{
				var newHeader:URLRequestHeader = new URLRequestHeader('Accept','text/json,text/xml, application/xml, application/xhtml+xml, text/html;q=0.9, text/plain;q=0.8, text/css, image/png, image/jpeg, image/gif;q=0.8, application/x-shockwave-flash, video/mp4;q=0.9, flv-application/octet-stream;q=0.8, video/x-flv;q=0.7, audio/mp4, application/futuresplash, */*;q=0.5, application/x-mpegURL');
				pureRequest.requestHeaders.push(newHeader);
			}
		/**Set the offline data only status to false to prevent returning offline data or to true to make it return offline data first*/
		public function offileDataOnly(status:Boolean):void
		{
			instantOfflineData = status ;
		}
		
		/**Dispatch proggress event*/
		protected function dispatchProgress(event:ProgressEvent):void
		{
			trace("--Rest doa service progress--",event.bytesLoaded,event.bytesTotal+' > '+myId);
			this.dispatch(new ProgressEvent(ProgressEvent.PROGRESS,false,false,event.bytesLoaded,event.bytesTotal));
		}
		
		/**Returns true if loading is in progress*/
		public function get isLoading():Boolean
		{
			return _isLoading ;
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
			if(logger)
			SaffronLogger.log("CONNECTION PROBLEM\nRestService ID:"+webServiceId);
			RestDoaService.isOnline = false ;
			_isLoading = false ;
			HTTPStatus = 502 ;
			trace("No internet connection : "+HTTPStatus);
			if(controllData && offlineDataIsOK)
			{
				var savedData:* = RestServiceSaver.load(myId,myParams,pureRequest.requestHeaders);
				if(savedData != null)
				{
					trace("Saved data is not null");
					if(RestDoaService.debug_show_results)
					{
						trace("* cashed data for "+myId+" : "+savedData);
					}
					parsLoadedData(savedData,true,true);
					return ;
				}
			}
			//this.dispatchEvent(new RestEvent(RestEvent.CONNECTION_ERROR));
			//RestService.eventDispatcher.dispatchEvent(new RestEvent(RestEvent.CONNECTION_ERROR,null,ErrorEnum.ConnectionError));
			
			if(controllData && requestLoader.data!=null && requestLoader.data!='' && HTTPStatus!=502 && HTTPStatus!=500)
			{
				_isLoading = false ;
				isConnected = true ;
				/*Alert.show("noInternet");
				for each(var i in requestLoader)
				{
					Alert.show(i+" : "+requestLoader[i]);
				}*/
				parsLoadedData(requestLoader.data,true)
			}
			else
			{
				dispatch(new RestDoaEvent(RestDoaEvent.CONNECTION_ERROR,HTTPStatus,isConnected,getRequestedData,requestedData));
			}
			/*try
			{
				var chekTitleError:Object = JSON.parse(requestLoader.data)
			}
			catch(e)
			{
				dispatch(new RestDoaEvent(RestDoaEvent.CONNECTION_ERROR,ErrorEnum.ConnectionError));
				return
			}
			if(chekTitleError.Name==null)
			{
				dispatch(new RestDoaEvent(RestDoaEvent.TITLE_ERROR,ErrorEnum.TitleError))
			}
			else
			{
				dispatch(new RestDoaEvent(RestDoaEvent.CONNECTION_ERROR,ErrorEnum.ConnectionError));
			}*/

			
		}
		
		private function requestLoaded(event:Event):void
		{
			if(logger)
			SaffronLogger.log("RESPOND\nRestService ID:"+webServiceId+"\n"+requestLoader.data);
			RestDoaService.isOnline = true ;
			_isLoading = false ;
			isConnected = true ;
			//parser = new JSONParser();
			if(RestDoaService.debug_show_results)
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
			//Alert.show("requestLoaded : "+JSON.stringify(pureRequest));
			if(HTTPStatus==502 || HTTPStatus==500/* && requestLoader.data==''*/)
			{
				noInternet();
			}
			else
			{
				parsLoadedData(requestLoader.data);
			}
		}
		
		protected function parsLoadedData(loadedData:*,alreadyLoadedFromCash:Boolean=false,ignoreHTTPStatus:Boolean=false):void
		{
			var serverErrorBool:Boolean = false ;
			var pureRecevedData:String = String(loadedData);
			trace("Receved data is : "+((pureRecevedData.length<1000)?pureRecevedData:"[larg file : "+pureRecevedData.length+"]"));
			var correctedLoadedData:String = pureRecevedData;//pureRecevedData.substring(1,pureRecevedData.length-1).split('\\"').join('\"').split("\\\\u003cbr\\\\u003e").join('\\n').split("<br>").join('\\n');
			//correctedLoadedData = StringFunctions.clearDoubleQuartmarksOnJSON(correctedLoadedData);
			//trace("Corrected data is : "+correctedLoadedData);
			if((ignoreHTTPStatus || (HTTPStatus!=502 && HTTPStatus!=500)) && requestedData!=null && pureRecevedData!='')
			{
				if(loadedData is String)
				{
					if(RestDoaService.serverErrorModels.indexOf(loadedData)!=-1)
					{
						serverErrorBool = true ;
					}
					else
					{
						try
						{
							JSONParser.parse(correctedLoadedData,requestedData);
						}
						catch(e)
						{
							if(pureRecevedData.toLowerCase() != 'true')
							{
								serverErrorBool = true ;
								trace("Data format error");
							}
		
						}
					}
				}
				else if(loadedData is ByteArray && requestedData is ByteArray)
				{
					try
					{
						(requestedData as ByteArray).writeBytes(loadedData as ByteArray);
					}catch(e){};
				}
				else
				{
					trace("I Cannot receive any other types");
					serverErrorBool = true ;
				}
			}
			else if(alreadyLoadedFromCash==false && (HTTPStatus==502 || HTTPStatus==500))
			{
				dispatch(new RestDoaEvent(RestDoaEvent.CONNECTION_ERROR,HTTPStatus,isConnected,getRequestedData,requestedData));
				return;
			}
			//the receved data is not converted correctly
			//parser = new RestFullJSONParser(loadedData,requestedData);
			var oldPureData:String = lastPureData ;
			lastPureData = loadedData ;
			
			
			if(serverErrorBool)
			{
				trace("Server problem");
				//if(this.hasEventListener(RestEvent.SERVER_ERROR))
				var serverError:RestDoaEvent = new RestDoaEvent(RestDoaEvent.SERVER_ERROR,HTTPStatus,isConnected,getRequestedData,requestedData) ;
				if(hasErrorListenerAndDispatchOnglobal(serverError))
				{	
					//this.dispatchEvent(new RestEvent(RestEvent.SERVER_ERROR,parser.msgs));
					//RestService.eventDispatcher.dispatchEvent(new RestEvent(RestEvent.SERVER_ERROR,parser.msgs,parser.exceptionType));
					//Update last puredata befor dispatching event
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
					RestServiceSaver.save(myId,myParams,loadedData,pureRequest.requestHeaders);
				}
				trace("Data is ready to use");
				if(onUpdateProccess)
				{
					if(oldPureData!=loadedData)
					{
						trace("* This update is new");
						//I have to upste lastPureData befor dispatching the event
						if(this.hasEventListener(RestDoaEvent.SERVER_RESULT_UPDATE))
						{
							dispatch(new RestDoaEvent(RestDoaEvent.SERVER_RESULT_UPDATE,HTTPStatus,isConnected,getRequestedData,requestedData));
						}
						else
						{
							dispatch(new RestDoaEvent(RestDoaEvent.SERVER_RESULT,HTTPStatus,isConnected,getRequestedData,requestedData))
						}
						//this.dispatchEvent(new RestEvent(RestEvent.SERVER_RESULT_UPDATE));
					}
					else
					{
						trace("* Nothing change on this update");
						dispatch(new RestDoaEvent(RestDoaEvent.SERVER_WAS_UPDATED,HTTPStatus,isConnected,getRequestedData,requestedData));
					}
				}
				else
				{
					//this.dispatchEvent(new RestEvent(RestEvent.SERVER_RESULT));
					//I have to upste lastPureData befor dispatching the event
					trace("Result event dispatching");
					dispatch(new RestDoaEvent(RestDoaEvent.SERVER_RESULT,HTTPStatus,isConnected,getRequestedData,requestedData))
				}
			}
		}
		
		/**Values are not case sencitive*/
		protected function loadParam(obj:Object=null,isDataForm:Boolean=false):void
		{
			HTTPStatus = 0 ;
			cansel();
			updateHeaders();
			isConnected = false ;
			onUpdateProccess = false ;
			if(obj!=null)
			{
				if(isDataForm)
				{
					requestLoader.dataFormat = URLLoaderDataFormat.BINARY ;
					var urlParam:ByteArray = new ByteArray();
					var boundryKey:String = StringFunctions.randomString(34);//"WebKitFormBoundaryWYIDHkbUgs0p7KUx"
					for(var objVars:String in obj)
					{
						urlParam.writeUTFBytes("------"+boundryKey+"\n");
						urlParam.writeUTFBytes("Content-Disposition: form-data; name=\""+objVars+"\"; " );
						if(obj[objVars] is ByteArray)
						{
							urlParam.writeUTFBytes("Content-Type: image/png; filename=\""+objVars+".png\";\n\n" );
							var byte:ByteArray = obj[objVars] as ByteArray ;
							byte.position = 0 ;
							urlParam.writeBytes(byte);
							urlParam.writeUTFBytes("\n");
						}
						else
						{
							urlParam.writeUTFBytes("\n\n"+obj[objVars]+"\n");
						}
					}
					urlParam.writeUTFBytes("------"+boundryKey+"--");
					pureRequest.contentType = 'multipart/form-data ; boundary=----'+boundryKey;
					pureRequest.data = urlParam;
				}
				else
				{
					getRequestedData = obj;
					var urlVars:URLVariables;
					//trace("Send this data : "+JSON.stringify(myParams,null,'\t'));
					if(isGet)
					{
						myParams = JSONParser.stringify(obj) ;
						var readableObject:Object = Obj.createReadAbleObject(obj);// .myParams ;
						urlVars = new URLVariables();

						for(var i in readableObject)
						{
							urlVars[i] = readableObject[i] ;//a1=123&a2=32   ||   CaseTbl=(a1=123&a2=32)
						}
						pureRequest.data = urlVars;
					}
					else
					{
						//Create post method
						//throw "Create post method";
						if(obj is ByteArray)
						{
							pureRequest.contentType = 'multipart/form-data';
							pureRequest.data = obj ;
						}
						else if(obj is String)
						{
							pureRequest.data = obj
						}
						else
						{
							myParams = RestFullJSONParser.stringify(obj) ;
							pureRequest.data = myParams
						}

						//trace('myParams :',myParams)
						//	trace('parse :',JSON.parse(myParams))


						//	var str:String = '{"KindRoof":15,"KindCabinet":27,"Loby":false,"Masahat":0,"Mobile":"","EmailAddress":"","Metraj":0,"Camera":false,"Nama":81,"Negahban":false,"Parking":false,"Pasio":false,"Pele":false,"Pic":["/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/2wBDAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/wAARCAMABAADASIAAhEBAxEB/"],"Pool":false,"Price1":0,"Age":"0","Price2":0,"Anten":false,"Sarmayesh":87,"Shomineh":false,"CaseSide":87,"Shooting":false,"Comment":"","Sona":false,"Confine":"","Storage":false,"CountBed":0,"Takhlie":false,"CountFloor":0,"Tel":false,"CountPoint":true,"TelUser":"","CountUnit":0,"Unit":"","Door":false,"Windows":35,"Family":"","kindService":87,"Elevator":false,"Lat":35.7137859,"Fire":false,"Lon":51.4148809,"Floor":"0","Furned":false,"Garmayesh":87,"Gas":false,"IPhone":false,"IdAgency":0,"IdArea":1,"IdCity":1,"IdKindCase":-1,"IdKindRequest":1,"IdRange":1,"IdState":1,"IdUsers":0,"Point":true,"KindKitchen":21}'
						//pureRequest.data  = str

					}
				}

			}
			trace("instantOfflineData : "+instantOfflineData);
			if(instantOfflineData)
			{
				var savedData:* = RestServiceSaver.load(myId,myParams,pureRequest.requestHeaders) ;
				if(savedData != null)
				{
					var expired:Boolean = offlineDate.time>RestServiceSaver.lastCashDate;//RestServiceSaver.isExpired(myId,myParams,offlineDate);
					if(RestDoaService.debug_show_results)
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
			webServiceId++ ;
			if(logger)
			{
				var dataForLog:String = '' ;
				if(pureRequest.data is ByteArray)
				{
					dataForLog = "[Byte ("+(pureRequest.data as ByteArray).length+")]"
				}
				else
				{
					dataForLog = String(pureRequest.data);
				}
				SaffronLogger.log("CALL\nRestService ID:"+webServiceId+"\n"+(isGet?"GET ":"POST ")+(pureRequest!=null?pureRequest.url:"")+"\n"+(pureRequest!=null && pureRequest.data!=null?pureRequest.data.toString():''));
			}
			//debug line
			//navigateToURL(pureRequest);
				_isLoading = true ;
				requestLoader.load(pureRequest);
				//noInternet();
		}
		
		public function reLoad(delay:uint=20000,dontReturnOfflineData:Boolean=false):void
		{
			cansel();
			offlineDate = new Date() ;
			offlineDataIsOK = !dontReturnOfflineData ;
			instantOfflineData = false ;
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
				RestDoaService.eventDispatcher.dispatchEvent(event);
				return false ;
			}
		}
		
		private function dispatch(event:Event):void
		{
			this.dispatchEvent(event.clone());
			RestDoaService.eventDispatcher.dispatchEvent(event);
		}
		
	}
}