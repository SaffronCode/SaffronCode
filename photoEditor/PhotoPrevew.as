package photoEditor
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	internal class PhotoPrevew extends MovieClip
	{
		private var bit:Bitmap ;
		
		private var imageRectangle:Rectangle ;
		
		public function PhotoPrevew(bitmapData:BitmapData)
		{
			super();
			
			bit = new Bitmap(bitmapData)
			bit.smoothing = true ;
			
			var W:Number = bitmapData.width;
			var H:Number = bitmapData.height;
			
			var mainPageRect:Rectangle = PhotoEdit.mainRectangle ;
			
			var scale:Number = Math.min(mainPageRect.width/W,mainPageRect.height/H);
			
			bit.scaleX = bit.scaleY = scale ;
			
			bit.x = (mainPageRect.width-bit.width)/2;
			bit.y = (mainPageRect.height-bit.height)/2;
			
			this.addChild(bit);
			
			imageRectangle = new Rectangle(bit.x,bit.y,bit.width,bit.height);
			
			this.alpha = 0 ;
			AnimData.fadeIn(this);
		}
		
		/**Kill this image*/
		public function killMe():void
		{
			AnimData.fadeOut(this,deleteMe);
		}
		
		private function deleteMe():void
		{
			if(this.parent!=null)
			{
				this.parent.removeChild(this);
			}
		}
		
		public function imageRect():Rectangle
		{
			// TODO Auto Generated method stub
			return imageRectangle.clone();
		}
		
		public function crop(rs:Rectangle):BitmapData
		{
			rs.x-=imageRectangle.x;
			rs.y-=imageRectangle.y;
			
			// TODO Auto Generated method stub
			var orginalBitmap:BitmapData = bit.bitmapData ;
			
			trace("orginalBitmap vs bit : "+orginalBitmap.width+' vs '+bit.width);
			var scale:Number = bit.scaleX ;
			rs.width = rs.width/scale ;
			rs.height = rs.height/scale ;
			rs.x = rs.x/scale ;
			rs.y = rs.y/scale ;
			
			trace("bit scale is : "+bit.scaleX);
			var croppedBitmap:BitmapData = new BitmapData(rs.width,rs.height,true,0x00000000);
			var cropMatrix:Matrix = new Matrix(1,0,0,1,-rs.x,-rs.y);
			croppedBitmap.draw(orginalBitmap,cropMatrix);
			return croppedBitmap;
		}
	}
}