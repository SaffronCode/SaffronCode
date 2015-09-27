package diagrams.table
{
	public class TableTitleValue
	{
		
		/**↨*/
		internal var 	VTitles:Vector.<TitleVal>;
		/**▬*/
		internal var 	HTitles:Vector.<TitleVal> ;
		
		public function TableTitleValue()
		{
			VTitles = new Vector.<TitleVal>();
			HTitles = new Vector.<TitleVal>();
		}
		
		/**↨*/
		public function addVerticalTitle(title:String,id:uint):void
		{
			var newTitle:TitleVal = new TitleVal(title,id);
			controllDuplicatedId(VTitles,id);
			VTitles.push(newTitle);
		}
		
		/**▬*/
		public function addHorizontalTitle(title:String,id:uint):void
		{
			var newTitle:TitleVal = new TitleVal(title,id);
			controllDuplicatedId(HTitles,id);
			HTitles.push(newTitle);
		}
		
		/**This will throw error if the id is duplicated*/
		private function controllDuplicatedId(vec:Vector.<TitleVal>,id:uint):void
		{
			for(var i = 0 ; i<vec.length ; i++)
			{
				if(vec[i].ID == id)
				{
					throw "Current ID "+(id)+"is duplicated";
				}
			}
		}
		
	}
}