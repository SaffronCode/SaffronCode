package appManager.displayContent
	//appManager.displayContent.SliderThumbnail
{
	import appManager.displayContentElemets.LightImage;
	
	import flash.display.MovieClip;

	public class SliderThumbnail extends MovieClip 
	{
		private var myImageArea:LightImage ;
		
		public function SliderThumbnail()
		{
			super();
			myImageArea = Obj.findThisClass(LightImage,this,true);
		}
	}
}