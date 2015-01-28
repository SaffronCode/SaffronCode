package popForm
{
	public class PopButtonData
	{
		public var title:String,
					id:*,
					selectable:Boolean = true,
					buttonFrame:uint=1;
				
		/**futer value*/
		public var buttonDisplayObject:*;
		public function PopButtonData(Title:String,ButtonFrame:uint=1,Id:* = null,Selectable:Boolean = true)
		{
			title = Title ;
			if(Id != null)
			{
				id = Id ;
			}
			buttonFrame = ButtonFrame ;
			selectable = Selectable ;
		}
	}
}