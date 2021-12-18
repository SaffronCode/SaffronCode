package netManager
{
	import flash.net.DatagramSocket;
	import flash.utils.ByteArray;
	import flash.events.DatagramSocketDataEvent;

	public class UDPManager
	{
		private static var myUDP:DatagramSocket ;

		private static var onReceiveFunction:Function ;

		private static function setUp():void
		{
			if(myUDP==null)
			{
				myUDP = new DatagramSocket();
				myUDP.addEventListener(DatagramSocketDataEvent.DATA,onDataReceived);
			}
		}

		private static function onDataReceived(e:DatagramSocketDataEvent):void
		{
			trace("Message received");
			var message:String = e.data.toString();
			if(onReceiveFunction!=null && onReceiveFunction.length>0)
				onReceiveFunction(message)
		}

		private static function getMessageOnPort(onRespond:Function,myPort:uint):void
		{
			trace("myUDP.connected : "+myUDP.connected);
			trace("myUDP.localPort : " +myUDP.localPort);
			onReceiveFunction = onRespond ;
			if(myUDP.localPort==0 || ( myUDP.localPort!=myPort))
			{
				if(myUDP.connected)
					myUDP.close();
				
				myUDP.bind(myPort);
				myUDP.receive();
			}
		}

		public static function isConnected():Boolean
		{
			return myUDP.connected && myUDP.localPort !=0;
		}

		public static function sendMessageTo(message:String,onRespond:Function,targetIp:String,targetPort:uint,localPort:uint=2000):void
		{
			setUp();
			trace("Message sent:"+message);
			getMessageOnPort(onRespond,localPort);
			var data:ByteArray = new ByteArray();
			data.writeUTFBytes(message);
			myUDP.send(data,0,0,targetIp,targetPort);
			myUDP.receive();
		}
	}
}