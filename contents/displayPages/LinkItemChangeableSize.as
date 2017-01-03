package contents.displayPages
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class LinkItemChangeableSize extends LinkItem
	{
		private var openStarus:Boolean;
		private var startOpenning:Boolean = false	
		private var deltaHeight:Number;	
		private var effectEvent:Boolean=true;
		private var moreStatus:Boolean;	
		private var sinVal:Number = 0;
		private const PI_2:Number = 3.1415/2;
		private var height0:Number;
		protected var sinSpeed:Number = 0.15;

		//private var heightLink:Number=0;
		public function LinkItemChangeableSize(mouseChildAccept:Boolean=false, searchForElements:Boolean=true)
		{
			super(mouseChildAccept, searchForElements);
			moreStatus = false
			openStarus = false
			
		}
		protected function changeSize(height0_p:Number,deltaHeight_p:Number):void
		{
			height0 = height0_p
			deltaHeight = deltaHeight_p	
			if(effectEvent)
			{		
				if(openStarus)
				{						
					this.addEventListener(Event.ENTER_FRAME,animating);			
				}
				else
				{
					startOpenning = true;							
					this.addEventListener(Event.ENTER_FRAME,animatingClose);
				}
				this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
				moreStatus = true;		
			}
			effectEvent = false	
			
		}
		protected function animating(event:Event):void
		{
			// TODO Auto-generated method stub
			this.dispatchEvent(new Event(DynamicLinks.UPDATE_LINKS_POSITION,true))
			if(sinVal<PI_2)
			{
				sinVal+=sinSpeed;
			}
			else
			{
				sinVal = PI_2 ;
				this.removeEventListener(Event.ENTER_FRAME,animating);
				this.dispatchEvent(new Event(DynamicLinks.UPDATE_LINKS_POSITION,true))
				openStarus = false	
				effectEvent = true				
			}	
			changeing(Math.round( Math.sin(sinVal)*100))
		}
		protected function animatingClose(event:Event):void
		{
			// TODO Auto-generated method stub
			this.dispatchEvent(new Event(DynamicLinks.UPDATE_LINKS_POSITION,true))
			if(sinVal>0)
			{
				sinVal-=sinSpeed;
			}
			else
			{
				sinVal = 0 ;
				
				this.removeEventListener(Event.ENTER_FRAME,animatingClose);
				this.dispatchEvent(new Event(DynamicLinks.UPDATE_LINKS_POSITION,true))
				openStarus = true	
				effectEvent = true		
			}
			changeing(Math.round( Math.sin(sinVal)*100))
		}
		protected function unLoad(event:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(Event.ENTER_FRAME,animating);
			this.removeEventListener(Event.ENTER_FRAME,animatingClose);
		}
		
		override public function get height():Number
		{
			var _height:Number
			if(startOpenning)
			{
				_height =  height0+Math.sin(sinVal)*deltaHeight ;
			}
			else
			{
				_height =  height0;
			}
			if(isNaN(_height))
			{
				return super.height
			}
			else
			{
				return _height
			}
		}
		protected function changeing(SizePrecent_p:Number):void
		{
			
		}
	}
}