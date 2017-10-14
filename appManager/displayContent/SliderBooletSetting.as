package appManager.displayContent
{
	public class SliderBooletSetting
	{
		internal var color:uint ;
		
		internal var sliderGallery:SliderGallery ;
		
		internal var maximomWidth:Number ;
		internal var booletW:Number ;
		internal var booletMargin:Number ;
		internal var rtl:Boolean;
		
		public function SliderBooletSetting(Color:uint,BooletW:Number=10,BooletMargin:Number = 5)
		{
			color = Color ;
			booletW = BooletW ;
			booletMargin = BooletMargin ;
		}
	}
}