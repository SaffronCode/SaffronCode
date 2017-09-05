package contents.rollingList
	//contents.rollingList.RollingItem
{
	import appManager.displayContentElemets.TitleText;
	
	public class RollingItem extends TitleText
	{
		internal var myIndex:uint ;
		
		public function RollingItem()
		{
			super();
		}
		
		internal function setIndex(index:uint):void
		{
			myIndex = index ;
		}
	}
}