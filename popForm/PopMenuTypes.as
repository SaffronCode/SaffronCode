package popForm
{
	import flash.geom.ColorTransform;

	/**this will mange pop menu soudns , color with its types*/
	public class PopMenuTypes
	{
		/**this is the pop menu type id*/
		public var type:uint ;
		
		public var frame:uint ;
		
		public var soundID:uint ;
		
		/**this is the theme color for this type of pop up*/
		//public var colorTransform:ColorTransform ;
		
		public function PopMenuTypes(Type:uint/*,Color:uint*/)
		{
			frame = soundID = type = Type ;
			//colorTransform = new ColorTransform();
			//colorTransform.color = Color ;
		}
		
		/**this is a answer type of pop ups*/
		public static function get DEFAULT():PopMenuTypes
		{
			return new PopMenuTypes(1/*,0xFF33CC*/);
		}
		
		/**this is a question type of pop ups*/
		public static function get CAUTION():PopMenuTypes
		{
			return new PopMenuTypes(2/*,0x00cc00*/);
		}
	}
}