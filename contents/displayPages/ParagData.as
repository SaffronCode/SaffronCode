package contents.displayPages
{
	public class ParagData
	{
		public var content:String,
					imageURL:String;
		
		public function ParagData(Content:String,ImageURL:String)
		{
			content = Content ;
			imageURL = ImageURL ;
		}
		
		public function toString():String
		{
			return '[content = '+content+' , imageURL = '+imageURL+']';
		}
	}
}