package tableManager.data
{
	import eventMovie.ThumbnailEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	import tableManager.TableEvents;
	import tableManager.TableManager;
	import tableManager.graphic.Cell;
	import tableManager.graphic.Location;
	
	//import starling.text.TextField;

	
	public class Button extends MovieClip
	{
		[Event(name="BUTTONS_TABLE",type="tableManager.TableEvents")]
		[Event(name="CLICK",type="tableManager.TableEvents")]
		[Event(name="DOWN",type="tableManager.TableEvents")]
		[Event(name="UP",type="tableManager.TableEvents")]
		[Event(name="OVER",type="tableManager.TableEvents")]
		[Event(name="OUT",type="tableManager.TableEvents")]
		[Event(name="RELEASE_OUTSIDE",type="tableManager.TableEvents")]

		private var _paragraph:Paragraph;
		public function get paragraph():Paragraph
		{
			return _paragraph
		}
		
		private var _bg:*;
		public function get bg():*
		{
			return _bg
		}
		private var _backGround:String;
		public function get backGround():String
		{
			return _backGround
		}
		private var _return:*;
		public function get returnValue():*
		{
			return _return
		}
		private var _CellHint:Boolean;
		public function get CellHint():Boolean
		{
			return _CellHint
		}

		private var _textField:TextField=null;
		public function get textField():TextField
		{
			return _textField
		}
		
		private var _Id:int;

		private var _buttonMovie:MovieClip;
		public function get buttonMovie():MovieClip
		{
			return _buttonMovie
		}
		public function get Id():int
		{
			return _Id
		}

		private var delayTime:Timer;
		public function Button(Paragraph_p:Paragraph=null,BackGround_p:String='',Return_p:*=null,CellHint_p:Boolean=false)
		{
			_paragraph = Paragraph_p
			if(BackGround_p!=null)
			{				
				_backGround = BackGround_p
			}
			_return = Return_p
			CellHint_p = CellHint_p
		}
		public function setUp(locationCell_p:Location,ClumSpan_p:Boolean,RowSpan_p:Boolean,Fix_p:Boolean,Cell_p:Cell,Conter_p:int):void
		{
			_Id = Conter_p
			if(_paragraph!=null)
			{
				_textField = _paragraph.getTextField(locationCell_p,ClumSpan_p,RowSpan_p,Fix_p,Cell_p)
			}

			delayTime = new Timer(5)
			delayTime.addEventListener(TimerEvent.TIMER,delayFun)
			delayTime.start()
		}
		
		protected function delayFun(event:TimerEvent):void
		{
			// TODO Auto-generated method stub
			creatCell()
			delayTime.stop()
			delayTime.removeEventListener(TimerEvent.TIMER,delayFun)
			
			
		}
		
		/*protected function compeletCreatCell(event:ThumbnailEvent):void
		{
			// TODO Auto-generated method stub
			
		}*/
		
		private function creatCell():void
		{
			_buttonMovie = new MovieClip()
			if(_backGround!='' && _backGround!=null)
			{
				var components:Class = getDefinitionByName(_backGround) as Class;
				_bg = new components() 
				_buttonMovie.addChild(_bg)	
			}
			if(_textField!=null)
			{
				_buttonMovie.addChild(_textField)	
			}
			sendValue()
		}
		

		public function CLICK(event:MouseEvent):void
		{
			// TODO Auto-generated method stub	
			this.dispatchEvent(new TableEvents(TableEvents.CLICK,this))
		}
		public function DOWN(event:MouseEvent):void
		{
			// TODO Auto-generated method stub	
			this.dispatchEvent(new TableEvents(TableEvents.DOWN,this))
		}

		public function UP(event:MouseEvent):void
		{
			// TODO Auto-generated method stub	
			this.dispatchEvent(new TableEvents(TableEvents.UP,this))
		}
		public function OVER(event:MouseEvent):void
		{
			// TODO Auto-generated method stub	
			this.dispatchEvent(new TableEvents(TableEvents.OVER,this))
		}
		public function OUT(event:MouseEvent):void
		{
			// TODO Auto-generated method stub	
			this.dispatchEvent(new TableEvents(TableEvents.OUT,this))
		}
		public function RELEASE_OUTSIDE(event:MouseEvent):void
		{
			// TODO Auto-generated method stub	
			this.dispatchEvent(new TableEvents(TableEvents.RELEASE_OUTSIDE,this))
		}
		
		private function sendValue():void
		{
			this.dispatchEvent(new TableEvents(TableEvents.BUTTONS_TABLE,this))
		}
	}
}