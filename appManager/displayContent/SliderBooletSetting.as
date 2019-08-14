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
		internal var x:Number;
		internal var y:Number;
		
		public function SliderBooletSetting(Color:uint,BooletW:Number=10,BooletMargin:Number = 5,X:Number=NaN,Y:Number=NaN)
		{
			color = Color ;
			booletW = BooletW ;
			booletMargin = BooletMargin ;
			x = X;
			y = Y;
			
		}
	}
}