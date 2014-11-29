package popForm
{
	import flash.events.Event;

	/**it is contains buttonID and field values*/
	public class PopMenuEvent extends Event
	{
		public static const POP_SHOWS:String = "popMenuShows";
		
		public static const POP_CLOSED:String = "popClosed";
		
		public static const POP_BUTTON_SELECTED = "buttonSelecte";
		
		public var 	buttonID:uint,
					buttonTitle:String; 
		
		/**this is an Object of each values that entered on fields<br>
		 * You can find each field with its id on this object*/
		public var field:Object ;
		
		public function PopMenuEvent(type:String,ButtonID:uint=0,enteredField:Object=null,ButtonTitle:String='')
		{
			super(type);
			buttonID = ButtonID;
			buttonTitle = ButtonTitle ;
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