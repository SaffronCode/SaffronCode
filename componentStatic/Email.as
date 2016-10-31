package componentStatic
{//componentStatic.Email
	import flash.events.Event;

	public class Email extends ComponentManager
	{

		import flash.text.SoftKeyboardType;
		
		
		public function Email()
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
		public function update():void
		{
			var value:String  = ''
			if(getObj(this.name)!=null)
			{
				value = getObj(this.name)
			}
			var _textbox:TextBox = new TextBox(this,value,SoftKeyboardType.EMAIL)
			_textbox.addEventListener(TextBoxEvent.TEXT,textBoxEvent_fun)
			
			setObj(this.name,value,ErrorManager.EMAIL)
		}
		protected function textBoxEvent_fun(event:TextBoxEvent):void
		{
			// TODO Auto-generated method stub
			setObj(this.name,event.text,ErrorManager.EMAIL)
		}
	}
}