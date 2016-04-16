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
		
		public function LinkItem(mouseChildAccept:Boolean=false)
		{
			super();
			
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
			
			this.mouseChildren = mouseChildAccept ;
			this.addEventListener(MouseEvent.CLICK,imSelected);
		}
		
		/**→←Move the button to left or right. pass positive value to precent to move it to right and negative to move it to left.<br>
		 * The deltaW is the max delta positioning for the item*/
		public function slideHorizontal(precent:Number=0,deltaW:Number=0,animateIt:Boolean=false):void
		{
			trace("precent : "+precent);
			trace("deltaW : "+deltaW);
			if(myButtons)
			{
				myButtons.setAnimate(precent);
			}
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
			// TODO Auto-generated method stub
			if(myLinkData!=null)
			{
				this.dispatchEvent(new AppEventContent(myLinkData));
			}
		}
	}
}