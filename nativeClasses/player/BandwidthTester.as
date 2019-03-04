package nativeClasses.player
{
	import flash.net.*;
	import flash.utils.*;
	import flash.events.*;
	
	public class BandwidthTester extends EventDispatcher
	{
		public static const BAND_TESTED = 'tested';
		public static const TEST = 'test';
		
		private var bandwidth = 0;          //final average bandwidth
		private var peak_bandwidth = 0;     //peak bandwidth
		private var curr_bandwidth = 0;     //current take bandwidth
		
		private var testfile = '';
		private var l;                      //loader
		private var tm;                     //timer
		private var last_bytes = 0;         //bytes loaded last time
		private var bands;                  //recorded byte speeds
		private var _latency = 1;       //network utilization approximation
		
		public function BandwidthTester(latency = 0,URL_Path:String="")
		{
			tm = new Timer(1000, 3);
			testfile = URL_Path;
			tm.addEventListener(TimerEvent.TIMER, get_band);
			tm.addEventListener(TimerEvent.TIMER_COMPLETE, timer_complete);
			bands = new Array();
			_latency = 1 - latency;
		}
		
		public function start()
		{
			l = new URLLoader();
			l.addEventListener(Event.OPEN, start_timer);
			l.addEventListener(Event.COMPLETE, end_download);
			l.load(new URLRequest(testfile));
		}
		
		private function get_band(e:TimerEvent)
		{
			curr_bandwidth = Math.floor(((l.bytesLoaded - last_bytes) / 125) * _latency);
			bands.push(curr_bandwidth);
			last_bytes = l.bytesLoaded;
			
			dispatchEvent(new Event(BandwidthTester.TEST));
		}
		
		public function start_timer(e:Event)
		{
			tm.start();
		}
		
		private function timer_complete(e:TimerEvent)
		{
			l.close();
			bands.sort(Array.NUMERIC | Array.DESCENDING);
			
			peak_bandwidth = bands[0];
			bandwidth = calc_avg_bandwidth();
			
			dispatchEvent(new Event(BandwidthTester.BAND_TESTED));
		}
		
		private function end_download(e)
		{
			tm.removeEventListener(TimerEvent.TIMER, get_band);
			tm.removeEventListener(TimerEvent.TIMER_COMPLETE, timer_complete);
			tm.stop();
			l.close();
			bands.sort(Array.NUMERIC | Array.DESCENDING);
			bandwidth = 10000;
			peak_bandwidth = (bands[0]) ? bands[0] : bandwidth;
			
			dispatchEvent(new Event(BandwidthTester.BAND_TESTED));
		}
		
		private function calc_avg_bandwidth()
		{
			var total = 0;
			var len = bands.length;
			while (len--)
			{
				total += bands[len];
			}
			return Math.round(total / bands.length);
		}
		
		public function set latency(prc)
		{
			this._latency = 1 - prc;
		}
		
		public function getBandwidth()
		{
			return bandwidth;
		}
		
		public function getPeak()
		{
			return peak_bandwidth;
		}
		
		public function last_speed()
		{
			 return curr_bandwidth;
		
		}
	}
}