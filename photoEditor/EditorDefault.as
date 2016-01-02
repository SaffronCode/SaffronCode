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
		
		protected var fullScreenRect:Rectangle ;
		
		protected var toolbarRect:Rectangle ;
		
		public function EditorDefault()
		{
			fullScreenRect = PhotoEdit.mainRectangle.clone();
			imageFullBitmapData = PhotoEdit.image ;
			imageRect = PhotoEdit.imageAreaRectangle().clone();
			toolbarRect = EditorToolbar.toolbarRectArea() ;
			toolbarRect.y+=fullScreenRect.height+toolbarRect.height;
			
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