package popForm
{
	public class PopButtonData
	{
		public var title:String,
					id:*,
					selectable:Boolean = true,
					singleLine:Boolean=false,
					buttonFrame:uint=1;
					
					
		/**If the button have LightImage in it, this can load the button image on it*/
		public var buttonImage:String ;
					
		public var ignoreButtonFrameOnLining:Boolean ;
				
		/**futer value*/
		public var buttonDisplayObject:*;
		
		/**The ignore button type will prevent button frame controll and all buttons will stay on one line if addInSingleLine was true<br>
		 * You can pass the image url and the button should have a lightImage in it to be able to show button image<br>
		 * ButtonFram 0 means invisible button*/
		public function PopButtonData(Title:String,ButtonFrame:uint=1,Id:* = null,Selectable:Boolean = true,addInSingleLine:Boolean=false,ignoreButtonTypesForLining:Boolean=true,imageURL:String='')
		{
			buttonImage = imageURL;
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