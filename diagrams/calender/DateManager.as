package diagrams.calender
{
	public class DateManager
	{
		public static function copy(date:Date):Date
		{
			return new Date(date.fullYear,date.month,date.date,date.hours,date.minutes,date.seconds,date.milliseconds);
		}
	}
}