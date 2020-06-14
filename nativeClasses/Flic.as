package nativeClasses
{
	import dataManager.GlobalStorage;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mteam.flic.MteamFlicManager;
	import mteam.flic.event.FlicEvent;

	public class Flic extends EventDispatcher
	{
		private static var mteamFlicManager:MteamFlicManager;
		public static const saveDevicePaired:String='saveDevicePaired';
		private  static var _Key:Boolean;
		private static var _ignoreFirstClick:Boolean;
		private static var _onNewDevicePaired:Function,
					_onNoDeviceFound:Function,
					_onPrivateButton:Function,
					_onButtonDown:Function,
					_onButtonUp:Function,
					_error:Function;
					
		public static function get Key():Boolean
		{
			return GlobalStorage.load(saveDevicePaired)!=null && GlobalStorage.load(saveDevicePaired)!='';
		}
		public static function deleteKey():void
		{
			GlobalStorage.Delete(saveDevicePaired);
		}
		public function Flic(target:IEventDispatcher=null)
		{
			super(target);
			SaffronLogger.log('Key :',Key)
			_ignoreFirstClick = !Key;
		}
		public static function setup(onNewDevicePaired_p:Function=null,onNoDeviceFound_p:Function=null,onPrivateButton_p:Function=null,onButtonDown_p:Function=null,onButtonUp_p:Function=null,error_p:Function=null):void
		{
			_onNewDevicePaired = onNewDevicePaired_p;
			_onNoDeviceFound = onNoDeviceFound_p;
			_onPrivateButton = onPrivateButton_p;
			_onButtonDown= onButtonDown_p;
			_onButtonUp= onButtonUp_p;
			_error= error_p;
			try
			{
				SaffronLogger.log('on start init flic')
				mteamFlicManager = new MteamFlicManager();
				mteamFlicManager.addEventListener(FlicEvent.NewDevicePaired,onNewDevicePaired);
				mteamFlicManager.addEventListener(FlicEvent.NoDeviceFound,onNoDeviceFound);
				mteamFlicManager.addEventListener(FlicEvent.buttonDown,onButtonDown);
				mteamFlicManager.addEventListener(FlicEvent.ButtonUp,onButtonUp);
				mteamFlicManager.addEventListener(FlicEvent.PrivateButton,onPrivateButton);
				mteamFlicManager.init();
			}
			catch(e:*)
			{
				_error.call();
				SaffronLogger.log('flic init error')
			}
		}
		
		public static function findNewButton():void
		{
			mteamFlicManager.FindNewButton();
		}
		public static function dispose():void
		{
			mteamFlicManager.dispose();
		}
		
		protected  static function onNewDevicePaired(event:FlicEvent)
		{ 			
			GlobalStorage.save(saveDevicePaired,'oneDevaisePaired');
			_onNewDevicePaired.call();
			SaffronLogger.log('******onNewDevicePaired*****')	
		}
		
		protected static function onNoDeviceFound(event:FlicEvent)
		{
			_onNoDeviceFound.call();
			SaffronLogger.log('onNoDeviceFound')
		}
		
		protected static function onPrivateButton(event:FlicEvent)
		{		
			_onPrivateButton.call();
			SaffronLogger.log('onPrivateButton')
		}
		protected static  function onButtonDown(event:FlicEvent)
		{
			if(lastClick(event.ButtonId))_onButtonDown.call();
		}
		protected static function onButtonUp(event:FlicEvent)
		{
			if(lastClick(event.ButtonId))_onButtonUp.call();
		}
		private static function lastClick(ButtonId_p:String):Boolean
		{
			SaffronLogger.log('Number(ButtonId_p) :',Number(ButtonId_p), '_ignoreFirstClick :',_ignoreFirstClick);
			if(Number(ButtonId_p)==0 && !_ignoreFirstClick)
			{
				return true;
			}
			_ignoreFirstClick = Number(ButtonId_p)>0;
			return false;
		}

		
	}
}