package net
{
	import com.mteamapp.StringFunctions;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;

	[Event(name="complete", type="flash.events.Event")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	public class SaffronURLLoader extends EventDispatcher
	{
		private var senderSocket:Socket ;

		private var rawBodyToSend:String;
		
		public function SaffronURLLoader()
		{
			super();
			senderSocket = new Socket();
			senderSocket.addEventListener(Event.CONNECT,onConnectedToSocket);
			senderSocket.addEventListener(IOErrorEvent.IO_ERROR,connectionError);
			senderSocket.addEventListener(ProgressEvent.SOCKET_DATA,serverAnswered);
		}
		
		public function load(request:URLRequest):void
		{
			if(senderSocket.connected)
			{
				senderSocket.close();
			}
			
			const ln:String = '\r\n';
			
			//Create headers
			rawBodyToSend = request.method+' / HTTP/1.1'+ln +
				'Host: '+request.url+ln;
			for(var i:int = 0 ; i<request.requestHeaders.length ; i++)
			{
				var currentHeader:URLRequestHeader = request.requestHeaders[i] ;
				rawBodyToSend+=currentHeader.name+': '+currentHeader.value+ln;
			}
			rawBodyToSend+=ln;
			//Body part
			if(request.data!=null)
				rawBodyToSend+=request.data.toString();
			
			var currentDomain:String = StringFunctions.findMainDomain(request.url);
			var currentPort:int = StringFunctions.findPortOfURL(request.url) ;
			if(currentPort==-1)
			{
				currentPort = 80 ;
			}
			
			senderSocket.connect(currentDomain,currentPort);
		}
		
		
		protected function serverAnswered(event:ProgressEvent):void
		{
			// TODO Auto-generated method stub
			trace("Server answered : "+senderSocket.readUTFBytes(senderSocket.bytesAvailable));
		}
		
		protected function connectionError(event:IOErrorEvent):void
		{
			trace("Server connection fails");
			this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
		
		protected function onConnectedToSocket(event:Event):void
		{
			trace("Server connected, Send request : "+rawBodyToSend);
			senderSocket.writeUTFBytes(rawBodyToSend);
			senderSocket.flush();
		}
	}
}