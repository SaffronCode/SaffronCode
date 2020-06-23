package appManager.displayContentElemets
	//appManager.displayContentElemets.TextParag
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import mteam.FuncManager;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import darkBox.DarkBox;
	import darkBox.ImageFile;
	

	
	public class TextParag extends MovieClip
	{
		public var myTextTF:TextField ;
		
		private var H:Number,
					W:Number ;
					
		//private var textHeight0:Number ;
		
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
		private var textSplitter:String ;
		private var imagesList:Array ;
		
		private var forScrollContainer:Sprite ;

		private var splitedParags:Vector.<Sprite>,
					splitedTextsInSprite:Vector.<TextField>,
					lightImagesList:Vector.<LightImage> ;
		
		public function getTextField():TextField
		{
			return myTextTF ;
		}
		
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
			
			//textHeight0 = myTextTF.height ;
			
			H = super.height+moreHight ;
			W = super.width ;
			//Removed for debug
			//myTextTF.text = '' ;
			//Added for debug
				//SaffronLogger.log(myTextTF.getTextFormat().font+' added to textParag class') ;
				
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
		
		/**
		 * You can pass HTML texts like below:
		 * <font color="#ff0000">text</font>
		 * or
		 * [[font color="ff0000"]]text[[/font]]
		 */
		public function setUp(myText:String,isArabic:Boolean = true,align:Boolean=true,knownAsHTML:Boolean=false,activateLinks:Boolean=false,useNativeText:Boolean=false,addScroller:Boolean=true,generateLinksForURLs:Boolean=false,scrollEffect:Boolean=true,userBitmap:Boolean=true,VerticalAlign:Boolean=false,useCash:Boolean=false,captureResolution:uint=0,splitIfToLong:Boolean=false,
								textSplitter:String=null,imagesList:Array=null):void
		{
			if(textSplitter=='')
			{
				textSplitter = null ;
			}

			if(myText==null)
			{
				myText = '' ;
			}

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
			this.textSplitter = textSplitter ;
			this.imagesList = imagesList ;
			
			//updateItCan();
			updateInterface();
		}

		protected function updateInterface(event:Event=null):void
		{
			//myTextTF.height = textHeight0 ;
			/*if(!isNaN(X0))
			{
				this.x = X0 ;
				this.y = Y0 ;
			}
			X0 = this.x ;
			Y0 = this.y ;*/
			//This event dispatches to remove old scrollMC class
			this.dispatchEvent(new Event(Event.REMOVED_FROM_STAGE)) ;
			var i:int ;
			if(nativeText)
			{
				nativeText.unLoad();
			}
			if(splitedParags!=null && splitedParags.length>0)
			{
				for(i = 0 ; i<splitedParags.length ; i++)
				{
					forScrollContainer.removeChild(splitedParags[i]);
				}
				splitedParags = null ;
			}
			if(scrollMC)
			{
				scrollMC.setPose(0, 0);
				scrollMC.unLoad();
			}
			if(useNativeText)
			{
				myTextTF.text = UnicodeStatic.KaafYe(myText) ;
				SaffronLogger.log("myTextTF.text : "+myTextTF.text);
				nativeText = FarsiInputCorrection.setUp(myTextTF,null,true,true,false,true,false);
				SaffronLogger.log("Farsi input created for this text to make it native");
			}
			else
			{
				//SaffronLogger.log("1 add parag on TextParag and its font is : "+myTextTF.defaultTextFormat.font+' added to textParag class')
				//TextPutter.onTextArea(myTextTF,myText,isArabic,true,true,1,align,knownAsHTML) ;
				//TextPutter.onTextArea(myTextTF,myText,isArabic,!activateLinks,false,0,align,knownAsHTML,-1);
				var verticalHeight:Number = 0 ; 
				if(VerticalAlign)
				{
					verticalHeight = H ;
				}
				
				var texts:Array ;
				if(textSplitter==null)
				{
					texts = [myText];
				}
				else
				{
				 	texts = myText.split(textSplitter) ;
					splitedParags = new Vector.<Sprite>() ;
					splitedTextsInSprite = new Vector.<TextField>();
				}
				setTextPutter(myTextTF,texts[0],false);
				//TextPutter.onTextArea(myTextTF,texts[0],isArabic,userBitmap && !activateLinks,useCash,captureResolution,align,activateLinks,linkColor,generateLinksForURLs,verticalHeight,splitIfToLong);
				var Y:Number = myTextTF.height ;
				var Y0:Number = myTextTF.height ;
				for(i = 1 ; i<texts.length ; i++)
				{
					var nextParag:TextField = Obj.copyTextField(myTextTF,false);
					var paragContainer:Sprite = new Sprite();
					paragContainer.addChild(nextParag);
					forScrollContainer.addChild(paragContainer);
					paragContainer.y = Y ;
					splitedParags.push(paragContainer);
					splitedTextsInSprite.push(nextParag);
					setTextPutter(nextParag,texts[i]);
					Y+=nextParag.height;
				}

				function setTextPutter(myTextTF:TextField,text:String,activateAsync:Boolean=true):void
				{
					if(activateAsync)
					{
						FuncManager.callAsyncOnFrame(enterParagText);
					}
					else
					{
						enterParagText();
					}
					function enterParagText():void
					{
						TextPutter.onTextArea(myTextTF,text,isArabic,userBitmap,useCash,captureResolution,align,activateLinks || knownAsHTML,linkColor,generateLinksForURLs,verticalHeight,splitIfToLong);
						updateImagePositions(null);
					}
				}

				if(imagesList!=null)
				{
					lightImagesList = new Vector.<LightImage>();
					for(i=0 ; i<imagesList.length ; i++)
					{
						var image:LightImage = new LightImage();
						//image.animated = false ;
						setImage(image,imagesList[i]);
						image.addEventListener(Event.COMPLETE,updateImagePositions);
						image.y = Y0 ;
						forScrollContainer.addChild(image);
						if(texts.length>i)
						{
							var link:String = getLastLinkOfParag(texts[i]);
							//if(link!=null)
							//{
								//Alert.show('link founded : '+link);
								setLinkForImage(image,link,imagesList[i]);
							//}
						}
						lightImagesList.push(image);
					}
				}

				function setImage(theImage:LightImage,imageLocation:String):void
				{
					FuncManager.callAsyncOnFrame(setUpImage);
					function setUpImage():void
					{
						theImage.setUp(imageLocation,true,myTextTF.width,0,0,0,true);
					}
				}
				
				//Debug line ↓
				//TextPutter.onTextArea(myTextTF,myText,isArabic,false,false,1,true) ;
				//	SaffronLogger.log("2 add parag on TextParag and its font is : "+myTextTF.defaultTextFormat.font+' added to textParag class : '+myTextTF.text)
				//SaffronLogger.log("TextPutter.lastInfo_numLines : "+TextPutter.lastInfo_numLines);
				//SaffronLogger.log("!splitIfToLong) : "+(!splitIfToLong));
				//SaffronLogger.log("addScroller : "+addScroller);
				if(
					(
						!splitIfToLong
					) 
					&& 
					addScroller 
					&& 
					(
						(
							TextPutter.lastInfo_numLines>1 
							&& 
							TextPutter.lastInfo_realTextHeight>H
						) 
						|| 
						Y>H 
						|| 
						imagesList!=null
					)
				)//There was 2 instead of 1 here. I don't know why...
				{
					scrollMC = new ScrollMT(forScrollContainer,new Rectangle(0,0,W,H),null,true,false,scrollEffect) ;
				}
			}
		}


		private function getLastLinkOfParag(paragraph:String):String
		{
			paragraph = paragraph.split('[[').join('<').split(']]').join('>');
			var linkStarted:int = paragraph.lastIndexOf('<a');
			if(linkStarted!=-1)
			{
				var linkEnded:int = paragraph.lastIndexOf('</a');
				//Alert.show("Link first <a> founced");
				if(linkEnded<linkStarted)
				{
					//Alert.show("Yes yes");
					//Activate link
					var linkContainerPart:String = paragraph.substring(linkStarted);
					var hrefFinder:RegExp = /<a[\s]+href=['"][^'^"]*['"]/gi;
					var links:Array = linkContainerPart.match(hrefFinder);
					if(links.length>0)
					{
						//Alert.show('matches');
						var linkIsHere:String = String(links[0]).toLowerCase();
						linkIsHere = linkIsHere.substring(linkIsHere.lastIndexOf('href=')+6,linkIsHere.length-1);
						SaffronLogger.log("Link is : "+linkIsHere);
						return linkIsHere ;
					}
				}
			}
			return null ;
		}

		private function setLinkForImage(image:LightImage,link:String,imageLocation:String):void
		{
			image.buttonMode = true ;
			image.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void
			{
				if(link!=null)
					navigateToURL(new URLRequest(link));
				else
					DarkBox.showSingleImage(new ImageFile(imageLocation,'',ImageFile.TYPE_FLAT,true));
			})
		}

		private function updateImagePositions(e:Event):void
		{
			var paragL:uint = splitedParags==null?0:splitedParags.length ;
			var imageL:uint = lightImagesList==null?0:lightImagesList.length ;
			var maxL:uint = Math.max(imageL,paragL) ;
			var Y:Number;
			if(lightImagesList!=null && lightImagesList.length>0)
			{
				lightImagesList[0].y = myTextTF.textHeight ;
			 	Y = lightImagesList[0].y+lightImagesList[0].height ;
			}
			else
			{
				Y = myTextTF.textHeight ;
			}
			for(var i:int = 0 ; i<maxL ; i++)
			{
				if(paragL>i)
				{
					splitedParags[i].y = Y ;
					Y += splitedTextsInSprite[i].textHeight ;
				}
				if(imageL>i+1)
				{
					lightImagesList[i+1].y = Y ;
					Y += lightImagesList[i+1].height ;
				}
			}
		}
		
		public function increase(newFontSize:int,updateInterfaceInstantly:Boolean=false):void
		{
			var textFormat:TextFormat = myTextTF.defaultTextFormat ;
			SaffronLogger.log("Old text size : "+textFormat.size);
			textFormat.size = Math.max(0,fontSize0+newFontSize);
			SaffronLogger.log("New text size : "+textFormat.size);
			myTextTF.setTextFormat(textFormat);
			myTextTF.defaultTextFormat = textFormat ;
			if(updateInterfaceInstantly)
				updateInterface();
		}

		public function changeFontSize(newFontSize:int,updateInterfaceInstantly:Boolean=false):void
		{
			var textFormat:TextFormat = myTextTF.defaultTextFormat ;
			textFormat.size = newFontSize;
			myTextTF.setTextFormat(textFormat);
			myTextTF.defaultTextFormat = textFormat ;
			if(updateInterfaceInstantly)
				updateInterface();
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