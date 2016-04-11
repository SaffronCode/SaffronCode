package componentStatic
{//componentStatic.TextBoxSender
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.SoftKeyboardType;
	
	public class TextBoxSender extends ComponentManager
	{
		private var _textbox:TextBox;
		public function TextBoxSender()
		{
			update()
			ComponentManager.evt.addEventListener(ComponentManagerEvent.UPDATE,getUpdate)
		}
		
		protected function getUpdate(event:Event):void
		{
			// TODO Auto-generated method stub
			update()
		}
		public function update():void
		{
			var value:String  = ''
			var oldValue:String	
			if(getObj(this.name)!=null && getObj(this.name)!='')
			{
				value = getObj(this.name)
				oldValue = value	
			}		
			_textbox = new TextBox(this,value,SoftKeyboardType.DEFAULT)
			_textbox.addEventListener(TextBoxEvent.TEXT,textBoxEvent_fun)
			setObj(this.name,value)
		}
		protected function textBoxEvent_fun(event:TextBoxEvent):void
		{
			// TODO Auto-generated method stub
			setObj(this.name,event.text)
		}
	}
}