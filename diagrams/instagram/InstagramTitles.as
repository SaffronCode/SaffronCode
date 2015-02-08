package diagrams.instagram
{
	/**This class is generated to generate diagram titles both vertical and horizontals*/
	public class InstagramTitles
	{
		/**↨*/
		public var vTitle:Vector.<InstaTitleValue> ;
		/**↔*/
		public var hTitle:Vector.<InstaTitleValue> ;
		
		public function InstagramTitles()
		{
			 vTitle = new Vector.<InstaTitleValue>();
			 hTitle = new Vector.<InstaTitleValue>();
		}
		
		/**↔ Repeated titles will override*/
		public function addHTitle(title:InstaTitleValue):void
		{
			for(var i = 0 ; i< hTitle.length && title>hTitle[i] ; i++){}
			var replcate = (hTitle.length>i && title.value == hTitle[i].value)?1:0;
			hTitle.splice(i,replcate,title);
		}
		
		/**↨ Repeated titles will override*/
		public function addVTitle(title:InstaTitleValue):void
		{
			for(var i = 0 ; i< vTitle.length && title>vTitle[i] ; i++){}
			var replcate = (vTitle.length>i && title.value == vTitle[i].value)?1:0;
			vTitle.splice(i,replcate,title);
		}
		
		/**This function will return the closest vTitle to this value with this step*/
		public function getVName(vStepValTemp:Number, steps:Number):InstaTitleValue
		{
			// TODO Auto Generated method stub
			for(var i = 0 ; i<vTitle.length ; i++)
			{
				if(Math.abs(vTitle[i].value-vStepValTemp)<steps)
				{
					return vTitle[i];
				}
			}
			return null;
		}
	}
}