package
{
	public class Add_Zero_Behind
	{
		public function Add_Zero_Behind()
		{
		}
		public static function add(NumberZero_p:int,Number_p:int):String
		{		
			var _numToStr:String = String(Number_p)
			while(_numToStr.length<NumberZero_p)
			{
				_numToStr="0"+_numToStr
			}
			return _numToStr
		}

	}
}