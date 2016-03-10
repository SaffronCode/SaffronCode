package combobox.comboboxStatic
{//combobox.comboboxStatic.ComboBoxStaticMenu
	import contents.LinkData;
	import contents.PageData;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;

	public class ComboBoxStaticMenu extends MovieClip
	{
		private var _comboBoxId:String;
		private var _scrolMenu:ComboBoxStaticScrolMenu;
		private var _menu:Boolean;
		public function ComboBoxStaticMenu(Menu_p:Boolean=true)
		{
			super()
			_menu = Menu_p
			_scrolMenu = Obj.findThisClass(ComboBoxStaticScrolMenu,this,true)
			if(_menu)
			{			
				_comboBoxId = this.name.split('_')[1]
				ComboBoxStaticManager.evt.addEventListener(ComboBoxStaticEvents.OPEN,open)
				ComboBoxStaticManager.evt.addEventListener(ComboBoxStaticEvents.CLOSE,close)	
			}
		}
		public function setup(PageData_p:PageData):void
		{
			if(_scrolMenu!=null)
			{
				_scrolMenu.setup(PageData_p)
			}
		}
		protected function close(event:ComboBoxStaticEvents):void
		{
			// TODO Auto-generated method stub
			if(_menu && this.currentFrame!=1  &&( _comboBoxId==event.comboBoxId || event.closeAllComboBox ))
			{
				gotoAndPlay(ComboBoxStaticEvents.CLOSE)
				this.mouseChildren = false
				this.mouseEnabled = false	
			}
		}
		
		protected function open(event:ComboBoxStaticEvents):void
		{
			// TODO Auto-generated method stub
			if(_comboBoxId==event.comboBoxId)
			{
				gotoAndPlay(ComboBoxStaticEvents.OPEN)
				this.mouseChildren = true
				this.mouseEnabled = true	
			}
		}
		protected function select(Id_p:String,ComboBoxId_p:String,linkData_p:LinkData=null):void
		{
			
			ComboBoxStaticManager.evt.dispatchEvent(new ComboBoxStaticEvents(ComboBoxStaticEvents.SELECT,Id_p,ComboBoxId_p,linkData_p))	
		}
	}
}