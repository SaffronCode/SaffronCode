package diagrams.calender
{
	import flash.events.Event;
	
	public class CalenderEvent extends Event
	{
		public static const DATE_SELECTED:String = "DATE_SELECTED" ;
		
		public var data:CalenderContents  ;
		
		public var beginDate:Date;
		
		public var endDate:Date ;
		
		public function CalenderEvent(type:String = DATE_SELECTED , selectedItem:CalenderContents =null , beginDate_v:Date=null , endDate_v:Date = null)
		{
			beginDate = DateManager.copy(beginDate_v)
			endDate = DateManager.copy(endDate_v) ;
			
			data = selectedItem ;
			super( type, true );
		}
	}
}