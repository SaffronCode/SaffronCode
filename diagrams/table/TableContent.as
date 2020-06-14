package diagrams.table
{
	public class TableContent
	{
		internal var contentList:Vector.<ContentValue>
		
		public function TableContent()
		{
			contentList = new Vector.<ContentValue>();
		}
		
		public function addData(Vid:uint,Hid:uint,Title:String,Color:int=-1):void
		{
			if(Color == -1)
			{
				Color = TableConstants.Color_backBoxColor ;
			}
			var newContent:ContentValue = new ContentValue(Vid,Hid,Title,Color);
			for(var i = 0 ; i<contentList.length ; i++)
			{
				if(contentList[i].hid == Hid && contentList[i].vid == Vid)
				{
					//SaffronLogger.log("Data deleted");
					contentList.splice(i,1);
					i--;
				}
			}
			contentList.push(newContent);
		}
	}
}