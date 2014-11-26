package appManager.displayContentElemets
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class TitleText extends MovieClip
	{
		private var myText:TextField ;
		
		public function TitleText()
		{
			super();
			
			myText = Obj.get("text_txt",this);
			myText.multiline = false ;
			myText.text = '';
		}
		
		public function setUp(title:String,arabicText:Boolean = true)
		{
			TextPutter.OnButton(myText,title,arabicText,true,true);
		}
	}
}