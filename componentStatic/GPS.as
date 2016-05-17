package componentStatic
{
	import appManager.animatedPages.MainAnim;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import map.AddMarker;
	import map.DisplayMapOption;
	import map.GeoLocation;
	import map.MapEvent;
	import map.Marker;
	
	import stageManager.StageManager;


	public class GPS extends ComponentManager
	{
		private var mapAreaMc:MovieClip,
					setLocationMc:MovieClip;

		private var addmarker:AddMarker;
		private var _idTimeOut:uint;
		public function GPS()
		{
			super();
			mapAreaMc = Obj.get('mapArea_mc',this)	
			setLocationMc =Obj.get('setLocatoin_mc',this)	
			if(setLocationMc!=null)
			{
				setLocationMc.addEventListener(MouseEvent.CLICK,setlocatoin_fun)
			}
		
		}
		
		protected function setlocatoin_fun(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(GeoLocation.marker!=null)
			{
				heideMap()
				addNewMarker(GeoLocation.marker)
			}
		}
		public function showMap(event=null):void
		{
			if(mapAreaMc!=null)
			{	
				
				var marker:Marker=null;
				if(DevicePrefrence.isItPC)
				{
					marker = new Marker(35.7137559,51.4149215)	
				}
				else if(GeoLocation.marker!=null)
				{
					marker = GeoLocation.marker
				}
				
				
					
				if(getObj('Lat')!=null && getObj('Lon')!=null)
				{
					marker = new Marker(getObj('Lat'),getObj('Lon'))						
				}			
				
				if(marker!=null)
				{
					addNewMarker(marker)
					clearTimeout(_idTimeOut)
				}
				else
				{
					clearTimeout(_idTimeOut)
					_idTimeOut = setTimeout(showMap,2000)
					trace('time out')		
				}

			}
		}
		
		private function addNewMarker(Marker_p:Marker):void
		{
			error(setObj('Lat',Marker_p.lat))
			error(setObj('Lon',Marker_p.lng))
			var markerList:Vector.<Marker>= new Vector.<Marker>()
			markerList.push(Marker_p)
			mapAreaMc.visible = false
			addmarker = new AddMarker(markerList)
			var displayMap:DisplayMapOption = new DisplayMapOption()
			displayMap.marker = true
			displayMap.area = mapAreaMc.getBounds(this.stage)	
			displayMap.markerAndPanTo = true
			displayMap.defaultZoom = 16	
			displayMap.showAllMarker = false	
			displayMap.fullScreenArea = new Rectangle(0,0-(StageManager.stageDelta.height/2),768,1024+StageManager.stageDelta.height)	
			addmarker.setup(this,displayMap)
			addmarker.addEventListener(MapEvent.GET_MARKER_LIST,markerList_fun)	
		}
		
		public function heideMap():void
		{
			if(addmarker!=null)
			{
				addmarker.hideMap()
				addmarker = null	
			}
		}
		protected function markerList_fun(event:MapEvent):void
		{
			// TODO Auto-generated method stub
			var _marker:Marker = event.makerList[event.makerList.length-1]		
			error(setObj('Lat',_marker.lat))
			error(setObj('Lon',_marker.lng))
			
			
		}
	}
}