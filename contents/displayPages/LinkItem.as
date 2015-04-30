package contents.displayPages
	//contents.displayPages.LinkItem
{
	import appManager.displayContentElemets.Image;
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
		protected var myImage:Image;
		
		protected var myTitle:TitleText ;
		
		protected var myParag:TextParag ;
		
		public var myLinkData:LinkData ;
		
		public function LinkItem()
		{
			super();
			
			myImage = Obj.findThisClass(Image,this) as Image;
			myTitle = Obj.findThisClass(TitleText,this) as TitleText;
			//trace("founded text title is : "+myTitle)
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