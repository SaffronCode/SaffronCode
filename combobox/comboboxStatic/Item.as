package combobox.comboboxStatic
{//combobox.comboboxStatic.Item
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class Item extends ComboBoxStaticMenu
	{
		public function Item(Menu_p:Boolean=false)
		{
			super(Menu_p)
			this.addEventListener(MouseEvent.CLICK,click_fun)
		}
		
		protected function click_fun(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var _id:String = this.name
			var _coboBoxId:String = parent.parent.parent.name.split('_')[1]	
			select(_id,_coboBoxId)	
		}
	}
}