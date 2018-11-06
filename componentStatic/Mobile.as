package componentStatic
{
	import flash.events.Event;
	import flash.text.TextField;

	public class Mobile extends ComponentManager
	{

		private var _textbox:TextBox;
		private var valueTextMc:TextField;
		import flash.text.SoftKeyboardType;
		
		public function Mobile()
		{
			super()
			valueTextMc = Obj.get('valueText',this);
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
		public function get text():String
		{
			return valueTextMc.text;
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