package contents.displayPages
	//contents.displayPages.DynamicPage
{
	import appManager.displayContentElemets.LightImage;
	import appManager.displayContentElemets.TextParag;
	import appManager.displayContentElemets.TitleText;
	
	import com.mteamapp.StringFunctions;
	
	import contents.Contents;
	import contents.ImageData;
	import contents.PageData;
	import contents.interFace.DisplayPageInterface;
	
	import flash.display.MovieClip;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import netManager.ImageLoader;
	
	public class DynamicPage extends MovieClip implements DisplayPageInterface
	{
		private var activateHTMLLink:Boolean = false,
					generateURLLink:Boolean=true,
					linkColor:int=-1;
		
		protected var fullImageShow:Boolean = true ;
		
		/**This will prevent text to be bitmap to make it selectable by <a/> link*/
		public function activateHTMLLinks(LinkColor:int = -1,generateURLLinks:Boolean=true):void
		{
			activateHTMLLink = true ;
			generateURLLink = generateURLLinks ;
			linkColor = LinkColor ;
		}
		
		protected var currentPageData:PageData;
		
		private var myTitle:TitleText ;
		
		protected var textTF:TextField ;
		
		protected var textContainer:MovieClip ;
		
		protected var maskArea:Rectangle ;
		
		private var scrollMC:ScrollMT ;
		
		private var scrollAbleObject:MovieClip ;
		
		private static var addWatermark:Boolean = true ;
		
		public function DynamicPage()
		{
			super();
			scrollAbleObject = new MovieClip();
			this.addChild(scrollAbleObject);
			
			myTitle = Obj.findThisClass(TitleText,this);
			textContainer = Obj.get("text_txt",this);
			if(textContainer == null)
			{
				textContainer = Obj.findThisClass(TextParag,this,true);
			}
			
			if(textContainer!=null)
			{
				textTF = Obj.get("text_txt",textContainer) ;
				textTF.text = '' ;
				maskArea = textContainer.getBounds(this).clone() ;
				
				scrollAbleObject.x = textContainer.x ;
				scrollAbleObject.y = textContainer.y ;
				textContainer.x = 0 ;
				textContainer.y = 0 ;
				//scrollAbleObject.addChild(textContainer);
			}
			else
			{
				maskArea = new Rectangle(0,0,this.width,this.height);
			}
			resetScrollAreaInterface();
		}
		
		private function resetScrollAreaInterface():void
		{
			scrollAbleObject.removeChildren();
			if(textContainer)
			{
				scrollAbleObject.addChild(textContainer);	
			}
			//trace("scrollAbleObject.x : "+scrollAbleObject.x);
			
			
			scrollAbleObject.graphics.clear();
			scrollAbleObject.graphics.beginFill(0,0);
			scrollAbleObject.graphics.drawRect(0,0,maskArea.width,maskArea.height);
		}
		
		override public function set height(value:Number):void
		{
			maskArea.height = value ;
		}
		
		public function setUp(pageData:PageData):void
		{
			currentPageData = pageData ;
			
			
			
			if(scrollMC)
			{
				scrollMC.unLoad();
			}
			
			if(myTitle != null)
			{
				myTitle.setUp(currentPageData.title);
			}
			
			if(textContainer!=null && textTF!=null)
			{
				if(!isNaN(currentPageData.contentX))
				{
					textContainer.x = currentPageData.contentX ;
				}
				if(!isNaN(currentPageData.contentY))
				{
					textContainer.y = currentPageData.contentY ;
				}
				if(!isNaN(currentPageData.contentW))
				{
					textTF.width = currentPageData.contentW ;
				}
				var align:Boolean = false ;
				
				
				if(currentPageData.contentAlign!='' && currentPageData.contentAlign!='0' && currentPageData.contentAlign!='false' && currentPageData.contentAlign!=null)
				{
					align = true ;
				}
				//trace("align : "+align+' from : '+currentPageData.contentAlign)
				var pageContent:String = currentPageData.content ;
				if(activateHTMLLink)
				{
					if(generateURLLink && pageContent.indexOf('<a')==-1)
					{
						pageContent = StringFunctions.generateLinks(pageContent);
					}
					pageContent = StringFunctions.htmlCorrect(pageContent,linkColor);
				}
				TextPutter.onTextArea(textTF,pageContent,true,!activateHTMLLink,true,1,align);
			}
			//trace("Number of imates : "+currentPageData.images.length);
			for(var i = 0 ; i<currentPageData.images.length ; i++)
			{
				var imageData:ImageData = currentPageData.images[i] ;
				//trace("image icon is : "+imageData.targURL);
				var H:Number = 0 ,
					W:Number = 0;
				if(!isNaN(imageData.width))
				{
					W = imageData.width ;
				}
				if(!isNaN(imageData.height))
				{
					H = imageData.height ;
				}
				var oneImage:LightImage = new LightImage();
				oneImage.watermark = addWatermark ;
				oneImage.setUp(imageData.targURL,fullImageShow,W,H,imageData.x,imageData.y);
				//trace(i+"imageData.y : "+imageData.y);
				//oneImage.x = imageData.x;
				//oneImage.y = imageData.y;
				scrollAbleObject.addChild(oneImage)
			}
			scrollMC = new ScrollMT(scrollAbleObject,maskArea,new Rectangle(0,0,maskArea.width,maskArea.height),true);
			
		}
		
		public static function dontAddWaterMarks():void
		{
			addWatermark = false ;
		}
	}
}