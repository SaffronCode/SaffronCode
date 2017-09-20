package contents.displayElements
	//contents.displayElements.SaffronPreLoader
{
	import flash.display.MovieClip;
	
	public class SaffronPreLoader extends MovieClip
	{
		public function SaffronPreLoader()
		{
			super();
		}
		
		override public function set visible(value:Boolean):void
		{
			if(!value)
			{
				Obj.stopAll(this);
			}
			else
			{
				Obj.playAll(this);
			}
			super.visible = value ;
		}
	}
}