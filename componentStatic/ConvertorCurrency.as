package componentStatic
{
	public class ConvertorCurrency
	{
		public static const USD:String= "USD";
		public static const IRL:String="IRL";
		private static var usdCurrency:Number = 39000;
		public function ConvertorCurrency()
		{
		}
		public static function serverToAppCurrency(unit:String,price:String):String
		{
			var _convertPrice:Number;
			price = price.split(',').join('').split(' ').join('');
			switch(unit)
			{
				case USD:
					_convertPrice = Math.round((Number(price)/usdCurrency)*100)/100;
				break;
				case IRL:
					_convertPrice = Number(price);
				break;	
			}
			return _convertPrice.toString();
		}
		public static function appToServerCurrency(unit:String,price:String):String
		{
			var _convertPrice:Number;
			price = price.split(',').join('').split(' ').join('');
			switch(unit)
			{
				case USD:
					_convertPrice = Number(price)*usdCurrency;
					break;
				case IRL:
					_convertPrice = Number(price);
				break;	
			}
			return _convertPrice.toString();
		}
	}
}