package nativeClasses.vibration
{
    import com.distriqt.extension.vibration.Vibration;
    import com.distriqt.extension.vibration.FeedbackGenerator;
    import com.distriqt.extension.vibration.FeedbackGeneratorType;

    public class VibrationDistriqt
    {
        private static var generator:FeedbackGenerator ;


        


        public static function isSupported():Boolean
        {
            return Vibration.isSupported();
        }

        public static function vibrate(duration:uint):void
        {
            Vibration.service.vibrate( duration );
        }

        public static function vibrateDynamic(pattern:Array):void
        {
            Vibration.service.vibrate( 0,pattern );
        }

        public static function puls():void
        {
            if(generator==null)
                generator = Vibration.service.createFeedbackGenerator( FeedbackGeneratorType.IMPACT );
            generator.performFeedback();
            generator.prepare();
        }

    }
}