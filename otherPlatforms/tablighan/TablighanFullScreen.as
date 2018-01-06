package otherPlatforms.tablighan
	//otherPlatforms.tablighan.TablighanFullScreen
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import picContest.PicConst;
	
	public class TablighanFullScreen extends TablighanBanner
	{
		private var closeMC:MovieClip ;
		
		public function TablighanFullScreen()
		{
			closeMC = Obj.findThisClass(MovieClip,this);
			super();
		}
		
		/*override protected function updateMyPlace(event:Event):void
		{
			if(mySW.isLoaded)
			{
				mySW.sw.stage = this.stage ;
				var areaRect:Rectangle = PicConst.stageDeltaRect ; 
				mySW.sw.viewPort = areaRect ;
			}
		}*/
	}
}