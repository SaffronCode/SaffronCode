package volume
{//volume.Volume
	
	
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	
	
	public class Volume extends MovieClip
	{
		private var target:MovieClip;	
		public var  steepView:Boolean;
		private var startDargX:Number;
		private var defaultVolumex:Number=0;
		private var _value:Number
		private var timer:Timer;
		
		private var onMouseUp:Function,
					onMouseDown:Function;
					
		private var rangeIcon:RangeIcon,
					rangeClass:Class;
		

		public function set value(value:Number):void
		{
			_value = value;
		}
		public function get value():Number
		{
			return _value;
		}	
		private var _startOf:Number;
		public function set startOf(value:Number):void
		{
			_startOf = value
		}
		public function get startOf():Number
		{
			return _startOf
		}
		private var _endOf:Number;
		public function set endOf(value:Number):void
		{
			_endOf = value;
		}
		public function get endOf():Number
		{
			return _endOf;
		}
		private var _steep:Number;
		public function set steep(value:Number):void
		{
			_steep = value
		}
		public function get steep():Number
		{
			return _steep;
		}
		private var _steepWiew:Boolean;
		public function set steepWiew(value:Boolean):void
		{
			_steepWiew = value;
		}
		
		public function get steepWiew():Boolean
		{
			return _steepWiew;
		}
		private var _decimal:int;
		public function set decimal(value:int):void
		{
			_decimal = value;
		}
		public function get decimal():int
		{
			return _decimal
		}
		public function Volume()
		{		
			super();
			rangeIcon = Obj.findThisClass(RangeIcon,this)
			
		}
		public function setup(value_p:Number,startOf_p:Number,endOf_p:Number,OnMousUP_p:Function=null,OnMouseDown_p:Function=null,steep_p:Number=0,steepView_p:Boolean=true,decimal_p:int=2):void
		{
			target = this;
	
			onMouseUp = OnMousUP_p
			onMouseDown = OnMouseDown_p	
				
			value = value_p;
			endOf = endOf_p;
			startOf = startOf_p
			steep = steep_p;
			steepWiew = steepView_p;
			decimal = decimal_p;
			target.volumeBtn.addEventListener(MouseEvent.MOUSE_DOWN,volumeBtnDown_fun);
			target.sliderRange.addEventListener(MouseEvent.MOUSE_DOWN,sliderDown_fun);
			
			reset()
			if(rangeIcon!=null)
			{
				rangeClass = getDefinitionByName(getQualifiedClassName(rangeIcon)) as Class
				addSliderRange_fun()
			}
		
		}
		private function upFun(evt:MouseEvent):void
		{
			target.volumeBtn.removeEventListener(MouseEvent.MOUSE_UP,upFun);
			target.volumeBtn.removeEventListener(MouseEvent.RELEASE_OUTSIDE,upFun);
			target.sliderRange.removeEventListener(MouseEvent.MOUSE_UP,upFun);
			target.sliderRange.removeEventListener(MouseEvent.RELEASE_OUTSIDE,upFun);
			
			timer.stop()
			timer.removeEventListener(TimerEvent.TIMER,setMask_fun)
			onMouseUp()
		}
		private function sliderDown_fun(evt:MouseEvent):void
		{
			downFun();
			defaultVolumex =  target.mouseX;		
		}
		private function volumeBtnDown_fun(evt:MouseEvent):void
		{
			downFun();
			defaultVolumex = target.volumeBtn.x;			
		}
		private function downFun():void
		{
			startDargX = target.mouseX;		
			timer = new Timer(1)
			timer.addEventListener(TimerEvent.TIMER,setMask_fun)	
			timer.start()
			target.volumeBtn.addEventListener(MouseEvent.MOUSE_UP,upFun);
			target.volumeBtn.addEventListener(MouseEvent.RELEASE_OUTSIDE,upFun)
			target.sliderRange.addEventListener(MouseEvent.MOUSE_UP,upFun);
			target.sliderRange.addEventListener(MouseEvent.RELEASE_OUTSIDE,upFun)
			onMouseDown()
		}
		private function setXfun(value_p:int):Number
		{
			return target.slider.x+target.slider.width/(endOf-startOf)*(value_p-startOf);
		}
		private function setYfun():Number
		{
			return target.slider.y+target.slider.height/2;
		}
		private function getSliderFun(range_p:Number):Number
		{	
			var range:Number = range_p
			var currentValue:Number = value;	
			if(steep==0)
			{
				currentValue =  Number(range.toFixed(decimal))
			}
			else
			{
				currentValue = Math.round(range/steep)*steep
			}
			if(currentValue>endOf)currentValue=endOf
			if(currentValue<startOf)currentValue=startOf	
			return 	currentValue
		}
		private function getRangeSlider_fun(dinamicValue_p:Number):Number
		{ 
			var range:Number = ((dinamicValue_p- target.slider.x+defaultVolumex) * (endOf-startOf) / target.slider.width)+startOf
			if(range>endOf)range=endOf
			if(range<startOf)range=startOf	
			return 	range
		}
		private function setMask_fun(evt:Event):void
		{
			var range:Number = getRangeSlider_fun(target.mouseX-startDargX)
			value = getSliderFun(range);
			if(steepWiew)
			{
				target.volumeBtn.x = setXfun(value)
			}
			else
			{
				target.volumeBtn.x = setXfun(range)
			}
			
			target.slider.mask.width = target.volumeBtn.x
		}
		private function  addSliderRange_fun():void
		{
			target.rangeIcon.x = target.slider
			var sliderRange:Number=0;
			var chengRange:Number=0;
			for(var i:int=0;i<=target.slider.width;i++)
			{	
				if(sliderRange%steep==0)
				{
					if(sliderRange!=chengRange)
					{
						var sliderRangeIcon:RangeIcon = new rangeClass()
						target.addChild(sliderRangeIcon)
						sliderRangeIcon.mouseChildren = false
						sliderRangeIcon.mouseEnabled = false	
						sliderRangeIcon.x = target.slider.x+setXfun(sliderRange)
						sliderRangeIcon.y=target.rangeIcon.y
						sliderRangeIcon.setup(sliderRange.toString())	
						chengRange= sliderRange	
					}								
				}
				sliderRange = Math.round(getRangeSlider_fun(i))
			}
		}
		public function reset():void
		{
			target.volumeBtn.x = setXfun(value);
			target.slider.mask.width = setXfun(value);
			target.volumeBtn.y = setYfun();
		}
	}
}