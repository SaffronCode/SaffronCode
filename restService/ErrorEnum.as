package restService
{
	public class ErrorEnum
	{
		public static const noError:int = 0 ;
		
		public static const SignInFailed:int = 1 ;
		public static const MemberIsDisabled:int = 2 ;
		public static const UserIsNotAuthorized:int = 3 ;
		public static const UserIsNotAuthenticated:int = 4 ;
		public static const PasswordIsNotConfirmedCorrectly:int = 5 ;
		public static const CurrentPasswordIsWrong:int = 6 ;
		public static const RequiredFieldsIsEmpty:int = 7 ;
		public static const UsernameIsDuplicated:int = 8 ;
		public static const DeviceIsNotAuthenticated:int = 9 ;
		public static const EmailIsNotValid:int = 10 ;
		public static const MobileIsNotValid:int = 11 ;
		
		public static const ConnectionError:int = -1 ;
		
		public static const JsonParsProblem:int = -2 ;
		
		public static const BinaryError:int = -3 ;
		
		public function ErrorEnum()
		{
			super();
		}
	}
}