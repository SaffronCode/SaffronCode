package tableManager.data
{	
	import appManager.displayContentElemets.InputTextField;
	
	import flash.display.*;
	import flash.events.*;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.SoftKeyboardType;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	import tableManager.TableEvents;


	public class NumberRangeTable extends MovieClip
	{
		[Event(name="NUMBER_RANGE_TABLE",type="tableManager.TableEvents")]
		private var target:*;
		
		private var outTimeStart:Timer,
					 steepTimer:Timer;
					 
		public var status:String,
					splitCar:String,
					direction:String;
		public var startNumber:Number,
					 totalNumber:*,
					 steep:Number,
					 _className:String,
					 currentNumber:Number;
		public var id:int,
					_name:String,
		splitRange:int,
				outTimeStartValue:int,
				steepTimerValue;
		public var startOut:Boolean,
					showDefaultValue:Boolean;
		private var delayTimver:Timer = new Timer(1)	
		
		private var setButton:SetButton = new SetButton();
		
		/**dar in class mitavan mahdode ee az adad ra namayesh dad va hamchenin tavasote karbar on ra taghiir dad chenanche meghdar faghat
		 *jahate namayesh bashad mitavan button haye up va down ra hazf karde va mohkeli baraye darkarde class nadarad hamchenin mitavan
		 * adade namayesh dade shode ra be goroh haye delkha az ham joda kard masalan baraye namayeshe mabalegh
		 * */
		public function NumberRangeTable(Class_p:String,Id_p:int,Name_p:String,startNumber_p:Number,currentNumber_p:Number,totalNumber_p:*=null,steep_p:Number=1,splitRange_p:int=0,direction_p:String="left",splitCar_p:String=",",outTimeStartValue_p:int=1000,steepTimerValue_p:int=100,showDefaultValue_p:Boolean=false,ReturnOnValueOnCreat_p:Boolean= false)
		{
			var combpn
			id = Id_p
			_name = Name_p	
			_className = Class_p
			steep = steep_p
			startNumber = startNumber_p	
			splitRange = splitRange_p
			splitCar = splitCar_p
			direction = direction_p
			showDefaultValue = showDefaultValue_p	
			currentNumber = currentNumber_p
			outTimeStartValue = outTimeStartValue_p
			steepTimerValue = steepTimerValue_p
			totalNumber = totalNumber_p
			if(ReturnOnValueOnCreat_p)
			{
				delayTimver.addEventListener(TimerEvent.TIMER,delay_fun)
				delayTimver.start()
			}
		}
		
		public function setUp():*
		{
			var components:Class = getDefinitionByName(_className) as Class;
			 target = new components() 

			FarsiInputCorrection.clear(target.valueText)	
			if(totalNumber==null)
			{
				totalNumber = getTextBoxTotalNumber(target.valueText.maxChars)
			}
			else
			{
				totalNumber = totalNumber
			}
			
			outTimeStart = new Timer(outTimeStartValue)
			steepTimer = new Timer(steepTimerValue)			
			target.valueText.addEventListener(Event.CHANGE,changeTextBox_Fun);
			if(target["up"]!=null) 
			{
				target.up.stop()
				target.up.addEventListener(MouseEvent.MOUSE_UP,up_fun)
				target.up.addEventListener(MouseEvent.MOUSE_DOWN,up_mouse_down_fun)	
				target.up.addEventListener(MouseEvent.RELEASE_OUTSIDE,release_outside_fun)
				target.up.addEventListener(MouseEvent.MOUSE_OVER,up_mouse_over_fun)	
				target.up.addEventListener(MouseEvent.MOUSE_OUT,up_mouse_out_fun)	
			}
			if(target["down"]!=null)
			{
				target.down.stop()
				target.down.addEventListener(MouseEvent.MOUSE_UP,up_fun)
				target.down.addEventListener(MouseEvent.MOUSE_DOWN,down_mouse_down_fun)					
				target.down.addEventListener(MouseEvent.RELEASE_OUTSIDE,release_outside_fun)	
				target.down.addEventListener(MouseEvent.MOUSE_OVER,down_mouse_over_fun)
				target.down.addEventListener(MouseEvent.MOUSE_OUT,down_mouse_out_fun)
			}
			setValueText_fun(currentNumber,showDefaultValue)	
			//FarsiInputCorrection.setUp(target.valueText)
			return 	target
		}

		protected function delay_fun(event:TimerEvent):void
		{
			// TODO Auto-generated method stub
			delayTimver.stop()
			delayTimver.removeEventListener(TimerEvent.TIMER,delay_fun)
			sendValue()
		}

		private function setValueText_fun(currentNumber_p:Number,showDefaultValue_p:Boolean=false):void
		{
			if(splitRange!=0)
			{
				target.valueText.text = splitRange_fun(currentNumber_p,splitRange,splitCar,direction)
			}
			else if(!showDefaultValue_p)
			{
				target.valueText.text = ""
			}
			else
			{
				target.valueText.text = currentNumber_p
			}
			if(target["up"]!=null)
			{
				if(!setButton.setButtons_fun(startNumber,totalNumber,currentNumber_p)[1])
				{
					target.up.mouseEnabled = false
					target.up.alpha = 0.3
					stopSteepTimer_fun()
				}
				if(setButton.setButtons_fun(startNumber,totalNumber,currentNumber_p)[1])
				{
					target.up.mouseEnabled = true
					target.up.alpha = 1
				}
			}
			if(target["down"]!=null)
			{
				if(!setButton.setButtons_fun(startNumber,totalNumber,currentNumber_p)[2])
				{
					target.down.mouseEnabled = false
					target.down.alpha = 0.3
					stopSteepTimer_fun()
				}
				if(setButton.setButtons_fun(startNumber,totalNumber,currentNumber_p)[2])
				{
					target.down.mouseEnabled = true
					target.down.alpha = 1
				}
			}
			currentNumber = currentNumber_p
		}
		
		private function sendValue():void
		{
			this.dispatchEvent(new TableEvents(TableEvents.NUMBER_RANGE_TABLE,null,null,null,this))	
		}
		private function runNumberRagne_fun():void
		{
			if(status=="up")
			{
				setValueText_fun(currentNumber+=steep,true)
				sendValue()
			}
			else if(status=="down")
			{
				setValueText_fun(currentNumber-=steep,true)
				sendValue()
			}			
		}
		private function up_fun(evt:MouseEvent):void
		{
			if(!startOut)runNumberRagne_fun()
			stopOutSteepTimer_fun()
			stopSteepTimer_fun()
		}
		private function up_mouse_down_fun(evt:MouseEvent):void
		{
			status = "up"
			outTimeStart.addEventListener(TimerEvent.TIMER,startOutSteepTimer_fun)
			outTimeStart.start()
			if(target["up"]!=null) target.up.gotoAndStop("down")
		}
		private function up_mouse_over_fun(evt:MouseEvent):void
		{
			if(target["up"]!=null) target.up.gotoAndStop("over")
		}
		private function up_mouse_out_fun(evt:MouseEvent):void
		{
			if(target["up"]!=null) target.up.gotoAndStop("out")
		}
		private function release_outside_fun(evt:MouseEvent):void
		{
			stopOutSteepTimer_fun()
			stopSteepTimer_fun()
		}

		private function down_mouse_down_fun(evt:MouseEvent):void
		{
			status = "down"
			outTimeStart.addEventListener(TimerEvent.TIMER,startOutSteepTimer_fun)
			outTimeStart.start()
			if(target["down"]!=null) target.down.gotoAndStop("down")
		}
		private function down_mouse_over_fun(evt:MouseEvent):void
		{
			if(target["down"]!=null) target.down.gotoAndStop("over")
		}
		private function down_mouse_out_fun(evt:MouseEvent):void
		{
			if(target["down"]!=null) target.down.gotoAndStop("out")
		}

		private function startOutSteepTimer_fun(evt:TimerEvent):void
		{
			startOut = true
			stopOutSteepTimer_fun()
			steepTimer.addEventListener(TimerEvent.TIMER,startSteepTimer_fun)
			steepTimer.start()
		}
		private function stopOutSteepTimer_fun():void
		{
			outTimeStart.stop()
			outTimeStart.reset()
			outTimeStart.removeEventListener(TimerEvent.TIMER,startOutSteepTimer_fun)	
		}
		private function startSteepTimer_fun(evt:TimerEvent):void
		{
			runNumberRagne_fun()
		}
		private function stopSteepTimer_fun():void
		{
			startOut = false
			steepTimer.start()
			steepTimer.reset()
			steepTimer.removeEventListener(TimerEvent.TIMER,startSteepTimer_fun)
		}
		private function splitRange_fun(value_p:*,splitRange_p:int,car_p:String,direction_p:String):String
		{
			var splitValueArray:Array = new Array()
			var valToString:String = value_p.toString()
			var split:String			
			while(valToString.length>splitRange_p)
			{
				if(direction == "left")
				{
					split = valToString.substr(valToString.length-splitRange_p,valToString.length)
					valToString = valToString.substr(0,valToString.length-splitRange_p)	
					splitValueArray.push(split)
				}
				else if(direction == "right")
				{
					split = valToString.substr(0,splitRange_p)
					valToString = valToString.substr(splitRange_p,valToString.length)
					splitValueArray.push(split)
				}
			}	
			if(valToString.length!=0)splitValueArray.push(valToString)			
			if(direction == "left")splitValueArray.reverse()
			return splitValueArray.join(car_p)
		}
		private function eliminationSplit_fun(str_p:String,car_p:String):String
		{			
			return str_p.split(car_p).join("") 	
		}
		public function reset():void
		{
			setValueText_fun(currentNumber,showDefaultValue)
			sendValue()
		}
		private function changeTextBox_Fun(evt:Event):void
		{

			if(isNaN(Number(target.valueText.text)))	
			{
				target.valueText.text = ''
			}
			currentNumber = Number(eliminationSplit_fun(target.valueText.text,splitCar)) 	
			if(currentNumber>totalNumber)
			{
				currentNumber = totalNumber
			}
			setValueText_fun(currentNumber,true)
			sendValue()
		}
		private function getTextBoxTotalNumber(maxCar_p:int):Number
		{
			var str:String=""
			for(var i:int=0;i<=maxCar_p-1;i++)
			{
				str+="9"
			}
			return Number(str)
		}
	}
}