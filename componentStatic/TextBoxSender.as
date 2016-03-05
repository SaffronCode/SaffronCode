package componentStatic
{//componentStatic.TextBoxSender
	import flash.events.Event;
	
	public class TextBoxSender extends ComponentManager
	{
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
		private function update():void
		{
			var value:String  = ''
			if(getObj(this.name)!=null)
			{
				value = getObj(this.name)
			}
			var _textbox:TextBox = new TextBox(this,value)
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