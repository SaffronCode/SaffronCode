package appManager.displayContent
	//appManager.displayContent.SliderController_thumbnails	
{
	import flash.desktop.Icon;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
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
		
		/**thumbnail icon width*/
		private var iconW:Number,
					iconDeltaY:Number = 5;
					
		private var myTimeOutId:uint;
		private var myPreloader:MovieClip;
		
		/**The icon animations are in the SliderThumnail class*/
		public function SliderController_thumbnails()
		{
			super();
			
			//Init
			W = super.width ;
			H = super.height ;
			
			var thumbSample:SliderThumbnail = Obj.findThisClass(SliderThumbnail,this);
			iconW = thumbSample.width ;
			thumbnailClass = Obj.getObjectClass(thumbSample) ;
			
			this.removeChildren();
			
			//Create new Objects
			
			thumbnailsContainer = new Sprite();
			resetThumbnailcontainer();
			this.addChild(thumbnailsContainer);
			
			scroller = new ScrollMT(thumbnailsContainer,new Rectangle(0,0,W,H),null,false,true);
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
		}
		
		protected function unLoad(event:Event):void
		{
			clearTimeout(myTimeOutId);
			mySlider.removeEventListener(Event.CHANGE,resetAllIconsPoseAndSizes);
		}
		
		/**Remove all thumbnails from the container*/
		private function resetThumbnailcontainer():void
		{
			thumbnailsContainer.removeChildren();
			thumbnailsContainer.graphics.clear();
			thumbnailsContainer.graphics.beginFill(0xff0000,0);
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
			
		public function setUp(images:Vector.<SliderImageItem>,sliderDispalObject:SliderGallery,currentIndex:uint = 0 ,animateTimer:uint = 10000 ,PreLoaderDisplayObject:MovieClip=null):void
		{
			resetThumbnailcontainer();
			
			myPreloader = (PreLoaderDisplayObject!=null)?PreLoaderDisplayObject:new MovieClip() ;
			mySlider = sliderDispalObject ;
			myImages = images ;
			
			mySlider.setUp(myImages,currentIndex,animateTimer);
			
			mySlider.addEventListener(Event.CHANGE,resetAllIconsPoseAndSizes);
			
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
			var iconX:Number = getIconX(loadedImageIndex,getHowMuchIconsShouldGoForward(loadedImageIndex));
			var iconY:Number = H/2 ;
			var icon:SliderThumbnail = new thumbnailClass(iconX,iconY,0.5,0);
				icon.Scale0 = 1 ;
				icon.Alpha0 = 1 ;
			thumbs.push(icon);
			
			icon.addEventListener(Event.COMPLETE,currentIconIsReadyForTheNext);
			thumbnailsContainer.addChild(icon);
			icon.setUp(myImages[loadedImageIndex].thumbnail,loadedImageIndex,myPreloader);
			//Repose all icons
			resetAllIconsPoseAndSizes();
			
			icon.addEventListener(MouseEvent.CLICK,iconSelected);
		}
		
		protected function iconSelected(event:MouseEvent):void
		{
			var selectedIcon:SliderThumbnail = event.currentTarget as SliderThumbnail ;
			var currentImageIndex:uint = mySlider.getCurrentSelectedImage();
			var requiredImageIndex:uint = selectedIcon.myIndex ;
			while(currentImageIndex<requiredImageIndex)
			{
				currentImageIndex++;
				mySlider.next();
			}
			while(currentImageIndex>requiredImageIndex)
			{
				currentImageIndex--;
				mySlider.preve();
			}
		}
		
			protected function currentIconIsReadyForTheNext(event:Event):void
			{
				resetAllIconsPoseAndSizes();
				loadedImageIndex++;
				if(loadedImageIndex<myImages.length)
				{
					myTimeOutId = setTimeout(addNextIcon,iconLoaderDelay);
				}
			}
			
				private function resetAllIconsPoseAndSizes(e:*=null):void
				{
					var iconX:Number;
					var _howMuchIconsShouldGoForward:Number = getHowMuchIconsShouldGoForward(thumbs.length) ; 
					
					for(var i = 0 ; i<thumbs.length ; i++)
					{
						iconX = getIconX(i,_howMuchIconsShouldGoForward);
						thumbs[i].X0 = iconX ;
						thumbs[i].Scale0 = 1 ;
						if(thumbs[i].myIndex == mySlider.getCurrentSelectedImage())
						{
							thumbs[i].Alpha0 = 0.5 ;
						}
						else
						{
							thumbs[i].Alpha0 = 1 ;
						}
					}
				}
				
				/**Returns the Delta Y thath icons should go to right to make them show on middle of the page*/
				private function getHowMuchIconsShouldGoForward(iconIndex:uint):Number
				{
					var _howMuchIconsShouldGoForward:Number = 0 ; 
					var _totalIconsWidthTogather:Number = iconIndex*(iconW)+Math.max(0,iconIndex-1)*iconDeltaY ;
					if(_totalIconsWidthTogather<W)
					{
						_howMuchIconsShouldGoForward = (W-_totalIconsWidthTogather)/2 ;
					}
					return _howMuchIconsShouldGoForward ;
				}
				
				/***Returns the Icon X depends on the icon index and how much it should go forward*/
				private function getIconX(i:uint,_howMuchIconsShouldGoForward:Number):Number
				{
					return i*(iconW+iconDeltaY)+_howMuchIconsShouldGoForward+iconW/2
				}
	}
}