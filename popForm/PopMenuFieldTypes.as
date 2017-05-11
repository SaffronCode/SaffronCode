package popForm
{
	public class PopMenuFieldTypes
	{
		public static const STRING:uint= 0 ;
		
		public static const DATE:uint = 1 ;
		
		public static const TIME:uint = 2 ;
		
		/**This type is same as string value but user cannot edit the text but when he clicek, it will dispatch an event*/
		public static const CLICK:uint = 3 ;
		
		public static const PHONE:uint = 4 ;
		
		public static const RadioButton:uint = 5 ;
		
		public static const BOOLEAN:uint = 6 ;
		
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