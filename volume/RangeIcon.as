package volume
{//volume.RangeIcon
	import appManager.displayContentElemets.TitleText;
	
	import flash.display.MovieClip;
	
	public class RangeIcon extends MovieClip
	{
		private var titleMc:TitleText;
		public function RangeIcon()
		{
			super();
			titleMc = Obj.findThisClass(TitleText,this)
		}
		public function setup(title_p:String=null):void
		{
			if(titleMc!=null && title_p!=null)
			{
				titleMc.setUp(title_p)
			}
		}
	}
}