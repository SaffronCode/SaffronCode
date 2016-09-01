package filter
{//filter.FilterAnimate
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class FilterAnimate extends MovieClip
	{
		private var _id:int;
		private var filterItemMc:MovieClip
		public var totalItems:int=1;
		private var _fun:Function;
		public function FilterAnimate()
		{
			super();
			filterItemMc = Obj.get('filterItem_mc',this)
			this.addEventListener(MouseEvent.CLICK,selected)
		}
		
		protected function selected(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			_fun(_id)					
		}
		public function setup(Id_p,Fun_p:Function=null):void
		{
			_id = Id_p
			_fun = Fun_p	
			if(filterItemMc!=null)
			{
				filterItemMc.gotoAndStop(Id_p)
				totalItems = filterItemMc.totalFrames	
			}
		}
	}
}