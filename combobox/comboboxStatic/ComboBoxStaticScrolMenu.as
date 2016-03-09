package combobox.comboboxStatic
{//combobox.comboboxStatic.ComboBoxStaticScrolMenu
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	public class ComboBoxStaticScrolMenu extends MovieClip
	{
		public function ComboBoxStaticScrolMenu()
		{
			super();
			var _h:Number = Number(this.name.split(ComboBoxStaticManager.scrolSplit)[1])
			if(!isNaN(_h) && _h!=0)
			{				
				var _rec1:Rectangle = new Rectangle(this.x,this.y,this.width,_h)
				var _rec2:Rectangle = new Rectangle(0,0,this.width,this.height)
				var scrol:ScrollMT = new ScrollMT(this,_rec1,_rec2)
			}
		}
	}
}