package diagrams.piChart
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class PiChart extends MovieClip
	{
		private var myDiameter:Number,
					myRadius:Number;
					
		private var pieces:Vector.<MovieClip>;
		private var myPiecesData:PiChartValues;
		
		public static const pi:Number = 3.141 ;
		public static const pi_2:Number = pi/2 ;
		public static const pi2:Number = pi*2 ;
		
		private static const steps:Number = 0.01 ;
		
		private var showingPrecent:Number ;
		private var animSpeed:Number = 10;
		private var backColor:uint;
		
		private var myChartName:Class ;
		
		/**name objectClass has to extend from PiChartNames*/
		public function PiChart(diameter:Number,backGroundColor:uint,nameObjectClass:Class)
		{
			super();
			
			myChartName = nameObjectClass ;
			
			backColor = backGroundColor ;
			
			myDiameter = diameter ;
			myRadius = myDiameter/2;
			
			pieces = new Vector.<MovieClip>();
		}
		
		public function setUp(piChartValues:PiChartValues)
		{
			myPiecesData = piChartValues ;
			
			showingPrecent = 0 ;
			
			for(var i = 0 ; i<myPiecesData.colors.length ; i++)
			{
				var newPiece:MovieClip = new MovieClip();
				this.addChild(newPiece);
				newPiece.x = myRadius ;
				newPiece.y = myRadius ;
				
				pieces.push(newPiece);
			}
			this.addEventListener(Event.ENTER_FRAME,draws);
		}
		
		protected function draws(event:Event):void
		{
			
			showingPrecent+=(1-showingPrecent)/animSpeed;
			if(showingPrecent>0.999)
			{
				showingPrecent = 1 ;
				SaffronLogger.log("done");
				this.removeEventListener(Event.ENTER_FRAME,draws);
				
				showTheNames();
			}
			drawPi();
		}
		
		private function showTheNames():void
		{
			
			for(var i = 0 ; i<myPiecesData.names.length ; i++)
			{
				if(myPiecesData.pieceNumbers[i]==0)
				{
					continue ;
				}
				var newName:PiChartNames = new myChartName() ;
				newName.setUp(myPiecesData,i) ;
				var area:Rectangle = pieces[i].getBounds(this) ;
				SaffronLogger.log("myPiecesData.centerDegree["+i+"] : "+myPiecesData.centerDegree[i]/PiChart.pi*180);
				newName.x = myRadius+Math.sin(myPiecesData.centerDegree[i])*(myRadius/2) ;
				newName.y = myRadius+Math.cos(myPiecesData.centerDegree[i])*-1*(myRadius/2) ;
				
				this.addChild(newName);
				
				newName.alpha = 0 ;
				AnimData.fadeIn(newName);
			}
		}
		
		private function drawPi()
		{
			var gra:Graphics ;
			var minDegree:Number = 0 ;
			var maxDegree:Number = 0 ;
			for(var i = 0 ; i<pieces.length ; i++)
			{
				//SaffronLogger.log("minDegree : "+minDegree+"  vs  maxDegree : "+maxDegree);
				
				gra = pieces[i].graphics ;
				gra.clear() ;
				gra.beginFill(myPiecesData.colors[i]) ;
				gra.lineStyle(5,backColor) ;
				maxDegree = (myPiecesData.precents[i]*pi2+minDegree)*showingPrecent ;
				for( minDegree ; minDegree<=maxDegree ; minDegree += steps )
				{
					gra.lineTo(myRadius*Math.sin(minDegree),myRadius*Math.cos(minDegree)*-1);
				}
				minDegree = maxDegree ;
				gra.lineTo(myRadius*Math.sin(minDegree),myRadius*Math.cos(minDegree)*-1);
			}
		}
	}
}