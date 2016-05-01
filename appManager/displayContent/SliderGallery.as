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
		
		/**This is the index of showing image*/
		private var imageIndex:uint ;
					
		private var W:Number,
					H:Number;
					
		private var mouseX0:Number;
					
		private var mouseLastX:Number;
		
		private var isDragging:Boolean = false ;
		
		private var myMask:Sprite ;
		
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
			imageContainer.addChild(image1);
			imageContainer.addChild(image2);
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
				this.addEventListener(Event.ENTER_FRAME,animate);
			}
			
			protected function animate(event:Event):void
			{
				if(isDragging)
				{
					
				}
				else
				{
					
				}
			}
			
			/**Start the functions*/
			private function startFunctions(e:*=null):void
			{
				stage.addEventListener(MouseEvent.MOUSE_DOWN,startDragging);
				this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			}
			
			
				/**Start dragging the top Image*/
				protected function startDragging(event:MouseEvent):void
				{
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
						mouseLastX = this.mouseX;
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
		
		public function setUp(images:Vector.<SliderImageItem>,currentIndex:uint=0):void
		{
			imageIndex = currentIndex ;
			image1.load(images[imageIndex].image);
		}
	}
}