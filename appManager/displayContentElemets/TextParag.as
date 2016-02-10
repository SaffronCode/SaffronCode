package appManager.displayContentElemets
	//appManager.displayContentElemets.TextParag
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class TextParag extends MovieClip
	{
		public var myTextTF:TextField ;
		
		private var H:Number,
					W:Number ;
		
		private var scrollMC:ScrollMT;
		private var nativeText:FarsiInputCorrection;
		
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
			if(scrollMC==null)
			{
				return myTextTF.height ;
			}
			else
			{
				return H ;
			}
		}
		
		override public function get width():Number
		{
			return W ;
		}
		
		override public function set width(value:Number):void
		{
			myTextTF.width = value ;
			W = value ;
		}
		
		override public function set height(value:Number):void
		{
			myTextTF.height = value ;
			H = value;
		}
		
		public function color(colorNum:uint):void
		{
			myTextTF.textColor = colorNum;
		}
		
		public function setUp(myText:String,isArabic:Boolean = true,align:Boolean=true,knownAsHTML:Boolean=false,activateLinks:Boolean=false,useNativeText:Boolean=false,addScroller:Boolean=true,generateLinksForURLs:Boolean=false,scrollEffect:Boolean=true,userBitmap:Boolean=true):void
		{
			//This event dispatches to remove old scrollMC class
			this.dispatchEvent(new Event(Event.REMOVED_FROM_STAGE)) ;
			if(nativeText)
			{
				nativeText.unLoad();
			}
			if(scrollMC)
			{
				scrollMC.unLoad();
			}
			if(useNativeText)
			{
				myTextTF.text = UnicodeStatic.KaafYe(myText) ;
				trace("myTextTF.text : "+myTextTF.text);
				nativeText = FarsiInputCorrection.setUp(myTextTF,null,true,true,false,true,false);
				trace("Farsi input created for this text to make it native");
			}
			else
			{
				//trace("1 add parag on TextParag and its font is : "+myTextTF.defaultTextFormat.font+' added to textParag class')
				//TextPutter.onTextArea(myTextTF,myText,isArabic,true,true,1,align,knownAsHTML) ;
				//TextPutter.onTextArea(myTextTF,myText,isArabic,!activateLinks,false,0,align,knownAsHTML,-1);
				TextPutter.onTextArea(myTextTF,myText,isArabic,userBitmap && !activateLinks,false,0,align,activateLinks,-1,generateLinksForURLs);
				//Debug line ↓
				//TextPutter.onTextArea(myTextTF,myText,isArabic,false,false,1,true) ;
				//	trace("2 add parag on TextParag and its font is : "+myTextTF.defaultTextFormat.font+' added to textParag class : '+myTextTF.text)
				if(addScroller && TextPutter.lastInfo_numLines>2)
				{
					scrollMC = new ScrollMT(this,new Rectangle(this.x,this.y,W,H),new Rectangle(0,0,W,super.height),false,false,scrollEffect) ;
				}
			}
		}
	}
}