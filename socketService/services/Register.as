package socketService.services
{
	import socketService.SocketCaller;
	import socketService.types.Register_Params;
	
	public class Register extends SocketCaller
	{
		public function Register()
		{
			super("Register", false);
		}
		
		public function load(registerParam:Register_Params):void
		{
			super.loadParam(registerParam);
		}
	}
}