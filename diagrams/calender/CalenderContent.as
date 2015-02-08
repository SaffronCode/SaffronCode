package diagrams.calender
{
	public class CalenderContent
	{
		public var id:*;
		
		public var title:String;
		
		public var begin:Date;
		
		public var end:Date ;
		
		public var color:uint ;
		
		public function CalenderContent(id_v:*,title_v:String,begin_v:Date,end_v:Date,color_v:uint)
		{
			id = id_v;
			title = title_v ;
			begin = begin_v ;
			end = end_v ;
			
			
			color = color_v ;
		}
	}
}