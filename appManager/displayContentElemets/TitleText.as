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
		
		public function setUp(title:String,arabicText:Boolean = true,splitIfToLong:Boolean=false,resolution:uint=0)
		{
			TextPutter.OnButton(myText,title,arabicText,true,true,false,resolution,splitIfToLong);
		}
		
		override public function set width(value:Number):void
		{
			myText.width = value;
		}
		
		public function get text():String
		{
			return myText.text ;
		}
		
		public function set text(string:String):void
		{
			setUp(string);
		}
		
		public function color(colorNum:uint):void
		{
			trace("The color is : "+colorNum);
			// TODO Auto Generated method stub
			myText.textColor = colorNum ;
		}
		
		public function setUpMultiline(content:String,arabicText:Boolean = true,resolution:uint=0):void
		{
			// TODO Auto Generated method stub
			TextPutter.onTextArea(myText,content,arabicText,true,false,resolution);
		}
	}
}