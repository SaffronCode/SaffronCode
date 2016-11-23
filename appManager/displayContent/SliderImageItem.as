package appManager.displayContent
{
	import contents.interFace.PageContentBaseClass;

	public class SliderImageItem
	{
		/**This can be a bitmapData or url or ByteArray*/
		internal var image:* ;
		
		internal var title:String ;
		
		/**This is like image*/
		internal var thumbnail:* ;
		
		internal var data:* ;
		
		/**Must extends from SliderElementInterface*/
		internal var pageInterface:SliderElementInterface ;
		
		/**Pass url, bitmapData or byteArray for image. pageInterfaceObject class must be a class that extends from SliderElementInterface*/
		public function SliderImageItem(ImageObject:*,Title:String='',Thumbnail:*=null,pageInterfaceObject:SliderElementInterface=null,pageInterfaceData:*=null)
		{
			image = ImageObject ;
			if(Thumbnail==null)
			{
				Thumbnail = image ;
			}
			thumbnail = Thumbnail ;
			title = Title ;
			
			pageInterface = pageInterfaceObject ;
			data = pageInterfaceData ;
		}
	}
}