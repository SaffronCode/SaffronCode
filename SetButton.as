package
{
	import fl.motion.easing.Elastic;
	import fl.transitions.Tween;
	import fl.transitions.easing.Regular;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class SetButton 
	{
		public static const NEXT:String="NEXT",
			PREV:String="PREV",
			HOME:String="HOME";
		private var _current:int;
		public function get current():int
		{
			return _current
		}
		public function set current(Current_p:int):void
		{
			_current = Current_p
		}
		private var _min:int,
		_total:int,
		_target:MovieClip,
		_fun:Function;
		private var _targetMovie:Object = {}			
		public function setup(Min_p:int,Total_p:int,Current_p:int)
		{
			// constructor code
			_min = Min_p
			_total = Total_p	
			current = Current_p	
			
		}
		public function setButtons_fun(Target_p:MovieClip,Button_name_p:String,Fun_p:Function)
		{
			_target = Target_p	
			_target.nameBtn = Button_name_p	
			_targetMovie[Button_name_p]	= _target
			_fun = 	Fun_p
			_target.addEventListener(MouseEvent.CLICK,click_fun)			
			chekCurrent(_target,true)
			chekButton(_target)
		}
		
		protected function click_fun(event:MouseEvent):void
		{
			
			for(var targetIndex in _targetMovie)	
			{
				if(event.currentTarget.nameBtn==_targetMovie[targetIndex].nameBtn)
				{
					chekCurrent(_targetMovie[targetIndex],false)
				}
				else
				{
					chekCurrent(_targetMovie[targetIndex],true)
				}
			}	
			
			for(var targetIndexBtn in _targetMovie)	
			{
				chekButton(_targetMovie[targetIndexBtn])
			}	
		}
		private function chekCurrent(TargetIndex_p:MovieClip,FirstChek:Boolean):void
		{
			switch(TargetIndex_p.nameBtn)
			{
				case NEXT:
					if(!FirstChek)
					{
						current++
							_fun.apply()
					}
					break
				case PREV:
					if(!FirstChek)
					{
						current--
							_fun.apply()
					}
					break
				case HOME:
					if(!FirstChek)
					{
						current = _min
						_fun.apply()
					}
					break
			}	
		}
		
		private function chekButton(TargetIndex_p:MovieClip):void
		{
			switch(TargetIndex_p.nameBtn)
			{
				case NEXT:
					if(current>=_total)
					{
						buttonStatus(TargetIndex_p,false)
					}
					else
					{
						buttonStatus(TargetIndex_p,true)
					}
					break
				case PREV:
					if(current<=_min)
					{
						buttonStatus(TargetIndex_p,false)
					}
					else
					{
						buttonStatus(TargetIndex_p,true)
					}
					break
				case HOME:
					buttonStatus(TargetIndex_p,false)
					break
			}	
		}
		
		private function buttonStatus(target_p:Object,status_p:Boolean):void
		{
			if(status_p)
			{
				//var fadeIn:Tween = new Tween(target_p,'alpha',Regular.easeInOut,target_p.alpha,1,30)
				//fadeIn.start()	
				target_p.alpha = 1
			}
			else
			{
				//	var fadeOut:Tween = new Tween(target_p,'alpha',Regular.easeInOut,1,0.3,30)
				//	fadeOut.start()	
				
				target_p.alpha = 0.3
			}
			target_p.mouseChildren = status_p
			target_p.mouseEnabled = status_p	
		}
	}
}

