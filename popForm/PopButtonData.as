package popForm
{
	public class PopButtonData
	{
		public var title:String,
					id:*,
					selectable:Boolean = true,
					singleLine:Boolean=false,
					buttonFrame:uint=1;
					
		public var ignoreButtonFrameOnLining:Boolean ;
				
		/**futer value*/
		public var buttonDisplayObject:*;
		
		/**The ignore button type will prevent button frame controll and all buttons will stay on one line if addInSingleLine was true*/
		public function PopButtonData(Title:String,ButtonFrame:uint=1,Id:* = null,Selectable:Boolean = true,addInSingleLine:Boolean=false,ignoreButtonTypesForLining:Boolean=true)
		{
			title = Title ;
			if(Id != null)
			{
				id = Id ;
			}
			buttonFrame = ButtonFrame ;
			selectable = Selectable ;
			singleLine = addInSingleLine ;
			ignoreButtonFrameOnLining = ignoreButtonTypesForLining ;
		}
	}
}