package componentStatic
{//componentStatic.NumberBoxSender
	import flash.events.Event;
	import flash.text.SoftKeyboardType;

	public class NumberBoxSender extends ComponentManager
	{

		private var _textbox:TextBox;
		public function NumberBoxSender()
		{
			super()
			update()
			ComponentManager.evt.addEventListener(ComponentManagerEvent.UPDATE,getUpdate)
		}
		protected function getUpdate(event:Event):void
		{
			
			update()
		}
		public function update():void
		{
			var value:String  = ''
			if(getObj(this.name)!=null)
			{
				value = getObj(this.name)
			}
			_textbox = new TextBox(this,value,SoftKeyboardType.NUMBER)
			_textbox.addEventListener(TextBoxEvent.TEXT,textBoxEvent_fun)
			setObj(this.name,filter(value))	
		}
		protected function textBoxEvent_fun(event:TextBoxEvent):void
		{
			
			setObj(this.name,filter(event.text))
		}
		private function filter(Str_p:String):*
		{
			if(Str_p=='') return null
			return Number(Str_p)		
		}
		public function rest()
		{
			//_textbox.setText('')
			_textbox.setValueTextByeCod_fun('')
		}
		
		
	}
}