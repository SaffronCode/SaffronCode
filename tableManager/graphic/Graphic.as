package tableManager.graphic
{
	public class Graphic
	{
		private var _backGroundColor:uint
		public function get backGroundColor():uint
		{
			return _backGroundColor
		}
		private var _backGroundAlpha:Number
		public function get backGroundAlpha():Number
		{
			return _backGroundAlpha
		}
		private var _lineColor:uint
		public function get lineColor():uint
		{
			return _lineColor
		}
		private var _lineAlpha:Number
		public function get lineAlpha():Number
		{
			return _lineAlpha
		}
		private var _stroke:Number;
		public function get stroke():Number
		{
			return _stroke
		}
		private var _enabled:Boolean;
		public function get enabled():Boolean
		{
			return _enabled
		}
		private var _visible:Boolean;
		public function get visible():Boolean
		{
			return _visible
		}
		public function Graphic(BackGroundColor_p:uint=0,BackGroundAlpha_p:Number=1,LineColor_p:uint=0,Stroke_p:Number=1,LineAlpha_p:Number=1,Enabled_p:Boolean=true,Visible_p:Boolean=true)
		{
			_backGroundColor = BackGroundColor_p
			_backGroundAlpha = BackGroundAlpha_p
			_lineColor = LineColor_p
			_lineAlpha = LineAlpha_p
			_stroke = Stroke_p
			_enabled = Enabled_p
			_visible = Visible_p	
		}
	}
}