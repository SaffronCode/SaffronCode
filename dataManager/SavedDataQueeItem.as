package dataManager
{
	internal class SavedDataQueeItem
	{
		public var id:String ;
		
		public var data:* ;
		
		public var date:uint ;
		
		public function SavedDataQueeItem(Id:String,Data:*,DateVal:uint)
		{
			id = Id ;
			data = Data ;
			date = DateVal ;
		}

	}
}