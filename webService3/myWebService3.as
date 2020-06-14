package webService3
{
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AbstractOperation;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.*;
	import mx.rpc.soap.*;
	import mx.utils.ObjectProxy;
	
	//import webService.types.LetterReceiverModel;
	
	
	
	
	
	public class myWebService3
	{
		
		//private static const GAMEID:String = "Console";
		public static var IP:String;
		public static var DEBUG_DONOT_CONNECT:Boolean = false ;
		
		/**these variables are the variables that will help to send requests after ws is connects*/
		/*private static var operetionsList:Vector.<AbstractOperation>,
							operationsVariables:Vector.<Array>;*/
		
		public static var eventListen:WebEventDispatcher3 = new WebEventDispatcher3();
		
		/**Two new list to manage list of functions that have to call after each event acts*/
		public static var 	onConnectFunctionList:Vector.<Function> = new Vector.<Function>(),
							onDisconnectedFunctionList:Vector.<Function> = new Vector.<Function>();
		
		public static var webServiceWsdl:String = '' ;
		//public static const webServiceWsdl:String = "http://188.126.146.37:820/Services/MobileAppService.svc?wsdl";
		
		private static var 	ws:WebService = new WebService(),
							retryer:Timer,
							
							isitConnected:Boolean=false,
								
							newsID:uint,
							recevedNewsID:uint;;
							
		public static var	retrys:uint=5,
							connectiontimeOut:Number=1000;
		
						
		private static var setOperations:Array = [] ;
		
		public static function setUp(Ip_p:String='',Wsdl_p:String='')
		{
			//myStage = MyStage ;
			
			/*if(operetionsList == null)
			{
				operetionsList = new Vector.<AbstractOperation>();
				operationsVariables = new Vector.<Array>();
			}*/
			
			/*if(setOperations == null)
			{
				setOperations = [] ;
			}*/
			
			IP = Ip_p
			webServiceWsdl = Ip_p+Wsdl_p

			
			
			newsID = 0 ;
			recevedNewsID = 0 ;
			
			isitConnected = false;
			//Move to initialize place to initializeing befor application starts
			//ws = new WebService();
			
			
			
			
			//ws.SignIn.resultFormat = "e4x";
			/*ws.SignIn.addEventListener("result", Result);
			ws.SignIn.addEventListener("fault", serviceNotFound);*/
			
			//ws.GetUserEmployeePosition.resultFormat = "e4x";
			ws.GetUserEmployeePosition.addEventListener("result", Result);
			ws.GetUserEmployeePosition.addEventListener("fault", serviceNotFound);
			
			ws.SignOut.addEventListener("result", Result);
			ws.SignOut.addEventListener("fault", serviceNotFound);
			
			ws.GetEmployeePositionFolder.addEventListener("result", Result);
			ws.GetEmployeePositionFolder.addEventListener("fault", serviceNotFound);
			
			ws.GetLetterReferType.addEventListener("result", Result);
			ws.GetLetterReferType.addEventListener("fault", serviceNotFound);
			
			
			ws.GetClientConfiguration.addEventListener("result", Result);
			ws.GetClientConfiguration.addEventListener("fault", serviceNotFound);
			
			
			//ws.GetInboxByReferType.resultFormat = "e4x";
			ws.GetInboxByReferType.addEventListener("result", Result);
			ws.GetInboxByReferType.addEventListener("fault", serviceNotFound);
			
			
			//ws.GetInboxByFolder.resultFormat = "e4x";
			ws.GetInboxByFolder.addEventListener("result", Result);
			ws.GetInboxByFolder.addEventListener("fault", serviceNotFound);
			
			
			ws.GetSentInboxByReferType.addEventListener("result", Result);
			ws.GetSentInboxByReferType.addEventListener("fault", serviceNotFound);
			
			
			ws.GetConfidentialTypeList.addEventListener("result", Result);
			ws.GetConfidentialTypeList.addEventListener("fault", serviceNotFound);
			
			
			ws.GetLetterTypeList.addEventListener("result", Result);
			ws.GetLetterTypeList.addEventListener("fault", serviceNotFound);
			
			
			ws.GetInboxLetterReferItemCount.addEventListener("result", Result);
			ws.GetInboxLetterReferItemCount.addEventListener("fault", serviceNotFound);
			
			
			ws.GetInboxEmployeePositionFolderItemCount.addEventListener("result", Result);
			ws.GetInboxEmployeePositionFolderItemCount.addEventListener("fault", serviceNotFound);
			
			
			ws.GetDraftInboxByFolder.addEventListener("result", Result);
			ws.GetDraftInboxByFolder.addEventListener("fault", serviceNotFound);
			
			
			
			ws.GetSentInboxByFolder.addEventListener("result", Result);
			ws.GetSentInboxByFolder.addEventListener("fault", serviceNotFound);
			
			
			
			ws.SendLetterRefer.addEventListener("result", Result);
			ws.SendLetterRefer.addEventListener("fault", serviceNotFound);
			
			
			
			ws.GetLetterReferSendType.addEventListener("result", Result);
			ws.GetLetterReferSendType.addEventListener("fault", serviceNotFound);
			
			
			
			ws.RequestLetterBody.addEventListener("result", Result);
			ws.RequestLetterBody.addEventListener("fault", serviceNotFound);
			
			
			
			ws.GetReferReceiverContact.addEventListener("result", Result);
			ws.GetReferReceiverContact.addEventListener("fault", serviceNotFound);
			
			
			
			ws.GetLetterBodyRequestStatus.addEventListener("result", Result);
			ws.GetLetterBodyRequestStatus.addEventListener("fault", serviceNotFound);
			
			
			ws.GetLetterReceiverContact.addEventListener("result", Result);
			ws.GetLetterReceiverContact.addEventListener("fault", serviceNotFound);
			
			
			ws.GetServerDateTime.addEventListener("result", Result);
			ws.GetServerDateTime.addEventListener("fault", serviceNotFound);
			
			
			ws.GetEmployeePositionReservedReferText.addEventListener("result", Result);
			ws.GetEmployeePositionReservedReferText.addEventListener("fault", serviceNotFound);
			
			
			
			ws.GetReservedSubjectText.addEventListener("result", Result);
			ws.GetReservedSubjectText.addEventListener("fault", serviceNotFound);
			
			
			ws.GetLetterSenderContact.addEventListener("result", Result);
			ws.GetLetterSenderContact.addEventListener("fault", serviceNotFound);
			
			
			ws.GetEmployeePositionSignature.addEventListener("result", Result);
			ws.GetEmployeePositionSignature.addEventListener("fault", serviceNotFound);
			
			
			ws.GetLetterFolderList.addEventListener("result", Result);
			ws.GetLetterFolderList.addEventListener("fault", serviceNotFound);
			
			
			ws.SendLetter.addEventListener("result", Result);
			ws.SendLetter.addEventListener("fault", serviceNotFound);
			
			
			ws.GetAllSecretariatToSecretariatFormat.addEventListener("result", Result);
			ws.GetAllSecretariatToSecretariatFormat.addEventListener("fault", serviceNotFound);
			
			
			
			//These are not real server datas ↓ . I am offering them to Mr.Ziabakhsh  to release them.
			/*ws.GetContentUserInfo.resultFormat = "e4x";
			ws.GetContentUserInfo.addEventListener("result", GetTotalGEMAccountResult);
			ws.GetContentUserInfo.addEventListener("fault", serviceNotFound);*/
			
			
			ws.addEventListener(LoadEvent.LOAD,webServiceReady);
			
			retryer = new Timer(connectiontimeOut,retrys);
			retryer.addEventListener(TimerEvent.TIMER,tryAgain);
			retryer.addEventListener(TimerEvent.TIMER_COMPLETE,connectionFails);
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
				eventListen.dispatchEvent(new WebEvent3(WebEvent3.CONNECTED));
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
				myWebService3.tryToConnect();
			}
		}
		
		/**Cansel these listeners from listenning to webservice connection from Connect function*/
		public static function Disconnect(onConnected:Object, noInternet:Object):void
		{
			
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
				SaffronLogger.log('try to connect');
				if(DEBUG_DONOT_CONNECT)
				{
					ws.loadWSDL("no where");
				}
				else
				{
					SaffronLogger.log("Connect to : "+webServiceWsdl);
					ws.loadWSDL(webServiceWsdl);
				}
			}
		}
		
		/**stop trying*/
		private static function connectionFails(e=null)
		{
			if(!isitConnected)
			{
				SaffronLogger.log('connection failds');
				for(var i = 0 ; i<onDisconnectedFunctionList.length ; i++)
				{
					onDisconnectedFunctionList[i]();
				}
				onDisconnectedFunctionList = new Vector.<Function>();
				
				eventListen.dispatchEvent(new WebEvent3(WebEvent3.NO_CONNECTTION));
			}
		}
		
		/**web service is ready to use*/
		private static function webServiceReady(e)
		{
			if(isitConnected==false)
			{
				SaffronLogger.log('web service is ready to use');
				isitConnected = true ;
				eventListen.dispatchEvent(new WebEvent3(WebEvent3.CONNECTED)) ;
				//callAllOperations() ;
				
				for(var i = 0 ; i<onConnectFunctionList.length ; i++)
				{
					onConnectFunctionList[i]();
				}
				onConnectFunctionList = new Vector.<Function>();
				onDisconnectedFunctionList = new Vector.<Function>();
			}
		}
		
		/*private static function callAllOperations():void
		{
			
			for(var i = 0 ; i<operetionsList.length ; i++)
			{
				operetionsList[i].send.apply(operationsVariables[i]);
			}
			operetionsList = new Vector.<AbstractOperation>();
			operationsVariables = new Vector.<Array>();
		}	*/	
		
		/**any connection failds*/
		private static function serviceNotFound(e:*=null)
		{
			SaffronLogger.log('faild : '+e);
			var completeErrorText:String = String(e);
			SaffronLogger.log("faild to string  : "+completeErrorText);
			//i dispatch event instant;ly
			var myTocken:AsyncToken ;
			var connectionProblem:uint = WebEvent3.error_connection_problem ;
			var connectionProblemHint:String = '' ;
			if(e is FaultEvent)
			{
				myTocken = FaultEvent(e).token ;
				//Ticket Is not Valid
				// تعریف نشده است
				connectionProblemHint = XML(FaultEvent(e).fault.faultDetail)[0] ;
				if(completeErrorText.indexOf("Ticket Is not Valid")!=-1 || completeErrorText.indexOf("FailedAuthentication")!=-1)
				{
					connectionProblem = WebEvent3.error_loginProblem ;
				}
				else if(completeErrorText.indexOf("تعریف نشده است") != -1)
				{
					connectionProblem = WebEvent3.error_loginProblem ;
				}
				else if(connectionProblemHint == '' /*&& Constants.prompt_server_errors*/)
				{
					connectionProblemHint = FaultEvent(e).fault.toString() ;
				}
				
				SaffronLogger.log("connectionProblemHint : "+connectionProblemHint);
			}
			eventListen.dispatchEvent(new WebEvent3(WebEvent3.NO_CONNECTTION,null,myTocken,connectionProblem,connectionProblemHint));
		}

		
		
		
		/**Global resutl */
		private static function Result(ev:ResultEvent)
		{
			SaffronLogger.log("result : "+getQualifiedClassName(ev.result));
			var myObject:Array = [];
			if(ev.result is XMLList)
			{
				//Pure XML data
				var clearXMLList:XMLList = XMLList(clearXML2(ev.result.toString()));
				//SaffronLogger.log("clearXMLList.itemCount ?? : "+clearXMLList[0].*[0].itemCount);
				var cashedXML:XML ;
				try
				{
					cashedXML = clearXMLList[0];
				}
				catch(e)
				{
					SaffronLogger.log("Wrong inputs sent !!! check login again");
					eventListen.dispatchEvent(new WebEvent3(WebEvent3.NO_CONNECTTION,null,ev.token,WebEvent3.error_loginProblem));
					return ;
				}
				
				var generatedObject:Object = xmlToObject(cashedXML);
				//SaffronLogger.log(cashedXML+" converted to : "+JSON.stringify(generatedObject));
				
				var valueNumbers:uint = 0 ;
				for(var testValueOnObject in generatedObject)
				{
					valueNumbers++;
					SaffronLogger.log("value item is : "+testValueOnObject);
					if(generatedObject[testValueOnObject] is Array)
					{
						myObject = generatedObject[testValueOnObject] ;
					}
					if(valueNumbers>1)
					{
						break ;
					}
				}
				SaffronLogger.log("valueNumbers : "+valueNumbers);
				if(valueNumbers>1 || myObject.length == 0 )
				{
					SaffronLogger.log("i have to re generate MyObject");
					myObject = [generatedObject];
				}
				
				//SaffronLogger.log('converted to : '+JSON.stringify(myObject));
			}
			else
			{
				//Web service Objects
				var cleared:Object = clearFlexObjecting(ev.result);
				//Server null in not important from now
				/*if(ev.result==null)
				{
					SaffronLogger.log("Wrong inputs sent !!! check login again");
					eventListen.dispatchEvent(new WebEvent(WebEvent.NO_CONNECTTION,null,ev.token,WebEvent.error_loginProblem));
					return;
				}
				else */if(cleared is Array)
				{
					myObject = cleared as Array;
				}
				else if(ev.result is Object)
				{
					myObject[0] = cleared ;
				}
				else if(ev.result is Boolean)
				{
					if(ev.result)
					{
						myObject.push(true);
					}
					else
					{
						SaffronLogger.log("Receved data is false");
						eventListen.dispatchEvent(new WebEvent3(WebEvent3.NO_CONNECTTION,null,ev.token,WebEvent3.error_not_done));
						return ;
					}
				}
				else
				{
					SaffronLogger.log(new Error("I don't know this type : "+getQualifiedClassName(ev.result)));
				}
			}
			
			//SaffronLogger.log("Receved data is : "+JSON.stringify(myObject));
			
			eventListen.dispatchEvent(new WebEvent3(WebEvent3.RESULT,myObject,ev.token));
		}
		
		
		/**Set this operation and create listeners*/
		public static function setOperation(operationName:String):void
		{
			if( setOperations.indexOf(operationName) == -1 )
			{
				setOperations.push(operationName);
				var op:AbstractOperation = ws.getOperation(operationName);
				op.addEventListener("result", Result);
				op.addEventListener("fault", serviceNotFound);
			}
		}
		
		/**Send these parameters to specific operation.*/
		public static function sentParamsToOperation(operationName:String,params:Array):AsyncToken
		{
			SaffronLogger.log(operationName+' > '+params);
			var op:AbstractOperation = ws.getOperation(operationName);
			op.arguments = params ;
			return op.send();
		}
		
		
		
		
		
		
		
		
		public static function SignIn(Username:String = 'admin' , Password:String = '1'):AsyncToken
		{
			SaffronLogger.log('SignIn > ',Username,Password);
			
			var userModel:Object = new Object() ;
			userModel.Password = Password ; 
			userModel.Username = Username ; 
			
			return ws.SignIn(_applicationGuid,userModel) ;
		}
		
		
		/*public static function GetUserEmployeePosition():AsyncToken
		{
			SaffronLogger.log('GetUserEmployeePosition > ',_ticket,username);
			return ws.GetUserEmployeePosition(_ticket,username) ;
		}*/
		
		/*public static function SignOut()
		{
			SaffronLogger.log('SignOut > ',_ticket,_username);
			return ws.SignOut(_ticket,_username) ;
		}*/
		
		/**
		 * داده های مربوطه از سرویس  GetUserEmployeePositionبدست می آید	x	کد سمت	employeePositionId<br><br>
		Inbox(کارتابل)<br>
		 * SentInbox,(ارسال شده ها)<br>
		 * ،Draft(پیش نویس)	-	نوع پرونده	<br>
		 * typeKind
		 * <br><br>
		 * @use Constants.folder_inbox
		 * @see Constants
		*/
		/*public static function GetEmployeePositionFolder(ypeKind:String)
		{
			SaffronLogger.log('GetEmployeePositionFolder > ticket : ',_ticket+' , employeePositionId : '+_employeePositionId+' , typeKind : '+typeKind);
			return ws.GetEmployeePositionFolder(_ticket,_employeePositionId,typeKind) ;
		}*/
		
		
		/**Returns sub menu list for each categorie - it can just accept Inbox and SentInbox value types
		public static function GetLetterReferType(inboxType:String)
		{
			SaffronLogger.log('GetLetterReferType > ',_ticket,_employeePositionId,inboxType);
			return ws.GetLetterReferType(_ticket,_employeePositionId,inboxType) ;
		}*/
		
		
		/**Un used, false and removed service*/
		//public static function GetEmployeePositionSignature(/*employeePositionId_ignored:String,*/typeKind:String)
		//{
		//	SaffronLogger.log('GetEmployeePositionSignature > ',ticket,employeePositionId,typeKind);
		//	return ws.GetEmployeePositionSignature(ticket,employeePositionId,typeKind) ;
		//}
		
		/*public static function GetClientConfiguration()
		{
			SaffronLogger.log('GetClientConfiguration > ');
			return ws.GetClientConfiguration() ;
		}*/
		
		/*public static function GetInboxByFolder(employeePositionFolder,pageIndex,pageSize)
		{
			SaffronLogger.log('GetInboxByFolder > ',_ticket,_employeePositionId,employeePositionFolder,pageIndex,pageSize);
			// Two last parameters are the filterring values and sorting values
			return ws.GetInboxByFolder(_ticket,_employeePositionId,employeePositionFolder,pageIndex,pageSize,null,null) ;
		}*/
		
		
		/*public static function GetConfidentialTypeList()
		{
			SaffronLogger.log('GetConfidentialTypeList > ',_ticket,_employeePositionId);
			return ws.GetConfidentialTypeList(_ticket,_employeePositionId) ;
		}*/
		
		/*public static function GetLetterTypeList()
		{
			SaffronLogger.log('GetLetterTypeList > ',_ticket,_employeePositionId);
			return ws.GetLetterTypeList(_ticket,_employeePositionId) ;
		}*/
		
		/**GetInboxLetterReferItemCount
		public static function GetInboxLetterReferItemCount(typeKind:String)
		{
			SaffronLogger.log("GetInboxLetterReferItemCount > "+_ticket,_employeePositionId,typeKind);
			return ws.GetInboxLetterReferItemCount(_ticket,_employeePositionId,typeKind) ;
		}*/
		
		
		/**GetInboxEmployeePositionFolderItemCount
		public static function GetInboxEmployeePositionFolderItemCount(typeKind:String)
		{
			SaffronLogger.log("GetInboxEmployeePositionFolderItemCount > "+_ticket,_employeePositionId,typeKind);
			return ws.GetInboxEmployeePositionFolderItemCount(_ticket,_employeePositionId,typeKind) ;
		}*/
		
		/**GetDraftInboxByFolder*/
		/*public static function GetDraftInboxByFolder(employeePositionFolder,pageIndex,pageSize)
		{
			SaffronLogger.log('GetDraftInboxByFolder > ',_ticket,_employeePositionId,employeePositionFolder,pageIndex,pageSize);
			// Two last parameters are the filterring values and sorting values
			return ws.GetDraftInboxByFolder(_ticket,_employeePositionId,employeePositionFolder,pageIndex,pageSize,null,null) ;
		}*/
		
		/**GetSentInboxByFolder
		public static function GetSentInboxByFolder(employeePositionFolder,pageIndex,pageSize)
		{
			SaffronLogger.log('GetSentInboxByFolder > ',_ticket,_employeePositionId,employeePositionFolder,pageIndex,pageSize);
			// Two last parameters are the filterring values and sorting values
			return ws.GetSentInboxByFolder(_ticket,_employeePositionId,employeePositionFolder,pageIndex,pageSize,null,null) ;
		}*/
		
		/*public static function GetInboxByReferType(letterReferTypeId,pageIndex,pageSize)
		{
			SaffronLogger.log('GetInboxByReferType > ',_ticket,_employeePositionId,letterReferTypeId,pageIndex,pageSize);
			return ws.GetInboxByReferType(_ticket,_employeePositionId,letterReferTypeId,pageIndex,pageSize) ;
		}*/
		
		
		/*public static function GetSentInboxByReferType(letterReferTypeId,pageIndex=0,pageSize=0)
		{
			SaffronLogger.log('GetSentInboxByReferType > ',_ticket,_employeePositionId,letterReferTypeId,pageIndex,pageSize);
			return ws.GetSentInboxByReferType(_ticket,_employeePositionId,letterReferTypeId,pageIndex,pageSize) ;
		}*/
		
		
		/*public static function GetLetterReferSendType()
		{
			SaffronLogger.log('GetLetterReferSendType > ',_ticket,_employeePositionId);
			return ws.GetLetterReferSendType(_ticket,_employeePositionId) ;
		}*/
		
		
		/**If move button selects from the interface , set stayInInbox to false<br>
		 * if Peygiri is selected from interface , set followup to true  */
	/*	public static function SendLetterRefer(letterCode:Vector.<String>,receivers:Vector.<LetterReceiverModel>,stayInInbox:Boolean,followup:Boolean = false )
		{
			SaffronLogger.log('SendLetterRefer > ',_ticket,_employeePositionId,letterCode);
			//SaffronLogger.log('receiver list : '+JSON.stringify(letterReferId));
			//SaffronLogger.log('letterReferId_vec list : '+JSON.stringify(receivers));
			
			var receivers_arr:Array = [] ;
			for(var i = 0 ; i<receivers.length ; i++)
			{
				receivers_arr.push(receivers[i]);
			}
			
			var letterReferId_ar:Array = [] ;
			for(i = 0 ; i<letterCode.length ; i++)
			{
				letterReferId_ar.push(letterCode[i]);
			}
			
			return ws.SendLetterRefer(_ticket,_employeePositionId,letterReferId_ar,receivers_arr,stayInInbox,followup) ;
		}*/
		
		
		/*public static function RequestLetterBody(letterCode:String)
		{
			SaffronLogger.log('RequestLetterBody > ',_ticket,_employeePositionId,letterCode);
			return ws.RequestLetterBody(_ticket,_employeePositionId,letterCode) ;
		}*/
		
		/*public static function GetReferReceiverContact(searchText:String='')
		{
			SaffronLogger.log('GetReferReceiverContact > ',_ticket,_employeePositionId,searchText);
			return ws.GetReferReceiverContact(_ticket,_employeePositionId,searchText) ;
		}*/
		
		public static function GetLetterReceiverContact(searchText:String='')
		{
			SaffronLogger.log('GetLetterReceiverContact > ',_ticket,_employeePositionId,searchText);
			return ws.GetLetterReceiverContact(_ticket,_employeePositionId,searchText) ;
		}
		
		/**Enter the pdf request id here
		public static function GetLetterBodyRequestStatus(requestId:String='')
		{
			SaffronLogger.log('GetLetterBodyRequestStatus > ',_ticket,_employeePositionId,requestId);
			return ws.GetLetterBodyRequestStatus(_ticket,_employeePositionId,requestId) ;
		}*/
		
		/**Get the server date for calender
		public static function GetServerDateTime()
		{
			SaffronLogger.log("GetServerDateTime");
			return ws.GetServerDateTime();
		}*/
		
		/**Return recerved titles for erja*/
		public static function GetEmployeePositionReservedReferText()
		{
			SaffronLogger.log("GetEmployeePositionReservedReferText > ");
			return ws.GetEmployeePositionReservedReferText(_ticket,_employeePositionId);
		}
		
		/**Return recerved titles for SentMails
		public static function GetReservedSubjectText()
		{
			SaffronLogger.log("GetReservedSubjectText >");
			return ws.GetReservedSubjectText(_ticket,_employeePositionId);
		}*/
		
		/**Return the list of persons, who can insert into senders as sender contact from send mail service
		public static function GetLetterSenderContact(searchText:String='')
		{
			SaffronLogger.log("GetLetterSenderContact > "+searchText);
			return ws.GetLetterSenderContact(_ticket,_employeePositionId,searchText);
		}*/
		
		
		/**Returns the list of available sighneture to use on send mail
		public static function GetEmployeePositionSignature(searchText:String = '')
		{
			SaffronLogger.log("GetEmployeePositionSignature > "+searchText);
			return ws.GetEmployeePositionSignature(_ticket,_employeePositionId,searchText);
		}*/
		
		
		/**Uses to load Parvande lists for send mail
		public static function GetLetterFolderList()
		{
			SaffronLogger.log("GetLetterFolderList > ");
			return ws.GetLetterFolderList(_ticket,_employeePositionId);
		}*/
		
		
		/**Uses to load Andikators for sending new mail*/
		public static function GetAllSecretariatToSecretariatFormat(seachText:String = '')
		{
			SaffronLogger.log("GetAllSecretariatToSecretariatFormat > ");
			return ws.GetAllSecretariatToSecretariatFormat(_ticket,_employeePositionId,seachText);
		}
		
		/**send letter - stayInInbox = false makes mail to remove from inbox. followUp makes Flag variable returns true on Mail
		public static function SendLetter(sendMailModel:SendMailModel,stayInInbox:Boolean,followup:Boolean)
		{
			SaffronLogger.log("SendLetter");
			return ws.SendLetter(_ticket,_employeePositionId,sendMailModel,stayInInbox,followup);
		}*/
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/**In the xml mode for inbox data , I have to specify array types here*/
		private static var arrayParamLins:Array = ["EmployeePositionModel","InboxModel"];
		
		
		private static var _username:String = "";
		
		public static function get username():String
		{
			return _username ;
		}
		
		private static var _applicationGuid:String = "AE66C39B-94FC-49A8-B965-A8519C6CA8CD";
		
		public static function get applicationGuid():String
		{
			return _applicationGuid ;
		}
		
		private static var _ticket:String = "4ddf03b6-727d-473e-8b71-a545771062ab;sSGtGHyQvLe6v6JQkvp9/Wrjf8ogHE3rCSS9ogo9ZXY=";
		
		public static function get ticket():String
		{
			return _ticket;
		}
		
		private static var _employeePositionId:String = "" ;
		
		public static function get employeePositionId():String
		{
			return _employeePositionId ;
		}
		
		/**This function is calls only from SignInReq Class*/
		public static function setTicket(newTicket:String):void
		{
			_ticket = newTicket ;
		}
		
		public static function setUserName(newUserName:String):void
		{
			_username = newUserName ;
		}
		
		/**Set employeePositionId to access other services*/
		public static function setEmployeePositionId(newEmployeePositionId:String)
		{
			_employeePositionId = newEmployeePositionId ;
		}
		
		private static function controllEmployeePositionID()
		{
			if(_employeePositionId=='')
			{
				throw "employeePositionId is null. Set it with setEmployeePositionID function.";
			}
		}
		
		
		
		
		
		/**Reset the connection flag to reload data from ServerURL again*/
	/*	public static function resetConnectin(newIP:String)
		{
			//Change IP 
			
			//Reset UserData
			setUserName('') ;
			setTicket('') ;
			setEmployeePositionId('') ;
			
			//ReSet WSDL
			if(IP != newIP)
			{
				IP = newIP ;
				setUp();
			}
		}*/
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
		public static function pureData(putputXML:XMLList):XML
		{
			var pureXML:XML = putputXML[0].*[0] ;
			/*var ns:Namespace = putputXML.namespace('s');
			SaffronLogger.log('ns : '+ns);
			SaffronLogger.log(" putputXML.removeNamespace(ns) : "+putputXML.removeNamespace(ns));
			putputXML.removeNamespace(ns);*/
			return pureXML;
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
		
		private static function clearXML2(str:String):String
		{
			//SaffronLogger.log("input string : "+str);
			var cleared:String = '';
			var controll:String = '' ; 
			var tagName:String = '' ;
			/**0 nothing , 1 try to fing tag name , 2 wait to close*/
			var mode:uint = 0 ;
			for(var i = 0 ; i<str.length ; i++)
			{
				controll = str.charAt(i);
				if(mode == 0)
				{
					if(controll == '<')
					{
						mode = 1 ;
						tagName = '' ;
					}
					cleared += controll ;
				}
				else if(mode == 1)
				{
					if(controll == '/' && tagName == '')
					{
						cleared += controll;
					}
					else if(controll == ':')
					{
						tagName = '' ;
					}
					else if(controll == ' ')
					{
						cleared += tagName ;
						tagName = '' ;
						mode = 2 ;
					}
					else if(controll == '>')
					{
						cleared += tagName+controll ;
						tagName = '';
						mode = 0 ;
					}
					else
					{
						tagName += controll ;
					}
				}
				else if(mode == 2)
				{
					if(controll == '>')
					{
						cleared+=controll ;
						mode = 0 ;
					}
					else if(controll == '/' && str.charAt(i+1) == '>' )
					{
						//The only selectable string on 
						cleared += controll ;
					}
				}
			}
			//SaffronLogger.log("cleared xml is : "+cleared);
			return cleared;
		}
		
		
		private static function xmlToObject(xml:XML):Object
		{
			
			if(xml.*.length() == 0)
			{
				return '' ;
			}
			var cashedObject:Object = {} ;
			for(var i:uint = 0 ; i<xml.*.length() ; i++)
			{
				var tagName:String = xml.*[i].name() ;
				if(tagName == null)
				{
					return xml.*[i].toString() ;
				}
				//SaffronLogger.log('tag name : '+tagName+' item on this tag is : '+xml[xml.*[i].name()].length()+' and num child : '+xml[tagName].*.length());
				if(xml[tagName].length()>1 || arrayParamLins.indexOf(tagName)!=-1)
				{
					if(cashedObject[tagName]==undefined)
					{
						cashedObject[tagName] = [] ;
					}
					cashedObject[tagName].push(xmlToObject(xml.*[i]));
				}
				else
				{
					//This tag has many childrens
					//SaffronLogger.log("this is object i think : "+tagName+' because : '+xml[tagName].length()+' and the value is : '+xml.*[i]);
					cashedObject[tagName] = xmlToObject(xml.*[i]) ;
				}
			}
			return cashedObject;
		}
		
		
	//////////////////////////////////////////////////
		
		private static function clearFlexObjecting(base:*):Object
		{
			var clearObject:Object ;
			if(base is ObjectProxy)
			{
				clearObject = (base as ObjectProxy).valueOf();
				//SaffronLogger.log("That was an Object and it changed to : "+JSON.stringify(clearObject));
			}
			else if(base is ArrayCollection)
			{
				clearObject = (base as ArrayCollection).toArray();
				//SaffronLogger.log('That was an Array and it is converted to default Array');
			}
			else
			{
				clearObject = base ;
				//SaffronLogger.log("any other unkcown type");
			}
			
			for(var i in clearObject)
			{
				clearObject[i] = clearFlexObjecting(clearObject[i]);
				//SaffronLogger.log("That Object , so I have to controll all elements on it");
			}
			
			return clearObject ;
		}
		
		
		/**Add header*/
		public static function setHeader(userName:String,password:String,tocken:String,uid:String):void
		{
			
			var qname:QName = new QName("http://tmeappuri.org/","SOAPHeaderContent");
			var header:SOAPHeader = new SOAPHeader(qname,{UserName:userName,Password:password,Token:tocken,UID:uid});
			ws.clearHeaders();
			ws.addHeader(header)
		}
		
		/**Clear header*/
		public static function clearHeader():void
		{
			ws.clearHeaders();
		}
	}
}