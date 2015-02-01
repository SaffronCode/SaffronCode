package contents.displayPages
	//contents.displayPages.DynamicPage
{
	import appManager.displayContentElemets.TextParag;
	import appManager.displayContentElemets.TitleText;
	
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
		protected var currentPageData:PageData;
		
		private var myTitle:TitleText ;
		
		private var textTF:TextField ;
		
		private var textContainer:MovieClip ;
		
		private var maskArea:Rectangle ;
		
		private var scrollMC:ScrollMT ;
		
		private var scrollAbleObject:MovieClip ;
		
		public function DynamicPage()
		{
			super();
			scrollAbleObject = new MovieClip();
			
			myTitle = Obj.findThisClass(TitleText,this);
			textContainer = Obj.get("text_txt",this);
			if(textContainer == null)
			{
				textContainer = Obj.findThisClass(TextParag,this,true);
			}
			textTF = Obj.get("text_txt",textContainer);
			textTF.text = '' ;
			
			maskArea = textContainer.getBounds(this).clone();
			trace("maskArea : "+maskArea);
			scrollAbleObject.x = textContainer.x ;
			scrollAbleObject.y = textContainer.y ;
			trace("scrollAbleObject.x : "+scrollAbleObject.x);
			textContainer.x = 0 ;
			textContainer.y = 0 ;
			
			this.addChild(scrollAbleObject);
			scrollAbleObject.addChild(textContainer);
			
			scrollAbleObject.graphics.beginFill(0,0);
			scrollAbleObject.graphics.drawRect(0,0,maskArea.width,maskArea.height);
		}
		
		public function setUp(pageData:PageData):void
		{
			currentPageData = pageData ;
			
			if(myTitle != null)
			{
				myTitle.setUp(currentPageData.title);
			}
			trace("page titel : "+pageData.title);
			trace("textContainer.x : "+textContainer.x);
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
			
			
			if(currentPageData.contentAlign!='' && currentPageData.contentAlign!='0' && currentPageData.contentAlign!=null)
			{
				align = true ;
			}
			trace("align : "+align+' from : '+currentPageData.contentAlign)
			
			TextPutter.onTextArea(textTF,currentPageData.content,true,true,true,0,align);
			trace("Number of imates : "+currentPageData.images.length);
			for(var i = 0 ; i<currentPageData.images.length ; i++)
			{
				var imageData:ImageData = currentPageData.images[i] ;
				trace("image icon is : "+imageData.targURL);
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
				var oneImage:ImageLoader = new ImageLoader(W,H,true,null);
				oneImage.load(imageData.targURL);
				oneImage.x = imageData.x;
				oneImage.y = imageData.y;
				scrollAbleObject.addChild(oneImage)
			}
			scrollMC = new ScrollMT(scrollAbleObject,maskArea,new Rectangle(0,0,maskArea.width,maskArea.height),true);
		}
	}
}