package appManager.displayContentElemets
	//appManager.displayContentElemets.BoxImage
{
	public class BoxImage extends ImageBox
	{
		public function BoxImage()
		{
			super();
		}
		
		/**The difrence between ImageBox ans BoxImage is that ImageBox is load the image inside of the area but the BoxImage loads image Bigger than its area.*/
		override public function setUp(imageURL:String, loadInThisArea:Boolean=false, imageW:Number=0, imageH:Number=0, X:Number=0, Y:Number=0):*
		{
			super.setUp(imageURL, loadInThisArea, imageW, imageH, X, Y);
		}
	}
}