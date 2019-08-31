package diagrams.calender
{
	import contents.alert.Alert;

	public class CalenderContents
	{
		public var contents:Vector.<CalenderContent> ;
		
		public function CalenderContents()
		{
			contents = new Vector.<CalenderContent>();
		}
		
		public function addContent(id:*,title:String,begin:Date,end:Date,color:uint=0,anonimosData:Object=null,isHollyday:Boolean=false):void
		{
			if(begin.hours == 0)
			{
				begin.hours = 1 ;
			}
			var newContent:CalenderContent = new CalenderContent(id,title,begin,end,color,anonimosData,isHollyday);
			contents.push(newContent);
		}

		public function removeContent(id:*):void
		{
			
			for(var i:int = 0;i<contents.length;i++)
			{
				if(contents[i].id == id)
				{
					contents.removeAt(i);
				}
			}
		}

		public function editContent(id:*,title:String,begin:Date,end:Date,color:uint=0,isHollyday:Boolean=false):void
		{
			for(var i:int = 0;i<contents.length;i++)
			{
				if(contents[i].id == id)
				{
					contents[i].title = title;
					contents[i].begin = begin;
					contents[i].end = end;
					contents[i].color = color;
					contents[i].isHollyday = isHollyday;
				}
			}
		}

		public function getContent(id:*):CalenderContent
		{
			
			for(var i:int = 0;i<contents.length;i++)
			{
				if(contents[i].id == id)
				{
					return contents[i];
				}
			}
			return null;
		}
	}
}