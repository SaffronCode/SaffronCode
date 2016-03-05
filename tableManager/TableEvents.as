package tableManager
{
	import flash.events.Event;
	
	import tableManager.data.Button;
	import tableManager.data.ChekBox;
	import tableManager.data.InputText;
	import tableManager.data.NumberRangeTable;
	import tableManager.data.Pictrue;
	import tableManager.data.RadioButtons;

	public class TableEvents extends Event
	{
		public static const UPDATE_TABLE:String = "UPDATE_TABLE"
		public static const COMPELET_TABLE:String = "COMPELET_TABLE"
		
		public static const BUTTONS_TABLE:String = "BUTTONS_TABLE"	
		public static const PICTRUE_TALBE:String = "PICTRUE_TALBE"
		public static const RADIOBUTTON_TABLE:String = "RADIOBUTTON_TABLE"
		public static const CHEKBOX_TABLE:String = "CHEKBOX_TABLE"
		public static const NUMBER_RANGE_TABLE:String = "NUMBER_RANGE_TABLE"
		public static const INPUTEXT_TABLE:String = 	"INPUTEXT_TABLE"
			
		public static const CLICK:String = "CLICK"	
		public static const DOWN:String = "DOWN"
		public static const UP:String = "UP"
		public static const OVER:String = "OVER"
		public static const OUT:String = "OUT"
		public static const RELEASE_OUTSIDE = "RELEASE_OUTSIDE"	
		
		
		private var _buttons:Button;
		public function get buttons():Button
		{
			return _buttons
		}
		private var _pictrue:Pictrue
		public function get pictrue():Pictrue
		{
			return _pictrue
		}
		private var _radioButton:RadioButtons;
		public function get radioButton():RadioButtons
		{
			return _radioButton
		}
		private var _chekBox:ChekBox;
		public function get chekBox():ChekBox
		{
			return _chekBox
		}
		private var _numberRange:NumberRangeTable;
		public function get numberRange():NumberRangeTable
		{
			return _numberRange
		}
		private var _inputText:InputText;
		public function get inputText():InputText
		{
			return _inputText
		}
		public function TableEvents(type:String,buttons:Button=null,pictrue:Pictrue=null,radioButton:RadioButtons=null,numberRange:NumberRangeTable=null,inputText:InputText=null,chekBox:ChekBox=null,bbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type,bubbles,cancelable);
			_buttons = buttons
			_pictrue = pictrue
			_radioButton = radioButton	
			_numberRange = numberRange
			_inputText = inputText	
			_chekBox = chekBox	
		}
		override public function clone():Event
		{
			return new TableEvents(type,buttons,pictrue,radioButton,numberRange,inputText,chekBox,bubbles,cancelable)
		}
	}
}