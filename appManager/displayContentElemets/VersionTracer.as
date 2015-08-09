package appManager.displayContentElemets
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class VersionTracer extends MovieClip
	{
		private var tf:TextField ;
		
		public function VersionTracer()
		{
			super();
			
			tf = Obj.findThisClass(TextField,this,true);
			if(tf)
			{
				tf.text = DevicePrefrence.appVersion ;
			}
		}
	}
}