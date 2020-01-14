package assistant.screenShot
{
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;

	public class ScreenShot
	{
		public function ScreenShot()
		{
			
		}


		public static function shot(stage:Stage,captureRectangle:Rectangle,outputWidth:uint,outputHeight:uint,storeTarget:File):BitmapData
		{
			var caputedBitmap:BitmapData = new BitmapData(outputWidth,outputHeight,false,stage.color);
			
			var resizeMatrix:Matrix = new Matrix();
			resizeMatrix.a = outputWidth/captureRectangle.width;
			resizeMatrix.d = outputHeight/captureRectangle.height;
			resizeMatrix.tx = -captureRectangle.x*resizeMatrix.a ;
			resizeMatrix.ty = -captureRectangle.y*resizeMatrix.d;

			caputedBitmap.draw(stage,resizeMatrix);

			var bitmapFile:ByteArray = BitmapEffects.createJPG(caputedBitmap);
			FileManager.saveFile(storeTarget,bitmapFile);

			return caputedBitmap ;
		}
	}
}