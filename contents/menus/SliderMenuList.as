package contents.menus
// contents.menus.SliderMenuList
{
	import flash.display.MovieClip;
	import contents.displayPages.DynamicLinks;
	import appManager.displayContentElemets.VersionTracer;
	import flash.utils.setTimeout;
	import stageManager.StageManager;
	import stageManager.StageManagerEvent;
	import contents.Contents;
	import contents.PageData;

	public class SliderMenuList extends MovieClip
	{
		private var _dynamicLink:DynamicLinks,
					_versionTrace:VersionTracer;
		private var _dynamicLinkH:Number,_versionY:Number;
		public function SliderMenuList()
		{
			super();
			_dynamicLink = Obj.findThisClass(DynamicLinks,this);
			_versionTrace = Obj.findThisClass(VersionTracer, this);	
            _dynamicLinkH = _dynamicLink.height;
            _versionY = _versionTrace.y;
			setTimeout(setup, 0);
			
		}

		
		private function setup():void 
		{
			StageManager.eventDispatcher.addEventListener(StageManagerEvent.STAGE_RESIZED, updaetListSize);
			updaetListSize();
		}
		
		

		private function updaetListSize(e:StageManagerEvent=null):void
		{
			_versionTrace.y =  Contents.config.stageRect.height;
			_dynamicLink.height = _dynamicLinkH + StageManager.stageDelta.height;
			setMenu();
		
		}
		
		private function setMenu():void
		{
			var _pageData:PageData = Contents.getPage('home');
			if(_dynamicLink!=null)
			{
				_dynamicLink.height=_dynamicLinkH+StageManager.stageDelta.height;
				_dynamicLink.setUp(_pageData);
			}
			if(_versionTrace!=null)
			{
				_versionTrace.y =_versionY+StageManager.stageDelta.height;
			}
		}
	}
}