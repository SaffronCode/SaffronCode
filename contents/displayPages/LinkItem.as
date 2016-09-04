package contents.displayPages
	//contents.displayPages.LinkItem
{
	import appManager.displayContentElemets.Image;
	import appManager.displayContentElemets.TextParag;
	import appManager.displayContentElemets.TitleText;
	import appManager.event.AppEventContent;
	
	import contents.LinkData;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	/**You can trigger me by calling imSelected function*/
	public class LinkItem extends MovieClip
	{
		protected var myImage:Image;
		
		protected var myTitle:TitleText ;
		
		protected var myParag:TextParag ;
		
		public var myLinkData:LinkData ;
		
		protected var myParentWidth:Number,myParentHeight:Number;
		
		internal var X0:Number,Y0:Number;
		
		internal var Xn:Number,Yn:Number;
		
		internal var myButtons:LinkItemButtons ;
		
		/**It changes to true if enter_frame animation activated*/
		protected var animatorActivated:Boolean = false ;
		
		/**This is the selected frame to show*/
		private var visibleFrame:uint = 1,
					frameHandler:Number ,
					slideAnimationActivated:Boolean=false ; 
		
		/**This is the link item index*/
		protected var myIndex:uint ;
		
		public function LinkItem(mouseChildAccept:Boolean=false,searchForElements:Boolean=true)
		{
			super();
			if(searchForElements)
			{
				var images:Array = Obj.findAllClass(Image,this);
				if(images.length>1)
				{
					myImage = Obj.findThisClass(Image,this) as Image;
				}
				else if(images.length!=0)
				{
					myImage = images[0];
				}
				myTitle = Obj.findThisClass(TitleText,this) as TitleText;
				//trace("founded text title is : "+myTitle)
				myParag = Obj.findThisClass(TextParag,this);
			}
				
			frameHandler = visibleFrame = 1 ;
			
			this.mouseChildren = mouseChildAccept ;
			activateSelectorAgainAfterScroll();
			this.addEventListener(ScrollMT.LOCK_SCROLL_TILL_MOUSE_UP,stopClickAcceptingAfterScroll);
			this.stop();
		}
		
		/**Dont accept click*/
		protected function stopClickAcceptingAfterScroll(event:Event):void
		{
			if(this.stage!=null)
			{
				this.removeEventListener(MouseEvent.CLICK,imSelected);
				stage.addEventListener(MouseEvent.MOUSE_UP,startClckAcceptingAfterScroll);
			}
		}
		
		/**Accept click from now*/
		protected function startClckAcceptingAfterScroll(e:Event):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,startClckAcceptingAfterScroll);
			setTimeout(activateSelectorAgainAfterScroll,0);
		}
		
		/**add scroll event again*/
		private function activateSelectorAgainAfterScroll():void
		{
			this.addEventListener(MouseEvent.CLICK,imSelected);
		}
		
		/**→←Move the button to left or right. pass positive value to precent to move it to right and negative to move it to left.<br>
		 * The deltaW is the max delta positioning for the item*/
		public function slideHorizontal(precent:Number=0,deltaW:Number=0,animateIt:Boolean=false):void
		{
			//trace("precent : "+precent);
			//trace("deltaW : "+deltaW);
			if(myButtons)
			{
				myButtons.setAnimate(precent);
			}
			setAnim(precent);
			Xn = X0+Math.max(-1,Math.min(1,precent))*deltaW;
			if(animateIt)
			{
				if(!animatorActivated)
				{
					animatorActivated = true ;
					this.addEventListener(Event.ENTER_FRAME,animateSliding);
				}
			}
			else
			{
				super.x = Xn ;
			}
		}
		
		protected function setAnim(precent:Number):void
		{
			visibleFrame = Math.floor(Math.min(1,Math.abs(precent))*(this.totalFrames-1))+1;
			if(!slideAnimationActivated && this.totalFrames>1)
			{
				slideAnimationActivated = true ;
				this.addEventListener(Event.ENTER_FRAME,animate);
				this.addEventListener(Event.REMOVED_FROM_STAGE,unLoadTheAnimation);
			}
		}
		
			/**Remove the enter frame event*/
			protected function unLoadTheAnimation(event:Event):void
			{
				this.removeEventListener(Event.ENTER_FRAME,animate);
				this.removeEventListener(Event.REMOVED_FROM_STAGE,unLoadTheAnimation);
			}
		
			/**Anmmate the frames*/
			protected function animate(event:Event):void
			{
				frameHandler+=(visibleFrame-frameHandler)/4;
				this.gotoAndStop(Math.round(frameHandler));
			}		
		
		/**↓↑Move the button to up or downt. pass positive value to precent to move it to down and negative to move it to up.<br>
		 * The deltaH is the max delta positioning for the item*/
		public function slideVertical(precent:Number,deltaH:Number=0):void
		{
			throw "Not completed yet";
		}
		
			/**Animate sliding*/
			protected function animateSliding(event:Event):void
			{
				super.x = super.x+(Xn-super.x)/5;
				super.y = super.y+(Yn-super.y)/5;
			}
			
		/**Get the Y0*/
		override public function set y(value:Number):void
		{
			if(isNaN(Y0))
			{
				Y0 = value ;
			}
			Yn = value ;
			super.y = value ;
		}
		
		/**Get the X0*/
		override public function set x(value:Number):void
		{
			if(isNaN(X0))
			{
				X0 = value ;
			}
			Xn = value ;
			super.x = value ;
		}
		
		/**New function to change the link item size dynamicly*/
		public function setSize(Width:Number, Height:Number):void
		{
			// TODO Auto Generated method stub
			myParentWidth = Width;
			myParentHeight = Height;
		}
		
		/**Set the linkItem index*/
		public function setIndex(index:uint):void
		{
			myIndex = index ;
		}
		
		/**Set up the page*/
		public function setUp(linkData:LinkData):void
		{
			myLinkData = linkData ;
			if(myLinkData!=null)
			{
				this.buttonMode = true ;
			}
			
			if(myImage!=null)
			{
				myImage.setUp(linkData.iconURL);
			}
			if(myTitle!=null)
			{
				myTitle.setUp(linkData.name);
			}
			else if(myParag!=null)
			{
				myParag.setUp(linkData.name);
			}
		}
		
		public function imSelected(event:MouseEvent=null):void
		{
			if(myLinkData!=null && ((Math.abs(this.x-X0)<1 && Xn == X0)  || isNaN(Xn) || isNaN(X0)))
			{
				this.dispatchEvent(new AppEventContent(myLinkData));
			}
		}
	}
}