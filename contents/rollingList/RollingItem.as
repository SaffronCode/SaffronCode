package contents.rollingList
	//contents.rollingList.RollingItem
{
	import appManager.displayContentElemets.TitleText;
	
	import contents.LinkData;
	
	import flash.display.MovieClip;
	
	public class RollingItem extends MovieClip
	{
		internal var myIndex:uint ;
		
		private var myTitle:TitleText ;
		
		public function RollingItem()
		{
			super();
			myTitle = Obj.findThisClass(TitleText,this);
		}
		
		internal function setIndex(index:uint):void
		{
			myIndex = index ;
		}
		
		public function setUp(linkData:LinkData):void
		{
			myTitle.setUp(linkData.name,true,false,1);
		}
	}
}