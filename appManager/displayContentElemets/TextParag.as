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
		
		public function TextParag(moreHight:Number=0)
		{
			super();
			
			H = super.height+moreHight;
			W = super.width ;
			
			myTextTF = Obj.findThisClass(TextField,this);
			//Removed for debug
			//myTextTF.text = '' ;
			//Added for debug
				//trace(myTextTF.getTextFormat().font+' added to textParag class') ;
				
				
			
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
		
		public function setUp(myText:String,isArabic:Boolean = true,align:Boolean=true)
		{
			//This event dispatches to remove old scrollMC class
			this.dispatchEvent(new Event(Event.REMOVED_FROM_STAGE)) ;
			
			//trace("1 add parag on TextParag and its font is : "+myTextTF.defaultTextFormat.font+' added to textParag class')
			TextPutter.onTextArea(myTextTF,myText,isArabic,true,true,1,align) ;
			//Debug line ↓
			//TextPutter.onTextArea(myTextTF,myText,isArabic,false,false,1,true) ;
		//	trace("2 add parag on TextParag and its font is : "+myTextTF.defaultTextFormat.font+' added to textParag class : '+myTextTF.text)
			scrollMC = new ScrollMT(this,new Rectangle(this.x,this.y,W,H),new Rectangle(0,0,W,super.height)) ;
		}
	}
}