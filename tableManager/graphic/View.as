package tableManager.graphic
{
	public class View
	{
		private var _visible:Boolean;
		public function get visible():Boolean
		{
			return _visible
		}
		private var _alpha:Number;
		public function get alpha():Number
		{
			return _alpha
		}
		private var _alphaChild:Number
		public function get alphaChild():Number
		{
			return _alphaChild
		}
		private var _enabled:Boolean
		public function get enabled():Boolean
		{
			return _enabled
		}
		public function View(Visible_p:Boolean=true,Alpha_p:Number=1,AlphaChild_p:Number=1,Enabled_p:Boolean=true)
		{
			_visible = Visible_p
			_alpha = Alpha_p	
			_alphaChild = AlphaChild_p
			_enabled = Enabled_p	
		}
	}
}