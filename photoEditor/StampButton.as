package photoEditor
	//photoEditor.StampButton
{
	import appManager.displayContentElemets.LightImage;
	
	import flash.display.MovieClip;
	import flash.filesystem.File;
	
	public class StampButton extends MovieClip
	{
		private var stampImage:LightImage ; 
		
		public var myFile:File ;
		
		public function StampButton()
		{
			super();
			
			stampImage = Obj.get("image_mc",this);
		}
		
		public function load(imageFile:File):void
		{
			myFile = imageFile ;
			stampImage.setUp(imageFile.nativePath,true);
		}
	}
}