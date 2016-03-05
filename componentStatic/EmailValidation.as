package componentStatic
{
	public class EmailValidation
	{
		public static function check(email:String):Boolean
		{
			var emailExpression:RegExp = /^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
			return emailExpression.test(email);
		}
	}
}