package nativeClasses.vibration
{
    import flash.utils.getDefinitionByName;

    public class VibrationDistriqt
    {
        private static var generator:* ;

        /**com.distriqt.extension.vibration.FeedbackGenerator;
         * 
         */
        private static var FeedbackGeneratorClass:Class,
        FeedbackGeneratorTypeClass:Class,
        VibrationClass:Class;


        private static function firstSetUp():void
        {
            if(FeedbackGeneratorClass!=null)
            {
                return ;
            }
            try
            {
                FeedbackGeneratorClass = getDefinitionByName("com.distriqt.extension.vibration.FeedbackGenerator") as Class;
                FeedbackGeneratorTypeClass = getDefinitionByName("com.distriqt.extension.vibration.FeedbackGeneratorType") as Class;
                VibrationClass = getDefinitionByName("com.distriqt.extension.vibration.Vibration") as Class;
                trace("Distriqt VibrationClass : "+VibrationClass);
            }
            catch(e:Error)
            {
                FeedbackGeneratorClass = null ;
            }
        }


        public static function isSupported():Boolean
        {
            trace("distriqt vibration is supported ?? "+VibrationClass);
            firstSetUp();
            return VibrationClass!=null && (VibrationClass as Object).isSupported;
        }

        public static function vibrate(duration:uint=4000):void
        {
            firstSetUp();
            if(DevicePrefrence.isAndroid())
            (VibrationClass as Object).service.vibrate( duration );
            else
            (VibrationClass as Object).service.vibrate();
        }

        public static function vibrateDynamic(pattern:Array):void
        {
            firstSetUp();
            (VibrationClass as Object).service.vibrate( 0,pattern );
        }

        public static function puls():void
        {
            firstSetUp();

            if(DevicePrefrence.isAndroid())
            {
                vibrate(40);
            }
            else
            {
                if(generator==null)
                    generator = (VibrationClass as Object).service.createFeedbackGenerator( (FeedbackGeneratorTypeClass as Object).IMPACT );
                generator.performFeedback();
                generator.prepare();
            }
        }

    }
}