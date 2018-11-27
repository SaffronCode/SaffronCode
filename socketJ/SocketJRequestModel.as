package socketJ
{
	public class SocketJRequestModel
	{
		public var FunctionId:int ;
		public var Data:Object ;
		
		public function SocketJRequestModel(functionId:uint=0,data:Object=null)
		{
			FunctionId = functionId ;
			Data = data ;
		}
	}
}