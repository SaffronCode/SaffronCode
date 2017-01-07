package componentStatic
{//componentStatic.PriceBoxSender
	import flash.events.Event;
	import flash.text.SoftKeyboardType;
	


	public class PriceBoxSender extends ComponentManager
	{
		public function PriceBoxSender()
		{
			super();
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
			var _textbox:TextBox = new TextBox(this,value,SoftKeyboardType.NUMBER,false,true,false)
			_textbox.addEventListener(TextBoxEvent.TEXT,textBoxEvent_fun)
			setObj(this.name,value,ErrorManager.PRICE)		
		}
		protected function textBoxEvent_fun(event:TextBoxEvent):void
		{
			
			setObj(this.name,event.text,ErrorManager.PRICE)
		}
	}
}