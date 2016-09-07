package appManager.displayContent
	//appManager.displayContent.SliderController_thumbnails	
{
	import flash.desktop.Icon;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class SliderController_thumbnails extends MovieClip
	{
		private var thumbnailClass:Class ;
		
		private var thumbs:Vector.<SliderThumbnail> ;
		
		private var thumbnailsContainer:Sprite ;
		
		private var W:Number,H:Number;
		
		private var scroller:ScrollMT ;
		
		private var mySlider:SliderGallery ;
		
		private var myImages:Vector.<SliderImageItem> ;
		
		private var iconLoaderDelay:uint = 100 ;
		
		private var loadedImageIndex:uint ;
		
		public function SliderController_thumbnails()
		{
			super();
			
			//Init
			W = super.width ;
			H = super.height ;
			
			var thumbSample:SliderThumbnail = Obj.findThisClass(SliderThumbnail,this);
			thumbnailClass = Obj.getObjectClass(thumbSample) ;
			
			this.removeChildren();
			
			//Create new Objects
			
			thumbnailsContainer = new Sprite();
			resetThumbnailcontainer();
			this.addChild(thumbnailsContainer);
			
			scroller = new ScrollMT(thumbnailsContainer,new Rectangle(0,0,W,H),null,false,true);
		}
		
		private function resetThumbnailcontainer():void
		{
			thumbnailsContainer.removeChildren();
			thumbnailsContainer.graphics.clear();
			thumbnailsContainer.graphics.beginFill(0xff0000,1);
			thumbnailsContainer.graphics.drawRect(0,0,W,H);
		}
		
			override public function get width():Number
			{
				return W ;
			}
			
			override public function get height():Number
			{
				return H ;
			}
			
		public function setUp(images:Vector.<SliderImageItem>,sliderDispalObject:SliderGallery,currentIndex:uint = 0 ,animateTimer:uint = 10000 ):void
		{
			resetThumbnailcontainer();
			
			mySlider = sliderDispalObject ;
			myImages = images ;
			
			mySlider.setUp(myImages,currentIndex,animateTimer);
			
			startLoadingIcons();
		}
		
		private function startLoadingIcons():void
		{
			thumbs = new Vector.<SliderThumbnail>();
			loadedImageIndex = 0 ;
			
			addNextIcon();
		}
		
		private function addNextIcon():void
		{
			var icon:SliderThumbnail = new thumbnailClass();
			
			thumbnailsContainer.addChild(icon);
			I was here
		}
	}
}