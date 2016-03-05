package
{
	public class SplitNumberRange
	{
		public static const LEFT:String = "LEFT",
							RIGHT:String = "RIGHT"
		public function SplitNumberRange()
		{
		}
		/**Value_p is of any type will become to String type*/
		public static function split(value_p:*,splitRange_p:int,car_p:String,direction_p:String,reverse_p:Boolean=false):String
		{
			var splitValueArray:Array = new Array()
			var valToString:String = value_p.toString()
			var split:String	
			while(valToString.length>splitRange_p)
			{
				if(direction_p == RIGHT)
				{
					split = valToString.substr(valToString.length-splitRange_p,valToString.length)
					valToString = valToString.substr(0,valToString.length-splitRange_p)	
					splitValueArray.push(split)
				}
				else if(direction_p == LEFT)
				{
					split = valToString.substr(0,splitRange_p)
					valToString = valToString.substr(splitRange_p,valToString.length)
					splitValueArray.push(split)
				}
			}	
			if(valToString.length!=0)splitValueArray.push(valToString)			
			if(direction_p == RIGHT)splitValueArray.reverse()
				
			// for edit text 	
			if(reverse_p)splitValueArray.reverse()
				
			return splitValueArray.join(car_p)
		}

	}
}