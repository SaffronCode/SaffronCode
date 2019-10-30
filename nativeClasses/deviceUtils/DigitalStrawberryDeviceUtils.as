package nativeClasses.deviceUtils {

    // import com.digitalstrawberry.ane.deviceutils.DeviceUtils;
    import flash.utils.getDefinitionByName;

    public class DigitalStrawberryDeviceUtils {
        public static var DeviceUtilsClass:Class
        public function DigitalStrawberryDeviceUtils() {

        }

        public static function isSupported():Boolean {
            loadClasses();
            if (DeviceUtilsClass == null || DeviceUtilsClass.isSupported == false)
                return false
            else
                return true;
        }

        public static function loadClasses():void {
            if (DeviceUtilsClass == null) {
                try {
                    DeviceUtilsClass = getDefinitionByName("com.digitalstrawberry.ane.deviceutils.DeviceUtils") as Class;
                } catch (e) {
                    trace('Add \n\n\t<extensionID>com.digitalstrawberry.ane.deviceUtils</extensionID>\n\n to your project xmls');
                }
            }
        }

        public static function ID():String {
            if (isSupported())
                return DeviceUtilsClass.idfv;
            else
                return "";
        }

        public static function Model():String {
           if (isSupported())
                return DeviceUtilsClass.model;
            else
                return "";
        }

        public static function SystemName():String {
           if (isSupported())
                return DeviceUtilsClass.systemName;
            else
                return "";
        }

        public static function SystemVersion():String {
            if (isSupported())
                return DeviceUtilsClass.systemVersion;
            else
                return "";
        }
    }

}
