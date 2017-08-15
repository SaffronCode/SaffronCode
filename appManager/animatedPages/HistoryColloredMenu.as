package appManager.animatedPages
	//appManager.animatedPages.HistoryColloredMenu
{
	import contents.History;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class HistoryColloredMenu extends MovieClip
	{
		private var imInHistory:Boolean = false ;
		
		private var myIdName:String ;
		
		public function HistoryColloredMenu()
		{
			super();
			myIdName = this.name ;
			if(this.stage!=null)
			{
				manageStage();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE,manageStage);
			}
		}
		
		protected function manageStage(event:Event=null):void
		{
			controllHistory();
			
			if(imInHistory)
			{
				this.gotoAndStop(this.totalFrames);
			}
			else
			{
				this.gotoAndStop(1);
			}

			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			this.addEventListener(Event.ENTER_FRAME,anim);
		}
		
		/**Removed from stage*/
		protected function unLoad(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,manageStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			this.removeEventListener(Event.ENTER_FRAME,anim);			
		}
		
		protected function anim(event:Event):void
		{
			if(imInHistory)
			{
				this.nextFrame();
			}
			else
			{
				this.prevFrame();
			}
		}
		
		/**Contrtol my Id on history*/
		private function controllHistory():void
		{
			imInHistory = History.isHistoryContainsThePageNamed(myIdName) ;
		}
		
		/**History is changed from History class, controll the history again*/
		protected function historyChanged(event:Event):void
		{
			controllHistory();
		}
	}
}