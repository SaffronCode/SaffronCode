package componentStatic
{//componentStatic.Email
	import flash.events.Event;

	public class Email extends ComponentManager
	{

		private var _textbox:TextBox;

		import flash.text.SoftKeyboardType;
		
		
		public function Email()
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
			_textbox = new TextBox(this,value,SoftKeyboardType.EMAIL)
			_textbox.addEventListener(TextBoxEvent.TEXT,textBoxEvent_fun)
			
			setObj(this.name,value,ErrorManager.EMAIL)
		}
		protected function textBoxEvent_fun(event:TextBoxEvent):void
		{
			
			setObj(this.name,event.text,ErrorManager.EMAIL)
		}
		public function rest()
		{
			//_textbox.setText('')
			_textbox.setValueTextByeCod_fun('')
		}
	}
}