package appManager.displayContent
	//appManager.displayContent.SliderGallery
{
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	/**When an image changed*/
	[Event(name="change", type="flash.events.Event")]
	/**The click event upgraded for this Class*/
	[Event(name="click", type="flash.events.MouseEvent")]
	public class SliderGallery extends MovieClip
	{
		private var index:uint ;
		
		private var imageContainer:Sprite ;
		
		private var image1:SliderGalleryElements,
					image2:SliderGalleryElements;
					
		private var selectedImge:uint = 0 ;
		/**If this was true, after mouse clicked or item animated, the selected images must switch*/
		private var mustSwitch:Boolean = false,
					switchToNext:Boolean;
		
		/**This is the index of showing image*/
		private var imageIndex:int ;
		private var _totalImages:uint ;
		public var imagesList:Vector.<SliderImageItem> ;
					
		private var W:Number,
					H:Number;
					
		private var mouseX0:Number;
		
		private var moveingStarts:Boolean ;
					
		private var mouseLastX:Number;
		
		private var isDragging:Boolean = false ;
		
		private var myMask:Sprite ;
		
		private const backAnimSpeed:Number = 4 ;
		
		private var nextPrevController:int = 0 ;
		
		
		private const userMinSpeed:Number = 1 ;
		
		/**This is the dragging speed*/
		private var speed:Number ;
		
		
		/**This is animating interval timer*/
		private var animInterval:uint ;
		private var intervalId:uint;
		
		/**This is a time when the mouse is down and this value will controll to dispatches CLICK event*/
		private var mouseDownTime:uint;
		
		private var minMoveToSpeed:Number = 15;
		
		
		internal static var preloaderClass:Class ;
		
		internal static var imageBackGroundColor:int=0xffffff ;
		
		internal static var imageBackAlpha:Number=1 ;
		
		private const plusPages:int = 2000000000;
		private var RTL:Boolean;
		private var Loop:Boolean;
		
		private var sliderBoolet:SliderBoolets ;
		
		/**List of sliders shouldnt staye on the stage*/
		private var ignoredIndexes:Array = [] ;
		
		private var _lockNext:Boolean,
					_lockPrev:Boolean;
		
		public function SliderGallery(myWidth:Number=0,myHeight:Number=0)
		{
			super();
			
			
			_totalImages = 0 ;
			
			if(myWidth!=0)
			{
				W = myWidth ;
				H = myHeight ;
			}
			else
			{
				W = super.width;
				H = super.height ;
			}
			
			myMask = new Sprite();
			myMask.graphics.beginFill(0xff0000,1);
			myMask.graphics.drawRect(0,0,W,H);
			
			
			imageContainer = new Sprite();
			image1 = new SliderGalleryElements(new Rectangle(0,0,W,H));
			image2 = new SliderGalleryElements(new Rectangle(0,0,W,H));
			
			
			this.addChild(imageContainer);
			imageContainer.addChild(image2);
			imageContainer.addChild(image1);
			this.addChild(myMask);
			
			//Image container mask
			imageContainer.mask = myMask ;
			
			controllStage();
			this.addEventListener(ScrollMTEvent.YOU_ARE_SCROLLING_FROM_YOUR_PARENT,canselDragingBecauseOfScroll);
		}
		
		public function lockNext(status:Boolean=true):void
		{
			_lockNext = status ;
		}
		
		public function lockPrev(status:Boolean=true):void
		{
			_lockPrev = status ;
		}
		
		protected function canselDragingBecauseOfScroll(event:Event):void
		{
			canselDragging(null,false);
		}		
		
		public static function setPreLoader(PreloaderClass:Class,imageBackGrounds:uint,imageBackgroundAlpha:Number=1)
		{
			preloaderClass = PreloaderClass ;
			
			imageBackGroundColor = imageBackGrounds ;
			
			imageBackAlpha = imageBackgroundAlpha ;
		}
		
		override public function get height():Number
		{
			return H ;
		}
		
		override public function set height(value:Number):void
		{
			trace("Old H was : "+H);
			H = value ;
			trace("Nw H is : "+H);
			
			if(myMask)
			{
				myMask.graphics.clear();
				myMask.graphics.beginFill(0xff0000,1);
				myMask.graphics.drawRect(0,0,W,H);
				imageContainer.mask = myMask ;
			}
			if(image1)
			{
				image1.height = H ;
				image2.height = H ;
			}
			
		}
		
		override public function get width():Number
		{
			return W ;
		}
		
		override public function set width(value:Number):void
		{
			trace("Old W was : "+W);
			W = value ;
			trace("Nw W is : "+W);
			
			if(myMask)
			{
				myMask.graphics.clear();
				myMask.graphics.beginFill(0xff0000,1);
				myMask.graphics.drawRect(0,0,W,H);
				imageContainer.mask = myMask ;
			}
			if(image1)
			{
				image1.width = W ;
				image2.width = W ;
			}
			
		}
		
		protected function preventDefaultClick(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
		}
		
		public function getCurrentSelectedImage():uint
		{
			if(false && imageIndex>=plusPages)
			{
				return (imageIndex-plusPages)%_totalImages;
			}
			else
			{
				return (imageIndex)%_totalImages;
			}
		}
		
		public function totalImages():uint
		{
			return _totalImages ;
		}
		
		public function get currentImageIndex():int
		{
			return getCurrentSelectedImage() ;
		}
		
		private function controllStage():void
		{
			if(this.stage != null)
			{
				startFunctions();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE,startFunctions);
			}
		}
		
			protected function unLoad(event:Event):void
			{
				stopAnimation();
				stage.removeEventListener(MouseEvent.MOUSE_DOWN,startDragging);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,startSliding);
				this.removeEventListener(Event.REMOVED_FROM_STAGE,unLoad);
				this.removeEventListener(Event.ENTER_FRAME,animate);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,startSliding);
				stage.removeEventListener(MouseEvent.MOUSE_UP,canselDragging);
			}
			
			protected function animate(event:Event=null):void
			{
				if(_totalImages<=1)
				{
					return ;
				}
				if(isDragging)
				{
					
				}
				else
				{
					if(getImageUp().x<W/-2 || (!RTL && nextPrevController>0) || (RTL && nextPrevController<0))
					{
						getImageUp().x += (-W-getImageUp().x)/backAnimSpeed;
						if(!RTL)
							switchToNext = true ;
						else
							switchToNext = false ;
							
						mustSwitch = true ;
					}
					else if(getImageUp().x>W/2 || (!RTL && nextPrevController<0) || (RTL && nextPrevController>0))
					{
						getImageUp().x += (W-getImageUp().x)/backAnimSpeed;
						if(!RTL)
							switchToNext = false ;
						else
							switchToNext = true ;
						
						mustSwitch = true ;
					}
					else
					{
						getImageUp().x -= getImageUp().x/backAnimSpeed ;
						mustSwitch = false ;
					}
					var minimomDeltaXToSwitch:Number = this.width/40 ;
					if(mustSwitch && (Math.abs(getImageUp().x+W)<minimomDeltaXToSwitch || Math.abs(getImageUp().x-W)<minimomDeltaXToSwitch))
					{
						swtichImages();
						return ;
					}
				}
				
				var loadNextImage:Boolean ;
				
				if(getImageUp().x<=0)
				{
					if(RTL)
					{
						loadNextImage = false ;
					}
					else
					{
						loadNextImage = true ;
					}
					getImageDown().x = (getImageUp().x+getImageUp().width)/10;
				}
				else
				{
					if(!RTL)
					{
						loadNextImage = false ;
					}
					else
					{
						loadNextImage = true ;
					}
					getImageDown().x = (getImageUp().x-getImageUp().width)/10;
				}
				
				if(loadNextImage)
				{
					if(nextAvailable())
					{
						getImageDown().load(nextImage(),nextImageIndex());
					}
					else
					{
						trace("No next image available");
						getImageUp().x = 0 ;
					}
				}
				else
				{
					if(prevAvailabe())
					{
						getImageDown().load(prevImage(),prevImageIndex());
					}
					else
					{
						//trace("No prev image available");
						getImageUp().x = 0 ;
					}
				}
				
				
				speed*=0.5;
			}
			
			
			
			private function swtichImages():void
			{
				if(nextPrevController!=0)
				{
					imageIndex+=nextPrevController;
				}
				else
				{
					if(switchToNext)
					{
						imageIndex++;
					}
					else
					{
						imageIndex--;
					}
				}
				if(imageIndex<0)
				{
					imageIndex += plusPages;
				}

				//trace("♠♠○♠369♠♠ compate ImageIndex vs IgnoredList "+ignoredIndexes+" vs "+getCurrentSelectedImage())
				if(ignoredIndexes.indexOf(getCurrentSelectedImage())!=-1)
				{
					if(nextPrevController>0)
					{
						nextPrevController++;
					}
					else
					{
						nextPrevController--;
					}
				}
				else
					nextPrevController = 0 ;
				
				//trace("imageIndex : "+imageIndex);

				mustSwitch = false ;
				selectedImge = (selectedImge+1)%2 ;
				imageContainer.addChild(getImageUp());
				
				this.dispatchEvent(new Event(Event.CHANGE));
			}
			
			/**Returns the next image*/
			private function nextImage():*
			{
				return imagesList[nextImageIndex()];
			}
			
				private function nextImageIndex():int
				{
					return (imageIndex+1)%_totalImages;
				}
				
				/**Returns true if loop enabled or next image was enabled*/
				public function nextAvailable():Boolean
				{
					return Loop || (imageIndex%_totalImages)+1<_totalImages ;
				}
			
			/**Returns the previus image*/
			private function prevImage():*
			{
				return imagesList[prevImageIndex()];
			}
			
				private function prevImageIndex():int
				{
					return (((imageIndex-1)%_totalImages)+_totalImages)%_totalImages ;
				}
				
				/**Returns true if loop enabled or preveus image was enabled*/
				public function prevAvailabe():Boolean
				{
					return Loop || (imageIndex%_totalImages)>0 ;
				}
			
			/**Returns the previus image*/
			private function currentImage():*
			{
				if(imagesList.length != 0){
					return imagesList[getCurrentSelectedImage()];
				}
			}
			
			
			/**Start the functions*/
			private function startFunctions(e:*=null):void
			{
				this.addEventListener(MouseEvent.MOUSE_DOWN,startDragging);
				this.addEventListener(Event.ENTER_FRAME,animate);
				this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			}
			
			
				/**Start dragging the top Image*/
				protected function startDragging(event:MouseEvent):void
				{
					stopAnimation();
					
					if(_totalImages==1)
					{
						return ;
					}
					if(mustSwitch)
					{
						swtichImages();
					}
					
					
					speed = 0 ;
					mouseLastX = mouseX0 = this.mouseX;
					moveingStarts = false ;
					isDragging = true ;
					
					mouseDownTime = getTimer();
					
					stage.addEventListener(MouseEvent.MOUSE_MOVE,startSliding);
					stage.addEventListener(MouseEvent.MOUSE_UP,canselDragging);
					this.addEventListener(ScrollMT.LOCK_SCROLL_TILL_MOUSE_UP,canselDragging);
				}
				
				/**Cancel dragging*/
				protected function canselDragging(event:*,dispatchClick:Boolean=true):void
				{
					isDragging = false ;
					stage.removeEventListener(MouseEvent.MOUSE_MOVE,startSliding);
					stage.removeEventListener(MouseEvent.MOUSE_UP,canselDragging);
					
					trace("speed : "+(speed));
					
					if(!RTL)
					{
						if(speed<-userMinSpeed)
						{
							preve();
						}
						else if(speed>userMinSpeed)
						{
							next();
						}
					}
					else
					{
						if(speed<-userMinSpeed)
						{
							next();
						}
						else if(speed>userMinSpeed)
						{
							preve();
						}
					}
					
					if(dispatchClick && myMask.hitTestPoint(stage.mouseX,stage.mouseY) && !moveingStarts)
					{
						this.removeEventListener(MouseEvent.CLICK,preventDefaultClick,false);
						this.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
						this.addEventListener(MouseEvent.CLICK,preventDefaultClick,false,1000);
					}
					
					setAnimation();
					setTimeout(activateClicks,0);
				}
				
				private function activateClicks():void
				{
					this.mouseChildren = this.mouseEnabled = true ;
				}
				
				private function diactivateClicks():void
				{
					this.mouseChildren = this.mouseEnabled = false ;
				}
				
					protected function startSliding(event:MouseEvent):void
					{
						if(!Obj.isAccesibleByMouse(this))
						{
							canselDragging(event);
							return ;
						}
						if(!moveingStarts)
						{
							if(Math.abs(this.mouseX-mouseX0)>minMoveToSpeed)
							{
								moveingStarts = true ;
								mouseLastX = this.mouseX ;
								diactivateClicks();
								this.parent.dispatchEvent(new Event(ScrollMT.LOCK_SCROLL_TILL_MOUSE_UP,true));
								//TODO revert dispatch to prevent inner scroll to close the page
								Obj.dispatchReverse(this as Sprite,new ScrollMTEvent(ScrollMTEvent.YOU_ARE_SCROLLING_FROM_YOUR_PARENT,false,false))
							}
							else
							{
								return ;
							}
						}
						var mouseDelta:Number = this.mouseX-mouseLastX ;
						getImageUp().x += mouseDelta ;
						if(
							(_lockNext && RTL)
							||
							(_lockPrev && !RTL)
						)
							getImageUp().x = Math.min(0,getImageUp().x);
						else
							getImageUp().x = Math.min(W,getImageUp().x);
						
						if(
							(_lockPrev && RTL)
							||
							(_lockNext && !RTL)
						)
							getImageUp().x = Math.max(0,getImageUp().x) ;
						else
							getImageUp().x = Math.max(-W,getImageUp().x);
						
						speed += mouseLastX-this.mouseX;
						mouseLastX = this.mouseX;
						animate();
						event.updateAfterEvent();
					}
				
		/**This function will returs the top image*/
		private function getImageUp():SliderGalleryElements
		{
			if(selectedImge==0)
			{
				return image1 ;
			}
			else
			{
				return image2 ;
			}
		}
				
		/**This function will returs the top image*/
		private function getImageDown():SliderGalleryElements
		{
			if(selectedImge==0)
			{
				return image2 ;
			}
			else
			{
				return image1 ;
			}
		}
		
		/**Set the list of indexes shouldnt stay on the stage*/
		public function setIgnoreIndexes(ignoreIndexList:Array=null)
		{
			if(ignoreIndexList!=null)
				ignoredIndexes = ignoreIndexList.concat();
			else
				ignoreIndexList = [] ;
		}
		
		public function setUp(images:Vector.<SliderImageItem>,currentIndex:uint=0,animateTimer:uint = 10000,rightToLeft:Boolean=false,loopEnabled:Boolean=true,addSliderEffect:SliderBooletSetting=null):void
		{
			setIgnoreIndexes();
			if(stage!=null)
			{
				
				stage.removeEventListener(MouseEvent.MOUSE_DOWN,startDragging);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,startSliding);
			}
			
			RTL = rightToLeft ;
			Loop = loopEnabled ;
			
			
			nextPrevController = 0 ;
			mustSwitch = false ;
			switchToNext = false ;
			imagesList = images ;
			_totalImages = imagesList.length ;
			if(_totalImages==0)
			{
				return ;
			}
			imageIndex = (plusPages-(plusPages%_totalImages))+currentIndex ;
			getImageUp().load(currentImage(),0,true);
			
			if(_totalImages<=1)
			{
				this.removeEventListener(MouseEvent.CLICK,preventDefaultClick);
				animInterval = 0 ;
			}
			else
			{
				this.addEventListener(MouseEvent.CLICK,preventDefaultClick,false,1000);
				animInterval = animateTimer ;
			}
			
			
			setAnimation();
			this.dispatchEvent(new Event(Event.CHANGE));
			if(sliderBoolet)
			{
				Obj.remove(sliderBoolet);
				sliderBoolet = null ;
			}
			if(addSliderEffect!=null && _totalImages>1)
			{
				addSliderEffect.sliderGallery = this ;
				addSliderEffect.rtl = rightToLeft ;
				
				sliderBoolet = new SliderBoolets(addSliderEffect);
				this.addChild(sliderBoolet);
				sliderBoolet.scaleX = 1/this.scaleX ;
				sliderBoolet.scaleY = 1/this.scaleY ;
				sliderBoolet.y = H ;
				sliderBoolet.x = W/2 ;
			}
		}
		
		/**Start animation timer*/
		private function setAnimation():void
		{
			stopAnimation();
			if(animInterval>0)
			{
				intervalId = setInterval(next,animInterval);
			}
		}
		
		/**Stop the animation timer*/
		private function stopAnimation():void
		{
			clearInterval(intervalId);
		}
		/**Open the previus question, call showExactIndex() function to open exact page*/
		public function preve():void
		{
			if(_lockPrev)
				return ;			
	
			setAnimation();
			if(prevAvailabe())
			{
				if(nextPrevController!=0)
				{
					swtichImages();
					if(!prevAvailabe())
					{
						return;
					}
				}
				nextPrevController--;
			}
		}
		/**Open the next question, call showExactIndex() function to open exact page*/
		public function next():void
		{
			if(_lockNext)
				return;
			
			if(nextAvailable())
			{
				setAnimation();
				if(nextPrevController!=0)
				{
					swtichImages();
					if(!nextAvailable())
					{
						return;
					}
				}
				nextPrevController++;
			}
		}
		
		/**Set the exact index for this question*/
		public function showExactIndex(sliderElementIndex:uint):void
		{
			if(sliderElementIndex<0 || sliderElementIndex>=totalImages())
			{
				throw "Wrong image index passed to showExactIndex() funciton\n\n : "+sliderElementIndex ;
				return ;
			}
			setAnimation();
			if(nextPrevController!=0)
			{
				swtichImages();
			}
			if(sliderElementIndex>currentImageIndex)
			{
				imageIndex = sliderElementIndex-1;
				nextPrevController = 1;
			}
			if(sliderElementIndex<currentImageIndex)
			{
				imageIndex = sliderElementIndex+1;
				nextPrevController = -1;
			}
			//getImageUp().load(imagesList[sliderElementIndex],sliderElementIndex);
			//getImageDown().load(imagesList[sliderElementIndex],sliderElementIndex);
		}
		
		/**Creating a bitmap data from the current display*/
		public function getBitmapData():flash.display.BitmapData
		{
			var currentDisplayingObject:SliderGalleryElements = getImageUp() ;
			var bitmapData:BitmapData = new BitmapData(currentDisplayingObject.width,currentDisplayingObject.height,false,0xffffff);
			bitmapData.draw(currentDisplayingObject);
			return bitmapData;
		}
	}
}