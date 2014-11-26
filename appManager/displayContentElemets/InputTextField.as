package appManager.displayContentElemets
{
	
	import appManager.displayContentElemets.TitleText;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.SoftKeyboardType;
	import flash.text.TextField;
	import flash.ui.KeyboardType;
	
	public class InputTextField extends MovieClip
	{
		private var title:TitleText ;
		
		private var inputTF:flash.text.TextField ;
		
		
		public function InputTextField(titleText:String = '' , inputTextDefault:String='' , keBoardType:String = SoftKeyboardType.DEFAULT , isPass:Boolean = false)
		{
			super();
			
			title = Obj.findThisClass(TitleText,this,true) ;
			inputTF = Obj.get("input_txt",this) ;
			
			setUp(titleText , inputTextDefault , keBoardType );
		}
		
		/**Set up the text input again*/
		public function setUp(titleText:String = '' , inputTextDefault:String='' , keBoardType:String = SoftKeyboardType.DEFAULT , isPass:Boolean = false)
		{
			title.setUp(titleText) ;
			
			inputTF.dispatchEvent(new Event(Event.REMOVED_FROM_STAGE));
			inputTF.text = inputTextDefault ;
			
			inputTF.displayAsPassword = isPass ;
			
			FarsiInputCorrection.setUp(inputTF,keBoardType);
		}
		
		public function get text():String
		{
			return inputTF.text ;
		}
	}
}