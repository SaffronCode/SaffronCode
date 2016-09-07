package appManager.displayContent
{
	public class SliderImageItem
	{
		/**This can be a bitmapData or url or ByteArray*/
		internal var image:* ;
		
		internal var title:String ;
		
		/**Pass url, bitmapData or byteArray for image*/
		public function SliderImageItem(ImageObject:*,Title:String='',thumbnail:*=null)
		{
			image = ImageObject ;
			if(thumbnail==null)
			{
				thumbnail = image ;
			}
			title = Title ;
		}
	}
}