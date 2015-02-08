package diagrams.instagram
{
	public class InstagramData
	{
		private static var curretnID:uint = 0 ;
		
		public var title:String;
		public var id:uint;
		public var color:uint;
		
		/**Values are sorting by Hvalues ↔*/
		public var values:Vector.<InstaDataValue> ;
		
		/**Start the ids from 1*/
		public function InstagramData(title_v:String,color_v:uint,id_v:uint=0)
		{
			title = title_v ;
			color = color_v ;
			
			if(id_v == 0)
			{
				curretnID++ ;
				id = curretnID;
			}
			else
			{
				id = id_v ;
			}
			
			values = new Vector.<InstaDataValue>();
		}
		
		/**This will sort your datas by Horizontal ↔ values*/
		public function addData(instaData:InstaDataValue)
		{
			var newData:InstaDataValue = instaData ;
			for(var i = 0 ; i< values.length && newData>values[i] ; i++){}
			var replcate = (values.length>i && newData.Hval == values[i].Hval)?1:0;
			values.splice(i,replcate,newData);
		}
		
		
		public function toString()
		{
			return id ;
		}
	}
}