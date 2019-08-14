package popForm
{//popForm.PopFieldSearchBox
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.SoftKeyboardType;
	
	public class PopFieldSearchBox extends MovieClip
	{
		private var _field:PopFieldSimple;
		private var _close:CloseSearchButton;
		private var _onSearch:Function;
		private var _onClose:Function;
		public var text:String;
		public function PopFieldSearchBox()
		{
			super();
			_field = Obj.findThisClass(PopFieldSimple,this);
			_close = Obj.findThisClass(CloseSearchButton,this); 
		}
		public function setup(onSearch:Function=null,defualtText:String='',isArabic:Boolean=true,onClose:Function=null):void
		{

			_close.stop();
			_close.addEventListener(MouseEvent.CLICK,close);
			_onSearch = onSearch;
			_onClose = onClose;
			_field.setUp(defualtText,SoftKeyboardType.DEFAULT,false,true,isArabic,1,-1,1,1,0,null,true);
			_field.addEventListener(Event.RENDER,onChangeText)
		}
		
		protected function close(event:MouseEvent):void
		{
			if(_close.currentFrame == 2)
			{
				if(_onClose!=null)
				{
					_onClose();
				}
				_field.text = '';
			}
		}
		
		protected function onChangeText(event:Event):void
		{
			text = _field.text;
			checkClose();
			if(_onSearch!=null)
			{
				_onSearch();
			}
		}
		private function checkClose():void
		{
			if(_field.text == null || _field.text =='')
			{
				if(_close!=null)_close.gotoAndStop(1);
			}
			else
			{
				if(_close!=null)_close.gotoAndStop(2);
			}
		}
	}
}