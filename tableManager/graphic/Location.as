package tableManager.graphic
{
	import flash.geom.Rectangle;

	public class Location
	{
		private var _rectangle:Rectangle;
		public function get rectangle():Rectangle
		{
			return _rectangle
		}
		private var _z:Number;
		public function get z():Number
		{
			return _z
		}
		private var _index:int;
		public function get index():int
		{
			return _index
		}
		public function Location(Rectangle_p:Rectangle,Index_p:int=-1,Z_p:Number=undefined)
		{
			_rectangle = Rectangle_p
			_z = Z_p
			_index = Index_p	
		}
	}
}