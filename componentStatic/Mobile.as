package componentStatic
{
	import flash.events.Event;
	public class Mobile extends ComponentManager
	{
		import flash.text.SoftKeyboardType;
		
		public function Mobile()
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
			var _textbox:TextBox = new TextBox(this,value,SoftKeyboardType.NUMBER)
			_textbox.addEventListener(TextBoxEvent.TEXT,textBoxEvent_fun)
			setObj(this.name,value,ErrorManager.MOBILE)
		}
		protected function textBoxEvent_fun(event:TextBoxEvent):void
		{
			// TODO Auto-generated method stub
			setObj(this.name,event.text,ErrorManager.MOBILE)
		}

	}
}