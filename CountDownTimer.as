package
{
	import flash.display.MovieClip;
	
	public class CountDownTimer extends MovieClip
	{
		public function CountDownTimer()
		{
			super();
		}
		/*public static function getNegtivTime():String
		{
			var _currentTime:Number = new Date().time
			var _totalTime:Number = Number(savedTimer.value)
			var _time:Number = 	_totalTime-_currentTime
			var _min:Number = Math.floor(_time/60000)
			var _sec:Number = Math.floor((((_time/60000)-_min)*60000)/1000)
			return Add_Zero_Behind.add(2,_min)+':'+Add_Zero_Behind.add(2,_sec)
		}*/
	}
}