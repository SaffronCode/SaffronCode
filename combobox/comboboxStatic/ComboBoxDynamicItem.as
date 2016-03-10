package combobox.comboboxStatic
{//combobox.comboboxStatic.ComboBoxDynamicItem
	import appManager.displayContentElemets.TitleText;
	
	import contents.LinkData;
	
	import flash.events.MouseEvent;

	public class ComboBoxDynamicItem extends ComboBoxStaticMenu
	{
		private var _title:TitleText;
		private var _linkData:LinkData;
		public function ComboBoxDynamicItem(Menu_p:Boolean=false)
		{
			super(Menu_p);
			_title = Obj.findThisClass(TitleText,this)
			this.addEventListener(MouseEvent.CLICK,click_fun)
		}
		public function addItem(LinkData_p:LinkData):void
		{
			_linkData = LinkData_p
			if(_title!=null)
			{
				_title.setUp(_linkData.name)
			}
		}
		protected function click_fun(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var _coboBoxId:String = parent.parent.parent.name.split('_')[1]	
			select(_linkData.id,_coboBoxId,_linkData)
		}
	}
}