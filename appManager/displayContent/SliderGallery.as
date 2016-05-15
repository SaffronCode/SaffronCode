package appManager.displayContent
	//appManager.displayContent.SliderGallery
{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	
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
		private var imageIndex:uint ;
		private var totalImages:uint ;
		private var imagesList:Vector.<SliderImageItem> ;
					
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
		
		public function SliderGallery()
		{
			super();
			
			this.addEventListener(MouseEvent.CLICK,preventDefaultClick,false,1000);
			
			totalImages = 0 ;
			
			W = super.width;
			H = super.height ;
			
			myMask = new Sprite();
			myMask.graphics.beginFill(0xff0000,1);
			myMask.graphics.drawRect(0,0,W,H);
			
			
			imageContainer = new Sprite
			image1 = new SliderGalleryElements(new Rectangle(0,0,W,H));
			image2 = new SliderGalleryElements(new Rectangle(0,0,W,H));
			
			
			this.addChild(imageContainer);
			imageContainer.addChild(image2);
			imageContainer.addChild(image1);
			this.addChild(myMask);
			
			//Image container mask
			imageContainer.mask = myMask ;
			
			controllStage();
		}
		
		protected function preventDefaultClick(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
		}
		
		public function getCurrentSelectedImage():uint
		{
			return imageIndex%totalImages;
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
				if(totalImages<=1)
				{
					return ;
				}
				if(isDragging)
				{
					
				}
				else
				{
					if(getImageUp().x<W/-2 || nextPrevController>0)
					{
						getImageUp().x += (-W-getImageUp().x)/backAnimSpeed;
						switchToNext = true ;
						mustSwitch = true ;
					}
					else if(getImageUp().x>W/2 || nextPrevController<0)
					{
						getImageUp().x += (W-getImageUp().x)/backAnimSpeed;
						mustSwitch = true ;
						switchToNext = false ;
					}
					else
					{
						getImageUp().x -= getImageUp().x/backAnimSpeed ;
						mustSwitch = false ;
					}
					
					if(mustSwitch && (Math.abs(getImageUp().x+W)<2 || Math.abs(getImageUp().x-W)<5))
					{
						swtichImages();
						return ;
					}
				}
				
				
				if(getImageUp().x<=0)
				{
					getImageDown().load(nextImage());
					getImageDown().x = (getImageUp().x+getImageUp().width)/10;
				}
				else
				{
					getImageDown().load(prevImage());
					getImageDown().x = (getImageUp().x-getImageUp().width)/10;
				}
				speed*=0.5;
			}
			
			
			
			private function swtichImages():void
			{
				if(nextPrevController!=0)
				{
					imageIndex+=nextPrevController;
					nextPrevController = 0 ;
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
				

				mustSwitch = false ;
				selectedImge = (selectedImge+1)%2 ;
				imageContainer.addChild(getImageUp());
				
				this.dispatchEvent(new Event(Event.CHANGE));
			}
			
			/**Returns the next image*/
			private function nextImage():*
			{
				return imagesList[(imageIndex+1)%totalImages];
			}
			
			/**Returns the previus image*/
			private function prevImage():*
			{
				return imagesList[(((imageIndex-1)%totalImages)+totalImages)%totalImages];
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
					
					if(totalImages==1)
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
				}
				
				/**Cansel dragging*/
				protected function canselDragging(event:MouseEvent):void
				{
					isDragging = false ;
					stage.removeEventListener(MouseEvent.MOUSE_MOVE,startSliding);
					stage.removeEventListener(MouseEvent.MOUSE_UP,canselDragging);
					
					trace("speed : "+(speed));
					
					if(speed<-userMinSpeed)
					{
						preve();
					}
					else if(speed>userMinSpeed)
					{
						next();
					}
					
					if(myMask.hitTestPoint(stage.mouseX,stage.mouseY) && (getTimer()-mouseDownTime)<150)
					{
						this.removeEventListener(MouseEvent.CLICK,preventDefaultClick,false);
						this.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
						this.addEventListener(MouseEvent.CLICK,preventDefaultClick,false,1000);
					}
					
					setAnimation();
				}
				
					protected function startSliding(event:MouseEvent):void
					{
						if(!moveingStarts)
						{
							if(Math.abs(this.mouseX-mouseX0)>minMoveToSpeed)
							{
								moveingStarts = true ;
								mouseLastX = this.mouseX ;
								this.dispatchEvent(new Event(ScrollMT.LOCK_SCROLL_TILL_MOUSE_UP,true));
							}
							else
							{
								return ;
							}
						}
						getImageUp().x += this.mouseX-mouseLastX ;
						getImageUp().x = Math.min(W,Math.max(-W,getImageUp().x));
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
		
		public function setUp(images:Vector.<SliderImageItem>,currentIndex:uint=0,animateTimer:uint = 10000):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,startDragging);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,startSliding);
			
			nextPrevController = 0 ;
			mustSwitch = false ;
			switchToNext = false ;
			imageIndex = currentIndex ;
			imagesList = images ;
			totalImages = imagesList.length ;
			getImageUp().load(images[imageIndex]);
			
			animInterval = animateTimer ;
			
			setAnimation();
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
		
		public function preve():void
		{
			if(nextPrevController!=0)
			{
				swtichImages();
			}
			nextPrevController--;
		}
		
		public function next():void
		{
			if(nextPrevController!=0)
			{
				swtichImages();
			}
			nextPrevController++;
		}
	}
}