package contents.rollingList
	//contents.rollingList.RollingItem
{
	import appManager.displayContentElemets.TitleText;
	import appManager.event.AppEventContent;
	
	import contents.LinkData;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class RollingItem extends MovieClip
	{
		internal var myIndex:uint ;
		
		protected var myTitle:TitleText ;

		protected var myLinkData:LinkData;
		
		public function RollingItem()
		{
			super();
			myTitle = Obj.findThisClass(TitleText,this);
			this.addEventListener(MouseEvent.CLICK,imSelected);
			this.buttonMode = true ;
		}
		
		internal function setIndex(index:uint):void
		{
			myIndex = index ;
		}
		
		public function setUp(linkData:LinkData):void
		{
			myLinkData = linkData ;
			myTitle.setUp(linkData.name,true,false,1);
		}
		
		protected function imSelected(event:MouseEvent):void
		{
			if(myLinkData!=null)
			{
				trace("Dispatch event");
				this.dispatchEvent(new AppEventContent(myLinkData));
			}
		}
	}
}