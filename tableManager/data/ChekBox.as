package tableManager.data
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	import tableManager.TableEvents;

	[Event(name="RADIOBUTTON_TABLE",type="tableManager.TableEvents")]
	[Event(name="CLICK",type="tableManager.TableEvents")]
	[Event(name="DOWN",type="tableManager.TableEvents")]
	[Event(name="UP",type="tableManager.TableEvents")]
	[Event(name="OVER",type="tableManager.TableEvents")]
	[Event(name="OUT",type="tableManager.TableEvents")]
	[Event(name="RELEASE_OUTSIDE",type="tableManager.TableEvents")]
	public class ChekBox extends MovieClip
	{
		public static const SELECT:String="true",
			DESELECT:String="false";	
		private var _chekBox:*
		public function get chekBox():*
		{
			return _chekBox
		}
	
		private var _return:Boolean;
		public function get returnValue():Boolean
		{
			return _return
		}
		private var _id:int;
		public function get id():int
		{
			return _id
		}
		private var _className:String;
		public function get className():String
		{
			return _className
		}
		
		private var _status:String;
		public function status():String
		{
			return _status
		}
		private var delayTimver:Timer = new Timer(1)	
		public function ChekBox(ClassName_p:String,Id_p:int=0,Status_p:String=DESELECT,ReturnOnValueOnCreat_p:Boolean = false)
		{	
			if(Status_p == DESELECT)
			{
				_return = false
			}
			else
			{
				_return = true
			}
			_id = Id_p	
			_className = ClassName_p
			_status = Status_p
			if(ReturnOnValueOnCreat_p)
			{
				delayTimver.addEventListener(TimerEvent.TIMER,delay_fun)
				delayTimver.start()
			}
		}
		public function setUp():*
		{
			var components:Class = getDefinitionByName(_className) as Class;
			_chekBox = new components() 
			_chekBox.gotoAndStop(_status)
			return 	_chekBox
		}
		public function CLICK(event:MouseEvent):void
		{
			
			_return = !_return
			_chekBox.gotoAndStop(_return)		
			this.dispatchEvent(new TableEvents(TableEvents.CLICK,null,null,null,null,null,this))
			
		
		}
		///////////////
		public function DOWN(event:MouseEvent):void
		{
			
			this.dispatchEvent(new TableEvents(TableEvents.DOWN,null,null,null,null,null,this))
		}
		
		public function UP(event:MouseEvent):void
		{
			
			this.dispatchEvent(new TableEvents(TableEvents.UP,null,null,null,null,null,this))
		}
		public function OVER(event:MouseEvent):void
		{
			
			this.dispatchEvent(new TableEvents(TableEvents.OVER,null,null,null,null,null,this))
		}
		public function OUT(event:MouseEvent):void
		{
			
			this.dispatchEvent(new TableEvents(TableEvents.OUT,null,null,null,null,null,this))
		}
		public function RELEASE_OUTSIDE(event:MouseEvent):void
		{
			
			this.dispatchEvent(new TableEvents(TableEvents.RELEASE_OUTSIDE,null,null,null,null,null,this))
		}
		protected function delay_fun(event:TimerEvent):void
		{
			
			delayTimver.stop()
			delayTimver.removeEventListener(TimerEvent.TIMER,delay_fun)
			this.dispatchEvent(new TableEvents(TableEvents.CLICK,null,null,null,null,null,this))
		}
	}
}