package tableManager.data
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.SoftKeyboardType;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	import tableManager.TableEvents;
	


	public class InputText extends MovieClip
	{
		[Event(name="INPUTEXT_TABLE",type="tableManager.TableEvents")]		
		private var _className:String;
		public function get className():String
		{
			return _className
		}
		private var _text:String;
		public function get text():String
		{
			return _text
		}
		private var _id:int;
		public function get id():int
		{
			return _id
		}
		private var _name:String;
		public function get nameId():String
		{
			return _name
		}
		private var _ReturnOnValueOnCreat:Boolean;
		public function get returnOnValueOnCreat():Boolean
		{
			return _ReturnOnValueOnCreat
		}
		private var _inputText:*;
		public function get inputText():*
		{
			return _inputText
		}
		private var _softKeyFormat:String
		public function get softKeyFormat():String
		{
			return _softKeyFormat
		}
		private var delayTimver:Timer = new Timer(1)
		public function InputText(Class_p:String,Text_p:String,Id_p:int,Name_p:String,ReturnOnValueOnCreat_p:Boolean = false,SoftKeyFormat_p:String = SoftKeyboardType.DEFAULT)
		{
			_className = Class_p
			_text = Text_p
			_id = 	Id_p
			_name = Name_p
			_ReturnOnValueOnCreat = ReturnOnValueOnCreat_p
			_softKeyFormat = SoftKeyFormat_p
			if(ReturnOnValueOnCreat_p)
			{
				delayTimver.addEventListener(TimerEvent.TIMER,delay_fun)
				delayTimver.start()
					
			}	
		}
		protected function delay_fun(event:TimerEvent):void
		{
			// TODO Auto-generated method stub
			delayTimver.stop()
			delayTimver.removeEventListener(TimerEvent.TIMER,delay_fun)
			setValueText_fun()
		}

		public function setup():*
		{
			var components:Class = getDefinitionByName(_className) as Class;
			_inputText = new components()
				
			_inputText.valueText.addEventListener(Event.CHANGE,changeTextBox_Fun);
			FarsiInputCorrection.clear(_inputText.valueText)
			_inputText.valueText.text = text
			FarsiInputCorrection.setUp(_inputText.valueText,softKeyFormat)	
	
			return 	_inputText
		}
		private function setValueText_fun():void
		{
			_text = _inputText.valueText.text
			this.dispatchEvent(new TableEvents(TableEvents.INPUTEXT_TABLE,null,null,null,null,this));
		}
		public function reset():void
		{
			_inputText.valueText.text=""
			setValueText_fun()
		}
		public function setValueTextByeCod_fun(Value_p:String):void
		{			
			FarsiInputCorrection.clear(_inputText.valueText)
			_inputText.valueText.text = Value_p
			FarsiInputCorrection.setUp(_inputText.valueText)				
			setValueText_fun()
		}

		private function changeTextBox_Fun(evt:Event):void
		{
			setValueText_fun()			
		}

	}
}