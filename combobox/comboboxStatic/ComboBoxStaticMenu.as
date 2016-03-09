package combobox.comboboxStatic
{//combobox.comboboxStatic.ComboBoxStaticMenu
	import flash.display.MovieClip;
	import flash.events.Event;

	public class ComboBoxStaticMenu extends MovieClip
	{
		private var _comboBoxId:String;
		public function ComboBoxStaticMenu(Menu_p:Boolean=true)
		{
			super()
			if(Menu_p)
			{			
				_comboBoxId = this.name.split('_')[1]
				ComboBoxStaticManager.evt.addEventListener(ComboBoxStaticEvents.OPEN,open)
				ComboBoxStaticManager.evt.addEventListener(ComboBoxStaticEvents.CLOSE,close)	
			}
		}
		
		protected function close(event:ComboBoxStaticEvents):void
		{
			// TODO Auto-generated method stub
			if(_comboBoxId==event.comboBoxId)
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
		protected function select(Id_p:String,ComboBoxId_p:String):void
		{
			
			ComboBoxStaticManager.evt.dispatchEvent(new ComboBoxStaticEvents(ComboBoxStaticEvents.SELECT,Id_p,ComboBoxId_p))	
		}
	}
}