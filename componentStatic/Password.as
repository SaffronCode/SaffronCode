package componentStatic
{//componentStatic.Password
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.SoftKeyboardType;
	import flash.text.TextField;

	public class Password extends ComponentManager
	{
		public var title:String=null
		private var titleText:TextField;	
		public function Password()
		{
			super();
			titleText = Obj.get('defaultValue',this)
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
			if(title!=null)
			{
				setDefaultPass(title)
			}	
			if(titleText!=null)
			{
				titleText.mouseEnabled = false	
			}
			var _textbox:TextBox = new TextBox(this,value,SoftKeyboardType.DEFAULT,false,false,false)
			_textbox.addEventListener(TextBoxEvent.TEXT,textBoxEvent_fun)
			this.addEventListener(MouseEvent.CLICK,selectFild)
			setObj(this.name,value)	
		}
		
		protected function selectFild(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			setDefaultPass('')
		}
		protected function textBoxEvent_fun(event:TextBoxEvent):void
		{
			// TODO Auto-generated method stub
			setObj(this.name,event.text)

			if(event.text!='')
			{
				setDefaultPass('')
			}
			else if(event.text=='' && title!=null)
			{
				setDefaultPass(title)
			}
		}
		private function setDefaultPass(DefaultValue_p:String):void
		{
			if(titleText!=null)
			{
				UnicodeStatic.htmlText(titleText,DefaultValue_p,true,false,false)			
			}
		}
	}
}