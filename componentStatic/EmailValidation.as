package componentStatic
{
	public class EmailValidation
	{
		public static function check(email:String,Empty_p:Boolean=false):Boolean
		{
			if(Empty_p)
			{
				if(email==''|| email==null) return true
			}

			var emailExpression:RegExp = /^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
			return emailExpression.test(email);
		}
	}
}