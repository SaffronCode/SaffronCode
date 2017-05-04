package socketService
{
	internal class SocketRequestFormat
	{
		/**Pass the function name here*/
		public var FuncName:String ;
		
		public var Params:Object ;
		
		public function SocketRequestFormat(theFunctionName:String,requestedData:Object)
		{
			FuncName = theFunctionName ;
			Params = requestedData ;
		}
	}
}