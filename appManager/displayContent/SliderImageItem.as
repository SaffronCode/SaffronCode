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
		
		/** load in area*/
		internal var loadInThisArea:Boolean=false;
		
		/**keep ration of light images*/
		public var keepRatio:Boolean = true ;
		
		
		/**Pass url, bitmapData or byteArray for image. pageInterfaceObject class must be a class that extends from SliderElementInterface*/
		public function SliderImageItem(ImageObject:*,Title:String='',Thumbnail:*=null,pageInterfaceObject:SliderElementInterface=null,pageInterfaceData:*=null,KeepRatio:Boolean=true,LoadInThisArea:Boolean=false)
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
			keepRatio = KeepRatio;
			loadInThisArea = LoadInThisArea;
		}
	}
}