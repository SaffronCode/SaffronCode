package diagrams.calender
{
	public class CalenderContents
	{
		public var contents:Vector.<CalenderContent> ;
		
		public function CalenderContents()
		{
			contents = new Vector.<CalenderContent>();
		}
		
		public function addContent(id:*,title:String,begin:Date,end:Date,color:uint=0,anonimosData:Object=null)
		{
			if(begin.hours == 0)
			{
				begin.hours = 1 ;
			}
			var newContent:CalenderContent = new CalenderContent(id,title,begin,end,color,anonimosData);
			contents.push(newContent);
		}
	}
}