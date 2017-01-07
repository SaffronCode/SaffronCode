package componentStatic
{
	import flash.events.Event;
	public class Mobile extends ComponentManager
	{

		private var _textbox:TextBox;
		import flash.text.SoftKeyboardType;
		
		public function Mobile()
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
			setObj(this.name,value,ErrorManager.MOBILE)
		}
		protected function textBoxEvent_fun(event:TextBoxEvent):void
		{
			
			setObj(this.name,event.text,ErrorManager.MOBILE)
		}
		public function rest()
		{
			//_textbox.setText('')
			_textbox.setValueTextByeCod_fun('')
		}

	}
}