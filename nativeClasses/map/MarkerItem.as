package nativeClasses.map
{
	public class MarkerItem
	{
		internal var id:int;


		public var name:String ;

		private var _onClick:Function ;
		
		public function MarkerItem(markerName:String)
		{
			name = markerName ;
		}

		public function dispatchClicked():void
		{
			if(_onClick!=null)
			{
				if(_onClick.length==0)
					_onClick();
				else
					_onClick(this);
			}
		}

		public function onClick(event:Function):void
		{
			_onClick = event ;
		}
	}
}