package image
{//image.BitmapImage
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class BitmapImage extends MovieClip
	{
		private static var acitvateAnimation:Boolean = true
		private var W:Number=0,
					H:Number=0,
					loadInThisArea:Boolean;
					
		private var _bitmapdata:BitmapData;	
		private var newBitmap:Bitmap;
		
		private var keepImageRatio:Boolean;
		public var id:int;
		override public function get width():Number
		{
			if(W==0)
			{
				return super.width
			}
			return W
				
		}
		override public function get height():Number
		{
			if(H==0)
			{
				return super.height
			}
			return H
		}
		public function BitmapImage()
		{
			super();
		}
		public function setup(Bitmapdata_p:BitmapData,ImageW:Number=0,ImageH:Number=0,ImageX:Number=0,ImageY:Number=0, LoadInThisArea_p:Boolean=false,keepImageRatio_p:Boolean=true):void
		{
			_bitmapdata = Bitmapdata_p
			if(_bitmapdata==null)
			{
				SaffronLogger.log('Bitmapdata is null')
				return
			}
			loadInThisArea = LoadInThisArea_p
			keepImageRatio = keepImageRatio_p
			if(ImageH!=0)
			{
				H = ImageH
			}
			else
			{
				H = super.height
			}
			if(ImageW!=0)
			{
				W = ImageW
			}
			else
			{
				W = super.width
			}
			if(ImageX!=0)
			{
				this.x = ImageX
			}
			if(ImageY!=0)
			{
				this.y = ImageY
			}
			if(this.stage!=null)
			{
				load(null)
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE,load)
			}
		}
		private function load(event:Event=null):void
		{
			clearTheBitmap()
			if(newBitmap)
			{
				newBitmap.bitmapData.dispose()
				Obj.remove(newBitmap)	
			}
			
			var newBitmapData:BitmapData
			if(W!=0 && H!=0)
			{
				newBitmapData = BitmapEffects.changeSize(_bitmapdata,W,H,keepImageRatio,loadInThisArea)
			}
			else
			{
				newBitmapData = _bitmapdata
			}
			newBitmap = new Bitmap(newBitmapData)
			newBitmap.smoothing = true
				
			var imageContainer:Sprite = new Sprite()
			this.addChild(imageContainer)
			imageContainer.addChild(newBitmap)	
				
			if(acitvateAnimation)
			{
				this.alpha = 0
				AnimData.fadeIn(this)	
			}
			this.dispatchEvent(new Event(Event.COMPLETE))
		}
		public function clearTheBitmap():void
		{
			
			if(newBitmap!=null)
			{
				if(newBitmap.bitmapData!=null)
				{
					newBitmap.bitmapData.dispose() ;
				}
			}
		}
		
	}
}