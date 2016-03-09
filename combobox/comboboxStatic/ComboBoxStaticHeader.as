package combobox.comboboxStatic
{//combobox.comboboxStatic.ComboBoxStaticHeader
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ComboBoxStaticHeader extends MovieClip
	{
		private var _status:Boolean
		private var _id:String
		public function ComboBoxStaticHeader()
		{
			super();
			
			
			_status = true
			_id = this.name.split('_')[1]
			if(ComboBoxStaticManager.defalutLable(_id)!=null)
			{
				gotoLable(ComboBoxStaticManager.defalutLable(_id))
			}
			this.addEventListener(MouseEvent.CLICK,menu)
			ComboBoxStaticManager.evt.addEventListener(ComboBoxStaticEvents.SELECT,changIcon)
		}
		
		protected function menu(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(_status)
			{
				ComboBoxStaticManager.evt.dispatchEvent(new ComboBoxStaticEvents(ComboBoxStaticEvents.OPEN,null,_id))
			}
			else
			{
				ComboBoxStaticManager.evt.dispatchEvent(new ComboBoxStaticEvents(ComboBoxStaticEvents.CLOSE,null,_id))
			}
			_status = !_status
		}
		
		protected function changIcon(event:ComboBoxStaticEvents):void
		{
			// TODO Auto-generated method stub
		
			if(_id == event.comboBoxId)
			{	
				gotoLable(event.id)
				_status = true
				ComboBoxStaticManager.evt.dispatchEvent(new ComboBoxStaticEvents(ComboBoxStaticEvents.CLOSE,null,_id))
			}
		}
		private function gotoLable(Lable_p:String):void
		{
			try
			{
				gotoAndStop(Lable_p)
			}
			catch(e:Error)
			{
				trace('no fond '+Lable_p)
			}
		}
	}
}