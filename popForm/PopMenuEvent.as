package popForm
{
	import contents.alert.Alert;
	
	import flash.events.Event;

	/**it is contains buttonID and field values*/
	public class PopMenuEvent extends Event
	{
		public static const POP_SHOWS:String = "popMenuShows";
		
		public static const POP_CLOSED:String = "popClosed";
		
		public static const POP_BUTTON_SELECTED:String = "buttonSelecte";
		
		/**Dispatches when CLICK field selects.<br>
		 * When this event dispatches from field, you have to detect field id from buttonID value and you can get last field value by using field[buttinID]*/
		public static const FIELD_SELECTED:String = "FIELD_SELECTED" ;
		
		/**Button id can be String or Number*/
		public var 	buttonID:*,
					buttonTitle:String,
					buttonData:Object; 
		
		/**this is an Object of each values that entered on fields<br>
		 * You can find each field with its id on this object*/
		public var field:Object ;
		
		/**Button id can be a String value*/
		public function PopMenuEvent(type:String,ButtonID:*=0,enteredField:Object=null,ButtonTitle:String='',bubble:Boolean=false,ButtonData:Object=null)
		{
			super(type,bubble);
			buttonID = ButtonID;
			buttonTitle = ButtonTitle ;
			buttonData = ButtonData ;
			if(enteredField == null)
			{
				field = {} ;
			}
			else
			{
				field = enteredField ;
				if(field[0] == undefined || field[0] == null)
				{
					field[0] = "PopMenuFields on PopMenuEvents are no longer an Array"
				}
			}
		}
	}
}