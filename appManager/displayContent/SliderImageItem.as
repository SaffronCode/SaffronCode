package appManager.displayContent
{
	public class SliderImageItem
	{
		/**This can be a bitmapData or url or ByteArray*/
		internal var image:* ;
		
		internal var title:String ;
		
		/**This is like image*/
		internal var thumbnail:* ;
		
		/**Pass url, bitmapData or byteArray for image*/
		public function SliderImageItem(ImageObject:*,Title:String='',Thumbnail:*=null)
		{
			image = ImageObject ;
			if(Thumbnail==null)
			{
				Thumbnail = image ;
			}
			thumbnail = Thumbnail ;
			title = Title ;
		}
	}
}