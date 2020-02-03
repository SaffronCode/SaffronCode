package nativeClasses.distriqtApplication
{

    public class DistriqtApplication
    {
        private static var ApplicationClass:Class;
        private static var satUpOnce:Boolean = false ;

        private static function setUp():void
        {
            if(satUpOnce)
                return;
            satUpOnce = true ;
            ApplicationClass = Obj.generateClass("com.distriqt.extension.application.Application");
        }

        /**Returns null if it couldnt get the device unique id */
        public static function NativeUniqueDeviceId():String
        {
            if(isSupported())
            {
                return (ApplicationClass as Object).service.device.uniqueId();
            }
            return null ;
        }

        /**Returns null if couldn't*/
        public static function phoneNumber():String
        {
            if(isSupported())
            {
                return (ApplicationClass as Object).service.device.phone;
            }
            return null ;
        }

        public static function isSupported():Boolean
        {
            setUp();
            return ApplicationClass!=null && (ApplicationClass as Object).isSupported ;
        }

        public static function solveBlackScreenProblem():void
        {
            if(isSupported())
            {
                (ApplicationClass as Object).service.blackScreenHelper();
            }
        }
        public static function solveBackButton():void
        {
            if(isSupported())
            {
                (ApplicationClass as Object).service.backButtonHelper();
            }
        }

        public static function setStatusBarColor(color:uint):void
        {
            if(isSupported())
            {
                (ApplicationClass as Object).service.display.setStatusBarColour( color ,0.8);
                /*var red:uint = ((color&0xff0000)/0x010000);
                var green:uint = ((color&0xff00)/0x0100);
                var blue:uint = (color&0xff);
                var gray:uint = (red+green+blue)/3;
                if(gray>0x7f)
                    Application.service.display.setStatusBarStyle( StatusBarStyle.DARK );
                else
                    Application.service.display.setStatusBarStyle( StatusBarStyle.DARK );*/
            }
        }
    }
}