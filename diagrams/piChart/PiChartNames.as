package diagrams.piChart
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class PiChartNames extends MovieClip
	{
		private var text:TextField ;
		
		public function PiChartNames()
		{
			super();
			
			text = Obj.get("text_txt",Obj.get("text_txt",this));
		}
		
		public function setUp(piCartValue:PiChartValues,index:uint)
		{
			//text.text = UnicodeStatic.convert(piCartValue.names[index]);
			TextPutter.OnButton(text,piCartValue.names[index],true);
		}
	}
}