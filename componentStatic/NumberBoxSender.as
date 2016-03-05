package componentStatic
{//melkban.components.NumberBoxSender
	import flash.events.Event;
	import flash.text.SoftKeyboardType;

	public class NumberBoxSender extends ComponentManager
	{
		public function NumberBoxSender()
		{
			super()
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
			var _textbox:TextBox = new TextBox(this,value,SoftKeyboardType.NUMBER)
			_textbox.addEventListener(TextBoxEvent.TEXT,textBoxEvent_fun)
			setObj(this.name,filter(value))	
		}
		protected function textBoxEvent_fun(event:TextBoxEvent):void
		{
			// TODO Auto-generated method stub
			setObj(this.name,filter(event.text))
		}
		private function filter(Str_p:String):*
		{
			if(Str_p=='') return null
			return Number(Str_p)		
		}
		
	}
}