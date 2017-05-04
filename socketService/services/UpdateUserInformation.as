package socketService.services
{
	import socketService.SocketCaller;
	import socketService.types.UpdateUserInformation_Params;
	
	public class UpdateUserInformation extends SocketCaller
	{
		public function UpdateUserInformation()
		{
			super("UpdateUserInformation", false);
		}
		
		public function load(userInformation:UpdateUserInformation_Params):void
		{
			super.loadParam(userInformation);
		}
	}
}