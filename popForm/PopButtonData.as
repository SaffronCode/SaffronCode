package popForm
{
	public class PopButtonData
	{
		public var title:String,
					id:*,
					selectable:Boolean = true,
					singleLine:Boolean=false,
					buttonFrame:uint=1;
				
		/**futer value*/
		public var buttonDisplayObject:*;
		public function PopButtonData(Title:String,ButtonFrame:uint=1,Id:* = null,Selectable:Boolean = true,addInSingleLine:Boolean=false)
		{
			title = Title ;
			if(Id != null)
			{
				id = Id ;
			}
			buttonFrame = ButtonFrame ;
			selectable = Selectable ;
			singleLine = addInSingleLine ;
		}
	}
}