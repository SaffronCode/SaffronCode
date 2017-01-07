package tableManager.data
{

	
	import eventMovie.ThumbnailEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	import tableManager.TableEvents;
	import tableManager.graphic.Cell;
	import tableManager.graphic.Table;

	public class RadioButtons extends MovieClip
	{
		[Event(name="RADIOBUTTON_TABLE",type="tableManager.TableEvents")]
		[Event(name="CLICK",type="tableManager.TableEvents")]
		[Event(name="DOWN",type="tableManager.TableEvents")]
		[Event(name="UP",type="tableManager.TableEvents")]
		[Event(name="OVER",type="tableManager.TableEvents")]
		[Event(name="OUT",type="tableManager.TableEvents")]
		[Event(name="RELEASE_OUTSIDE",type="tableManager.TableEvents")]
		public static const SELECT:String="select",
							DESELECT:String="deselect";	
		private var _radioButton:*
		public function get radioButton():*
		{
			return _radioButton
		}
		private var _groupId:int;
		public function get groupId():int
		{
			return _groupId
		}
		
		private var _return:*;
		public function get returnValue():*
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
		private var _list:Vector.<Cell> = new Vector.<Cell>()
			
		private var delayTimver:Timer = new Timer(1)	
		public function RadioButtons(ClassName_p:String,GroupId_p:int,Return_p:*=null,Id_p:int=0,Status_p:String=DESELECT,ReturnOnValueOnCreat_p:Boolean = false)
		{
			_groupId = GroupId_p	
			_return = Return_p
			_id = Id_p	
			_className = ClassName_p
			_status = Status_p
			if(ReturnOnValueOnCreat_p)
			{
				delayTimver.addEventListener(TimerEvent.TIMER,delay_fun)
				delayTimver.start()
			}
		}
		
		protected function delay_fun(event:TimerEvent):void
		{
			
			delayTimver.stop()
			delayTimver.removeEventListener(TimerEvent.TIMER,delay_fun)
			this.dispatchEvent(new TableEvents(TableEvents.CLICK,null,null,this))
		}
		
		public function setUp(List_p:Vector.<Cell>):*
		{
			var components:Class = getDefinitionByName(_className) as Class;
			_radioButton = new components() 
			_radioButton.gotoAndStop(_status)
			_list = List_p	
			return 	_radioButton
		}
		
		public function CLICK(event:MouseEvent):void
		{
			
			this.dispatchEvent(new TableEvents(TableEvents.CLICK,null,null,this))

			for(var i:int=0;i<_list.length;i++)
			{
				if(_list[i].TypeCell.getType() == "[object RadioButtons]")
				{
					if(_list[i].TypeCell.RadioButtonTaype._groupId== _groupId)
					{
						_list[i].TypeCell.RadioButtonTaype._radioButton.gotoAndStop(DESELECT)
					}					
				}				
			}
			_radioButton.gotoAndStop(SELECT)
		}
		public function DOWN(event:MouseEvent):void
		{
			
			this.dispatchEvent(new TableEvents(TableEvents.DOWN,null,null,this))
		}
		
		public function UP(event:MouseEvent):void
		{
			
			this.dispatchEvent(new TableEvents(TableEvents.UP,null,null,this))
		}
		public function OVER(event:MouseEvent):void
		{
			
			this.dispatchEvent(new TableEvents(TableEvents.OVER,null,null,this))
		}
		public function OUT(event:MouseEvent):void
		{
			
			this.dispatchEvent(new TableEvents(TableEvents.OUT,null,null,this))
		}
		public function RELEASE_OUTSIDE(event:MouseEvent):void
		{
			
			this.dispatchEvent(new TableEvents(TableEvents.RELEASE_OUTSIDE,null,null,this))
		}


	}
}