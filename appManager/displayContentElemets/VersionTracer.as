package appManager.displayContentElemets
	//appManager.displayContentElemets.VersionTracer
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import wrokersJob.WorkerFunctions;
	
	public class VersionTracer extends MovieClip
	{
		private var tf:TextField ;
		private var intervalId:uint;
		
		public function VersionTracer()
		{
			super();
			
			tf = Obj.findThisClass(TextField,this,true);
			if(tf)
			{
				updateVersionLabel();
			}
			
			controllStage();
		}
		
		private function controllStage(e:Event=null):void
		{
			if(this.stage!=null)
			{
				intervalId = setInterval(updateVersionLabel,10000);
				this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE,controllStage);
			}
		}
		
		protected function unLoad(event:Event):void
		{
			clearInterval(intervalId);
		}
		
		private function updateVersionLabel():void
		{
			tf.text = DevicePrefrence.appVersion+(WorkerFunctions.isDebugMode()?'-w':'') ;			
		}
	}
}