package popForm
{
	public class PopMenuFieldTypes
	{
		public static const STRING:uint= 0 ;
		
		public static const DATE:uint = 1 ;
		
		public static const TIME:uint = 2 ;
		
		public var type:uint ;
		
		public function PopMenuFieldTypes(myType:uint=STRING)
		{
			type = myType ;
		}
		
		public static function stringType():PopMenuFieldTypes
		{
			return new PopMenuFieldTypes(STRING);
		}
		
		public static function dateType():PopMenuFieldTypes
		{
			return new PopMenuFieldTypes(DATE);
		}
		
		public static function timeType():PopMenuFieldTypes
		{
			return new PopMenuFieldTypes(TIME);
		}
	}
}