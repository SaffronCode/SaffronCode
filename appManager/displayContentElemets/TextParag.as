package appManager.displayContentElemets
	//appManager.displayContentElemets.TextParag
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	public class TextParag extends MovieClip
	{
		private var myTextTF:TextField ;
		
		private var H:Number,
					W:Number ;
		
		private var scrollMC:ScrollMT;
		
		public function TextParag()
		{
			super();
			
			H = super.height;
			W = super.width ;
			
			myTextTF = Obj.findThisClass(TextField,this);
			myTextTF.text = '' ;
			
			myTextTF.multiline = true ;
		}
		
		override public function get height():Number
		{
			return H ;
		}
		
		override public function get width():Number
		{
			return W ;
		}
		
		public function setUp(myText:String,isArabic:Boolean = true)
		{
			//This event dispatches to remove old scrollMC class
			this.dispatchEvent(new Event(Event.REMOVED_FROM_STAGE));
			TextPutter.onTextArea(myTextTF,myText,isArabic,true,true,1,true);
			scrollMC = new ScrollMT(this,new Rectangle(this.x,this.y,W,H),new Rectangle(0,0,W,super.height));
		}
	}
}