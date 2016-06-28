package photoEditor
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	public class EditorDefault extends MovieClip
	{
		/**current image bitmapdata in full size(not stretched)*/
		protected var imageFullBitmapData:BitmapData ;
		
		protected var imageRect:Rectangle ; 
		
		/**This is the full image rectange*/
		protected var fullImageAreaRect:Rectangle ;
		
		protected var toolbarRect:Rectangle ;
		
		/**This is the full screen rectangle*/
		protected var fullScreenAreaRect:Rectangle ;
		
		public function EditorDefault()
		{
			fullImageAreaRect = PhotoEdit.mainRectangle;
			imageFullBitmapData = PhotoEdit.image ;
			imageRect = PhotoEdit.imageAreaRectangle().clone();
			toolbarRect = EditorToolbar.toolbarRectArea() ;
			toolbarRect.y+=fullImageAreaRect.height+toolbarRect.height;
			fullScreenAreaRect = PhotoEdit.PageRectangle ;
			
			super();
		}
		
		internal function saveAndClose():void
		{
			//Save requested
			close();
		}
		
		
		internal function close():void
		{
			//Undo or delete requests had to call
			PhotoEdit.resetPhotoPrevew();
			imageFullBitmapData.dispose();
			this.visible = false;
			if(this.parent!=null)
			{
				this.parent.removeChild(this);
			}
		}
	}
}