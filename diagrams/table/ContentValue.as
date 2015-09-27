package diagrams.table
{
	internal class ContentValue
	{
		public var vid:uint,hid:uint,
					title:String,
					color:uint;
		
		public function ContentValue(Vid:uint,Hid:uint,Title:String,Color:uint)
		{
			vid = Vid ;
			hid = Hid ;
			title = Title ;
			color = Color ;
		}
	}
}