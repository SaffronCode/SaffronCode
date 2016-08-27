package mp3Player
	//mp3Player.MediaSlider
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class MediaSlider extends MovieClip
	{
		private var backColor:uint;
		private var mainColor:uint;
		private var onChanged:Function;
		
		private var currentPrecent:Number = 1 ;
		
		private var floatedPrecent:Number = 1 ;
		
		private var myWidth:Number ; 
		private var myHeight:Number ;
		private var lastFloatedPrecent:Number;
		private var slideSpeed:Number = 4 ;
		
		/**userSlideEnabled()<br>
		 * setUp()<br>
		 * setPrecent(precent:Number)
		 * */
		public function MediaSlider()
		{
			super();
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			this.buttonMode = true ;
			this.mouseChildren = false;
			
			myWidth = this.width ;
			myHeight = this.height ;
			this.scaleX = this.scaleY = 1 ;
			
			this.removeChildren();
		}
		
		protected function unLoad(event:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(Event.ENTER_FRAME,animIt);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			this.removeEventListener(MouseEvent.CLICK,changePrecent);
		}
		
		/**precent changed*/
		protected function changePrecent(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(onChanged!=null)
			{
				//Calculate current precent
				var myPrecent:Number = this.mouseX / myWidth;
				if(myPrecent<0)
				{
					myPrecent = 0 ;
				}
				else if(myPrecent > 1)
				{
					myPrecent = 1 ;
				}
				currentPrecent = myPrecent ;
				//trace("Touched Precent is : "+currentPrecent);
				onChanged(currentPrecent);
			}
		}
		
		/**set up the slider*/
		public function setUp(MainColor:uint,BackColor:uint,onPrecentChanged:Function)
		{
			mainColor = MainColor ;
			backColor = BackColor ;
			onChanged = onPrecentChanged ;
			this.addEventListener(Event.ENTER_FRAME,animIt);
			animIt();
		}
		
		/**From now , user can select the slider precent*/
		public function userSlideEnabled():void
		{
			this.addEventListener(MouseEvent.MOUSE_MOVE,changePrecent);
		}
		
		/**set the slider to this stage*/
		public function setPrecent(precent:Number)
		{
			if(precent <0)
			{
				precent = 0 ;
			}
			else if(precent>1)
			{
				precent = 1 ;
			}
			
			currentPrecent = precent ;
			animIt();
		}
		
		/**animate the slider*/
		private function animIt(e:Event=null)
		{
			floatedPrecent += (currentPrecent-floatedPrecent)/slideSpeed;
			
			if(floatedPrecent!=lastFloatedPrecent)
			{
				var gra:Graphics = this.graphics ;
				gra.clear();
				gra.beginFill(mainColor);
				var currentX:Number = floatedPrecent*myWidth ;
				gra.drawRect(0,0,currentX,myHeight);
				gra.beginFill(backColor);
				gra.drawRect(currentX,0,myWidth-currentX,myHeight);
				
				lastFloatedPrecent = floatedPrecent ;
			}
		}
	}
}