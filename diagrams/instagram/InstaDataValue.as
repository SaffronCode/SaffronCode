package diagrams.instagram
{
	public class InstaDataValue
	{
		public var name:String;
		/**↨*/
		public var Vval:Number;
		/**↔*/
		public var Hval:Number;
		
		public function InstaDataValue(Horizontal_value:Number,VerticalValue:Number,Name:String='')
		{
			Hval = Horizontal_value ;
			Vval = VerticalValue ;
			name = Name ;
		}
		
		public function toString():Number
		{
			return Hval;
		}
	}
}