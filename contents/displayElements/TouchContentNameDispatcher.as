package contents.displayElements
	//contents.displayElements.TouchContentNameDispatcher
{
	import flash.events.MouseEvent;

	/**This will works just by a touch*/
	public class TouchContentNameDispatcher extends ContentNameDispatcher
	{
		public function TouchContentNameDispatcher()
		{
			super();
			this.addEventListener(MouseEvent.MOUSE_DOWN,generateLink);
		}
	}
}