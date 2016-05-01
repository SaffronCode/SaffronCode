package appManager.displayContent
	//appManager.displayContent.SliderGallery
{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class SliderGallery extends MovieClip
	{
		private var index:uint ;
		
		private var imageContainer:Sprite ;
		
		private var image1:SliderGalleryElements,
					image2:SliderGalleryElements;
					
		private var selectedImge:uint = 0 ;
		/**If this was true, after mouse clicked or item animated, the selected images must switch*/
		private var mustSwitch:Boolean = false ;
		
		/**This is the index of showing image*/
		private var imageIndex:uint ;
		private var totalImages:uint ;
		private var imagesList:Vector.<SliderImageItem> ;
					
		private var W:Number,
					H:Number;
					
		private var mouseX0:Number;
					
		private var mouseLastX:Number;
		
		private var isDragging:Boolean = false ;
		
		private var myMask:Sprite ;
		
		private const backAnimSpeed:Number = 4 ;
		
		
		public function SliderGallery()
		{
			super();
			
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
				stage.removeEventListener(MouseEvent.MOUSE_DOWN,startDragging);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,startSliding);
				this.removeEventListener(Event.REMOVED_FROM_STAGE,unLoad);
				this.removeEventListener(Event.ENTER_FRAME,animate);
			}
			
			protected function animate(event:Event=null):void
			{
				if(isDragging)
				{
					
				}
				else
				{
					if(getImageUp().x<W/-2)
					{
						getImageUp().x += (-W-getImageUp().x)/backAnimSpeed;
						mustSwitch = true ;
					}
					else if(getImageUp().x>W/2)
					{
						getImageUp().x += (W-getImageUp().x)/backAnimSpeed;
						mustSwitch = true ;
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
			}
			
			
			
			private function swtichImages():void
			{
				mustSwitch = false ;
				selectedImge = (selectedImge+1)%2 ;
				imageContainer.addChild(getImageUp());
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
					if(mustSwitch)
					{
						swtichImages();
					}
					
					mouseLastX = mouseX0 = this.mouseX;
					isDragging = true ;
					
					stage.addEventListener(MouseEvent.MOUSE_MOVE,startSliding);
					stage.addEventListener(MouseEvent.MOUSE_UP,canselDragging);
				}
				
				/**Cansel dragging*/
				protected function canselDragging(event:MouseEvent):void
				{
					isDragging = false ;
					stage.removeEventListener(MouseEvent.MOUSE_MOVE,startSliding);
					stage.removeEventListener(MouseEvent.MOUSE_UP,canselDragging);
				}
				
					protected function startSliding(event:MouseEvent):void
					{
						getImageUp().x += this.mouseX-mouseLastX ;
						getImageUp().x = Math.min(W,Math.max(-W,getImageUp().x));
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
		
		public function setUp(images:Vector.<SliderImageItem>,currentIndex:uint=0):void
		{
			imageIndex = currentIndex ;
			imagesList = images ;
			totalImages = imagesList.length ;
			getImageUp().load(images[imageIndex]);
		}
	}
}