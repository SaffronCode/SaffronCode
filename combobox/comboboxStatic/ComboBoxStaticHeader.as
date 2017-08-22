package combobox.comboboxStatic
{//combobox.comboboxStatic.ComboBoxStaticHeader
	import appManager.displayContentElemets.TitleText;
	
	import flash.desktop.NativeApplication;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import popForm.PopMenu;
	
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
			setTitle()
			this.addEventListener(MouseEvent.CLICK,menu)
			ComboBoxStaticManager.evt.addEventListener(ComboBoxStaticEvents.SELECT,changIcon)
			
			ComboBoxStaticManager.setStatus(_id,_status)
			ComboBoxStaticManager.evt.addEventListener(ComboBoxStaticEvents.CLOSE,close)
			ComboBoxStaticManager.evt.addEventListener(ComboBoxStaticEvents.OPEN,open)
				
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN,preventBackIfMenuWasOpen,false,100);
			
			this.buttonMode = true ;
		}
		
		protected function preventBackIfMenuWasOpen(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.BACK || event.keyCode == Keyboard.BACKSPACE || event.keyCode == Keyboard.PAGE_UP )
			{
				if(!_status)
				{
					event.preventDefault();
					event.stopImmediatePropagation();
					ComboBoxStaticManager.evt.dispatchEvent(new ComboBoxStaticEvents(ComboBoxStaticEvents.CLOSE,null,_id))
					ComboBoxStaticManager.setStatus(_id,_status)
				}
				//trace("FocusDirection : "+FocusDirection);
				//trace("(stage as Stage).focus : "+(stage as Stage).focus);
			}
		}
		public function setTitle():void
		{
			if(ComboBoxStaticManager.defalutLable(_id)!=null)
			{
				gotoLable(ComboBoxStaticManager.defalutLable(_id))
			}
			if(_title!=null)
			{
				_title.setUp(ComboBoxStaticManager.defalutLable(_id))
			}
		}
		
		protected function open(event:Event):void
		{
			
			_status = false
		}
		
		protected function close(event:Event):void
		{
			
			_status = true
		}
		
		protected function menu(event:MouseEvent):void
		{
			

			//ComboBoxStaticManager.evt.dispatchEvent(new ComboBoxStaticEvents(ComboBoxStaticEvents.CLOSE,null,null,null,true))
			if(_status)
			{
				ComboBoxStaticManager.evt.dispatchEvent(new ComboBoxStaticEvents(ComboBoxStaticEvents.OPEN,null,_id))
			}
			else
			{
				ComboBoxStaticManager.evt.dispatchEvent(new ComboBoxStaticEvents(ComboBoxStaticEvents.CLOSE,null,_id))
			}
			ComboBoxStaticManager.setStatus(_id,_status)
			
		}
		
		protected function changIcon(event:ComboBoxStaticEvents):void
		{
			
		
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