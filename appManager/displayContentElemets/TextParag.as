package appManager.displayContentElemets
	//appManager.displayContentElemets.TextParag
{
	import contents.alert.Alert;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	

	
	public class TextParag extends MovieClip
	{
		public var myTextTF:TextField ;
		
		private var H:Number,
					W:Number ;
					
		private var textHeight0:Number ;
		
		private var scrollMC:ScrollMT;
		private var nativeText:FarsiInputCorrection;
		
		//private var X0:Number,Y0:Number ;
		public static var linkColor:int=-1;
		
		private var fontSize0:int 
		;
		private var myText:String;
		private var isArabic:Boolean;
		private var align:Boolean;
		private var knownAsHTML:Boolean;
		private var activateLinks:Boolean;
		private var useNativeText:Boolean;
		private var addScroller:Boolean;
		private var generateLinksForURLs:Boolean;
		private var scrollEffect:Object;
		private var userBitmap:Boolean;
		private var VerticalAlign:Boolean;
		private var useCash:Boolean;
		private var captureResolution:uint;
		private var splitIfToLong:Boolean;
		
		private var forScrollContainer:Sprite ;
		
		public function get text():String
		{
			return myTextTF.text;
		}
		public function TextParag(moreHight:Number=0,myText:TextField=null)
		{
			super();
			
			if(myText==null)
			{
				myTextTF = Obj.findThisClass(TextField,this);
				myTextTF.text = '' ;
			}
			else
			{
				myTextTF = myText ;
				this.addChild(myText);
				myText.x = myText.y = 0 ;
			}
			
			forScrollContainer = new Sprite();
			for(var i:int = 0 ; i<this.numChildren ; i++)
			{
				var item:DisplayObject = this.getChildAt(i);
				item.addEventListener(Event.REMOVED,blockEventBuble,false,1000000);
				item.addEventListener(Event.REMOVED_FROM_STAGE,blockEventBuble,false,1000000);
				forScrollContainer.addChild(item);
				item.removeEventListener(Event.REMOVED,blockEventBuble);
				item.removeEventListener(Event.REMOVED_FROM_STAGE,blockEventBuble);
			}
			
			this.addChild(forScrollContainer);
			
			function blockEventBuble(e:Event):void
			{
				e.stopImmediatePropagation();
			}
			
			textHeight0 = myTextTF.height ;
			
			H = super.height+moreHight ;
			W = super.width ;
			//Removed for debug
			//myTextTF.text = '' ;
			//Added for debug
				//trace(myTextTF.getTextFormat().font+' added to textParag class') ;
				
			fontSize0 = myTextTF.defaultTextFormat.size as uint ;
			
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
			updateInterface();
		}
		
		override public function set height(value:Number):void
		{
			myTextTF.height = value ;
			H = value;
			updateInterface();
		}
		
		public function color(colorNum:uint):void
		{
			myTextTF.textColor = colorNum;
		}
		
		public function setUp(myText:String,isArabic:Boolean = true,align:Boolean=true,knownAsHTML:Boolean=false,activateLinks:Boolean=false,useNativeText:Boolean=false,addScroller:Boolean=true,generateLinksForURLs:Boolean=false,scrollEffect:Boolean=true,userBitmap:Boolean=true,VerticalAlign:Boolean=false,useCash:Boolean=false,captureResolution:uint=0,splitIfToLong:Boolean=false):void
		{
			this.myText = myText;
			this.isArabic = isArabic ;
			this.align = align ;
			this.knownAsHTML = knownAsHTML;
			this.activateLinks = activateLinks ;
			this.useNativeText = useNativeText ;
			this.addScroller = addScroller ;
			this.generateLinksForURLs = generateLinksForURLs ;
			this.scrollEffect = scrollEffect ;
			this.userBitmap = userBitmap;
			this.VerticalAlign = VerticalAlign ;
			this.useCash = useCash ;
			this.captureResolution = captureResolution ;
			this.splitIfToLong = splitIfToLong ;
			
			//updateItCan();
			updateInterface();
		}
		
		/*private function updateItCan():void
		{
			if(this.stage!=null)
			{
				updateInterface();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE,updateInterface);
			}			
		}*/
		
		/*override public function set x(value:Number):void
		{
			X0 = value; 
			super.x = value ;
		}
		
		override public function set y(value:Number):void
		{
			Y0 = value; 
			super.y = value ;
		}*/
		
		protected function updateInterface(event:Event=null):void
		{
			myTextTF.height = textHeight0 ;
			/*if(!isNaN(X0))
			{
				this.x = X0 ;
				this.y = Y0 ;
			}
			X0 = this.x ;
			Y0 = this.y ;*/
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
				var verticalHeight:Number = 0 ; 
				if(VerticalAlign)
				{
					verticalHeight = H ;
				}
				TextPutter.onTextArea(myTextTF,myText,isArabic,userBitmap && !activateLinks,useCash,captureResolution,align,activateLinks,linkColor,generateLinksForURLs,verticalHeight,splitIfToLong);
				//Debug line ↓
				//TextPutter.onTextArea(myTextTF,myText,isArabic,false,false,1,true) ;
				//	trace("2 add parag on TextParag and its font is : "+myTextTF.defaultTextFormat.font+' added to textParag class : '+myTextTF.text)
				//trace("TextPutter.lastInfo_numLines : "+TextPutter.lastInfo_numLines);
				//trace("!splitIfToLong) : "+(!splitIfToLong));
				//trace("addScroller : "+addScroller);
				if((!splitIfToLong) && addScroller && TextPutter.lastInfo_numLines>1 && TextPutter.lastInfo_realTextHeight>H)//There was 2 instead of 1 here. I don't know why...
				{
					scrollMC = new ScrollMT(forScrollContainer,new Rectangle(forScrollContainer.x,forScrollContainer.y,W,H),new Rectangle(0,0,W,super.height),false,false,scrollEffect) ;
				}
			}
		}
		
		public function increase(newFontSize:int):void
		{
			var textFormat:TextFormat = myTextTF.defaultTextFormat ;
			trace("Old text size : "+textFormat.size);
			textFormat.size = Math.max(0,fontSize0+newFontSize);
			trace("New text size : "+textFormat.size);
			myTextTF.setTextFormat(textFormat);
			myTextTF.defaultTextFormat = textFormat ;
		}
		
		/**You can do this once. no undo available*/
		public function addChildToTop(addedItem:DisplayObject):void
		{
			forScrollContainer.graphics.beginFill(0xff0000,1);
			forScrollContainer.graphics.drawRect(0,0,100,5000);
			for(var i:int = 0 ; i<forScrollContainer.numChildren ;i++)
			{
				var item:DisplayObject = forScrollContainer.getChildAt(i);
				if(item != myTextTF)
				{
					item.y+=addedItem.height ;
				}
			}
			//this.addChild(addedItem);
			addedItem.y = 0 ;
		}
	}
}