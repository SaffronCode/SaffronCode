package popForm
{
	import flash.display.MovieClip;
	
	/**The data value is changed*/
	[Event(name="change", type="flash.events.Event")]
	internal class PopFieldInterface extends MovieClip
	{
		public function PopFieldInterface()
		{
			super();
		}
		
		public function update(data:*):void
		{
			
		}
		
		public function get title():String
		{
			return '' ;
		}
		
		public function get data():*
		{
			return null ;
		}
	}
}