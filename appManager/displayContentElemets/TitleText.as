package appManager.displayContentElemets
	//appManager.displayContentElemets.TitleText
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class TitleText extends MovieClip
	{
		protected var myText:TextField ;
		
		public function TitleText()
		{
			super();
			
			myText = Obj.get("text_txt",this);
			if(myText==null)
			{
				myText = Obj.findThisClass(TextField,this);
			}
			myText.multiline = false ;
			myText.text = '';
		}
		
		public function setUp(title:String,arabicText:Boolean = true)
		{
			TextPutter.OnButton(myText,title,arabicText,true,true);
		}
		
		public function get text():String
		{
			return myText.text ;
		}
	}
}