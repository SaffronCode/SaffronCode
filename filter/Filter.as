package filter
{//filter.Filter
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
[Event(name="SELECT", type="filter.FilterEvent")]	
	public class Filter extends MovieClip
	{
		private var _filterAanimateMc:FilterAnimate;
			
		private var _removeChildArray:Array;	
		public var status:Boolean = false
		public var totalITem:int=1;
		public function Filter()
		{
			super();
			_filterAanimateMc = Obj.get('filterAnimat_mc',this)
			this.visible = false
			_removeChildArray = new Array()	
		}
		
		protected function select(Id_p):void
		{
			// TODO Auto-generated method stub
			status = !status
			setup(status,Id_p)
			this.dispatchEvent(new FilterEvent(FilterEvent.SELECT,Id_p))
		}
		public function setup(Opened_p:Boolean=false,Id_p:int=1):void
		{
			if(!this.visible)this.visible = true
			status = Opened_p
			if(_filterAanimateMc!=null)
			{
				_filterAanimateMc.visible = true
				_filterAanimateMc.gotoAndPlay(1)
				_filterAanimateMc.setup(Id_p,select)	
				totalITem = _filterAanimateMc.totalItems	
			}
			if(Opened_p)
			{
				var _yStep:Number=0
				for(var i:int=1;i<=totalITem;i++)
				{
					if(i!=Id_p)
					{
						_yStep++
						var _filterAnimate:FilterAnimate = new FilterAnimate()
						this.addChild(_filterAnimate)
						_removeChildArray.push(_filterAnimate)	
						_filterAnimate.setup(i,select)	
						_filterAnimate.y = _filterAanimateMc.y-(_yStep*_filterAnimate.height)
						_filterAnimate.x = _filterAanimateMc.x
						_filterAnimate.addEventListener(FilterEvent.SELECT,select)	
					}	
				}
			}
			else
			{
				for(var r:int=0;r<_removeChildArray.length;r++)
				{
					this.removeChild(_removeChildArray[r])
				}
				_removeChildArray = new Array()
			}
			
		}
	}
}