/***Version 1.1- all gallery items can inserts in ImageBoxes here.
 * 
 * 
 * 
 */

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
		
		protected var imageArr:Array ;
		
		protected var myParag:TextParag ;
		
		protected var myTitle:TitleText ;
		
		protected var currentPageData:PageData ;
		
		public function StaticImageText()
		{
			super();
			
			imageArr = Obj.findAllClass(ImageBox,this);
			if(imageArr.length != 0)
			{
				myImage = imageArr[0] ;
			}
			myParag = Obj.findThisClass(TextParag,this);
			myTitle = Obj.findThisClass(TitleText,this);
			
		}
		
		public function setUp(pageData:PageData):void
		{
			currentPageData = pageData ;
			
			setImage();
			setTitle();
			setText();
		}
		
		protected function setImage():void
		{
			// TODO Auto Generated method stub
			var i:int = 0 ;
			if(myImage != null && currentPageData.imageTarget!='')
			{
				myImage.setUp(currentPageData.imageTarget);
				i++;
			}
			for(i ; i<currentPageData.images.length && i<imageArr.length ; i++)
			{
				(imageArr[i] as ImageBox).setUp(currentPageData.images[i].targURL)
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
				myParag.setUp(currentPageData.content);
			}
		}
	}
}