package diagrams.calender
{
	internal class CalenderContent
	{
		public var id:*;
		
		public var title:String;
		
		public var begin:Date;
		
		public var end:Date ;
		
		public var color:uint ;

		public var data:Object ;
		
		public var isHollyday:Boolean ;
		
		public function CalenderContent(id_v:*,title_v:String,begin_v:Date,end_v:Date,color_v:uint,anonimosData:Object=null,isHollyday:Boolean=false)
		{
			id = id_v;
			title = title_v ;
			begin = begin_v ;
			end = end_v ;
			data = anonimosData ;

			this.isHollyday = isHollyday ;
			
			color = color_v ;
		}
	}
}