package diagrams.table
{
	import flash.events.Event;
	
	public class TableEvent extends Event
	{
		public static const TABLE_SELECTED:String = "TABLE_SELECTED" ;
		
		public var 	Vid:uint,
					Hid:uint;
					
		public var Value:String ;
		
		public function TableEvent(type:String,vid:uint,hid:uint,value:String='')
		{
			Value = value ;
			
			Vid = vid ;
			Hid = hid ;
			super(type, true);
		}
	}
}