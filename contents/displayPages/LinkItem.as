package contents.displayPages
	//contents.displayPages.LinkItem
{
	import appManager.displayContentElemets.ImageBox;
	import appManager.displayContentElemets.TextParag;
	import appManager.displayContentElemets.TitleText;
	import appManager.event.AppEvent;
	import appManager.event.AppEventContent;
	
	import contents.LinkData;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**You can trigger me by calling imSelected function*/
	public class LinkItem extends MovieClip
	{
		private var myImage:ImageBox;
		
		private var myTitle:TitleText ;
		
		private var myParag:TextParag ;
		
		protected var myLinkData:LinkData ;
		
		public function LinkItem()
		{
			super();
			
			myImage = Obj.findThisClass(ImageBox,this) as ImageBox;
			myTitle = Obj.findThisClass(TitleText,this) as TitleText;
			myParag = Obj.findThisClass(TextParag,this);
			
			this.mouseChildren = false ;
			this.addEventListener(MouseEvent.CLICK,imSelected);
		}
		
		/**Set up the page*/
		public function setUp(linkData:LinkData):void
		{
			myLinkData = linkData ;
			
			if(myImage!=null)
			{
				myImage.setUp(linkData.iconURL);
			}
			if(myTitle!=null)
			{
				myTitle.setUp(linkData.name);
			}
			else if(myParag!=null)
			{
				myParag.setUp(linkData.name);
			}
		}
		
		public function imSelected(event:MouseEvent=null):void
		{
			// TODO Auto-generated method stub
			if(myLinkData!=null)
			{
				this.dispatchEvent(new AppEventContent(myLinkData));
			}
		}
	}
}