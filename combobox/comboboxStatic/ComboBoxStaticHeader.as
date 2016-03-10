package combobox.comboboxStatic
{//combobox.comboboxStatic.ComboBoxStaticHeader
	import appManager.displayContentElemets.TitleText;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ComboBoxStaticHeader extends MovieClip
	{
		private var _status:Boolean
		private var _id:String
		private var _title:TitleText;
		public function ComboBoxStaticHeader()
		{
			super();
			
			_title = Obj.findThisClass(TitleText,this)
			_status = true
			_id = this.name.split('_')[1]
			if(ComboBoxStaticManager.defalutLable(_id)!=null)
			{
				gotoLable(ComboBoxStaticManager.defalutLable(_id))
			}
			if(_title!=null)
			{
				_title.setUp(ComboBoxStaticManager.defalutLable(_id))
			}
			this.addEventListener(MouseEvent.CLICK,menu)
			ComboBoxStaticManager.evt.addEventListener(ComboBoxStaticEvents.SELECT,changIcon)
			
			ComboBoxStaticManager.setStatus(_id,_status)
			ComboBoxStaticManager.evt.addEventListener(ComboBoxStaticEvents.CLOSE,close)
			ComboBoxStaticManager.evt.addEventListener(ComboBoxStaticEvents.OPEN,open)
				
		}
		
		protected function open(event:Event):void
		{
			// TODO Auto-generated method stub
			_status = false
		}
		
		protected function close(event:Event):void
		{
			// TODO Auto-generated method stub
			_status = true
		}
		
		protected function menu(event:MouseEvent):void
		{
			// TODO Auto-generated method stub

			ComboBoxStaticManager.evt.dispatchEvent(new ComboBoxStaticEvents(ComboBoxStaticEvents.CLOSE,null,null,null,true))
			ComboBoxStaticManager.setStatus(_id,_status)
			if(_status)
			{
				ComboBoxStaticManager.evt.dispatchEvent(new ComboBoxStaticEvents(ComboBoxStaticEvents.OPEN,null,_id))
			}
			else
			{
				ComboBoxStaticManager.evt.dispatchEvent(new ComboBoxStaticEvents(ComboBoxStaticEvents.CLOSE,null,_id))
			}
			
		}
		
		protected function changIcon(event:ComboBoxStaticEvents):void
		{
			// TODO Auto-generated method stub
		
			if(_id == event.comboBoxId)
			{	
				if(_title!=null && event.linkData!=null)
				{
					_title.setUp(event.linkData.name)
				}
				gotoLable(event.id)
				ComboBoxStaticManager.setStatus(_id,_status)
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