package diagrams.piChart
{
	public class PiChartValues
	{
		/**Color of each piece*/
		public var colors:Vector.<uint>;
		
		/**Name of each piece*/
		public var names:Vector.<String>;
		
		/**Precent of each piece*/
		public var precents:Vector.<Number>;
		
		public var pieceNumbers:Vector.<Number>;
		
		public var centerDegree:Vector.<Number>;
		
		/**Sum of all pieces numbers*/
		private var totals:Number ;
		
		public function PiChartValues()
		{
			totals = 0 ;
			
			colors = new Vector.<uint>();
			names = new Vector.<String>();
			precents = new Vector.<Number>();
			pieceNumbers = new Vector.<Number>();
			centerDegree = new Vector.<Number>();
		}
		
		/**add one more piece*/
		public function addPiece(pieceColor:uint,pieceName:String,pieceNumber:Number)
		{
			colors.push(pieceColor);
			names.push(pieceName);
			pieceNumbers.push(pieceNumber);
			
			totals += pieceNumber ;
			
			var minDegree:Number = 0 ;
			var maxDegree:Number = 0 ;
			for(var i = 0 ; i<pieceNumbers.length ; i++)
			{
				precents[i] = pieceNumbers[i]/totals ;
				var myDegree = precents[i]*PiChart.pi2;
				centerDegree[i] = (myDegree)/2+minDegree;
				trace(">>maxDegree : "+centerDegree[i]/PiChart.pi*180);
				maxDegree = minDegree+myDegree ;
				minDegree = maxDegree ;
			}
		}
	}
}