package appManager.displayContentElemets
{
	import flash.events.Event;
	
	public class ImageEvent extends Event
	{
		public static const IMAGE_SELECTED:String = "IMAGE_SELECTED" ;
		
		public var url:String ;
		
		/***/
		public function ImageEvent(type:String,imageTarget:String)
		{
			super(type,true);
			url = imageTarget ;
		}
	}
}