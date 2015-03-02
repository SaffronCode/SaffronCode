package contents.displayPages
	//contents.displayPages.StaticImageText
{
	import appManager.displayContentElemets.ImageBox;
	import appManager.displayContentElemets.TextParag;
	import appManager.displayContentElemets.TitleText;
	
	import contents.PageData;
	import contents.interFace.DisplayPageInterface;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class StaticImageText extends MovieClip implements DisplayPageInterface
	{
		protected var myImage:ImageBox;
		
		protected var myParag:TextParag ;
		
		protected var myTitle:TitleText ;
		
		protected var currentPageData:PageData ;
		
		public function StaticImageText()
		{
			super();
			
			myImage = Obj.findThisClass(ImageBox,this);
			myParag = Obj.findThisClass(TextParag,this);
			myTitle = Obj.findThisClass(TitleText,this);
			
		}
		
		public function setUp(pageData:PageData):void
		{
			trace("*** Data inserted");
			currentPageData = pageData ;
			
			setImage();
			setTitle();
			setText();
		}
		
		protected function setImage():void
		{
			// TODO Auto Generated method stub
			if(myImage != null)
			{
				myImage.setUp(currentPageData.imageTarget);
			}
		}
		
		protected function setTitle():void
		{
			// TODO Auto Generated method stub
			if(myTitle != null)
			{
				myTitle.setUp(currentPageData.title);
			}
		}
		
		protected function setText():void
		{
			// TODO Auto Generated method stub
			if(myParag != null)
			{
				var align:Boolean = false;
				if(currentPageData.contentAlign!='' && currentPageData.contentAlign!='0' && currentPageData.contentAlign!=null)
				{
					align = true ;
				}
				myParag.setUp(currentPageData.content,true,align);
			}
		}
	}
}