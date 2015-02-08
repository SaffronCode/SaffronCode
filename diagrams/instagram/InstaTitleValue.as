package diagrams.instagram
{
	public class InstaTitleValue
	{
		public var title:String ;
		
		public var value:Number ;
		
		public var position:Number ;
		
		public function InstaTitleValue(value_v:Number,title_v:String='')
		{
			value = value_v;
			if(title_v == '')
			{
				title = value_v.toString();
			}
			else
			{
				title = title_v ;
			}
		}
		
		public function toString():Number
		{
			return value ;
		}
	}
}