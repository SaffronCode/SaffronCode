package nativeClasses.location {
    import com.distriqt.extension.playservices.base.ConnectionResult;
    import com.distriqt.extension.playservices.base.GoogleApiAvailability;
    import com.distriqt.extension.location.events.AuthorisationEvent;
    import com.distriqt.extension.location.Location;
    import com.distriqt.extension.location.AuthorisationStatus;
    import com.distriqt.extension.location.LocationRequest;
    import com.distriqt.extension.location.events.LocationSettingsEvent;
    import spark.components.Alert;

    public class DistriqtLocation {
        private static var _googlePlyaSupport:* = null;
        private static var _locationSupport:* = null;


        public static function setUp():void {
            checkGooglePlay();
            checkLocationPermission();
        }

        public static function activateLocationService(onActivated:Function = null, onDenied:Function = null, showSetting:Boolean = true):void {
            if (onActivated == null)
                onActivated = new Function();
            if (onDenied == null)
                onDenied = new Function();

            checkGooglePlay();
            checkLocationPermission(openLocationSetting, openLocationSetting);

            function openLocationSetting():void {
                trace("** openLocationSetting");
                if (_googlePlyaSupport) {
                    if (!Location.service.isAvailable()) {
                        if (DevicePrefrence.isAndroid()) {
                            trace("************** open location");
                            var request:LocationRequest = new LocationRequest();
                            request.priority = LocationRequest.PRIORITY_HIGH_ACCURACY;

                            Location.service.removeEventListener(LocationSettingsEvent.SUCCESS, checkLocationSettingsHandler);
                            Location.service.removeEventListener(LocationSettingsEvent.FAILED, checkLocationSettingsHandler);
                            Location.service.addEventListener(LocationSettingsEvent.SUCCESS, checkLocationSettingsHandler);
                            Location.service.addEventListener(LocationSettingsEvent.FAILED, checkLocationSettingsHandler);
                            if (showSetting == false) {
                                onDenied();
                                trace("onDenided")
                                return
                            }
                            var success:Boolean = Location.service.checkLocationSettings(request);
                            if (!success) {
                                onDenied();
                                trace("onDenided")
                                Location.service.displayLocationSettings();
                            }

                            function checkLocationSettingsHandler(event:LocationSettingsEvent):void {
                                trace("********** Location is ? " + event.type);
                            }
                        } else {
                            trace("********* Open location setting")
                            onDenied();
                            trace("onDenided")
                            if (showSetting == true)
                                Location.service.displayLocationSettings();
                        }
                    } else {
                        trace("************* Locatoin service is available *************");
                        onActivated();
                        trace("onActive")
                    }
                } else {
                    trace("************* Google play is not support")
                    onDenied();
                    trace("onDenided")
                }
            }
        }

        public static function checkLocationPermission(onPermissioned:Function = null, onDenied:Function = null):void {
            Location.service.addEventListener(AuthorisationEvent.CHANGED, function(e:*):* {
                switch (Location.service.authorisationStatus()) {
                    case AuthorisationStatus.NOT_DETERMINED:
                    case AuthorisationStatus.SHOULD_EXPLAIN:
                    case AuthorisationStatus.RESTRICTED:
                    case AuthorisationStatus.DENIED:
                    case AuthorisationStatus.UNKNOWN:
                        if (onDenied != null) {
                            onDenied();
                        }
                        return;
                        break;
                    default:
                        if (onPermissioned != null) {
                            onPermissioned();
                            return;
                        }
                        break;
                }
            });
            switch (Location.service.authorisationStatus()) {
                case AuthorisationStatus.ALWAYS:
                case AuthorisationStatus.IN_USE:
                    _locationSupport = true;
                    trace("User allowed access: " + Location.service.authorisationStatus() + " >> " + onPermissioned);
                    if (onPermissioned != null) {
                        onPermissioned();
                        return;
                    }
                    break;

                case AuthorisationStatus.NOT_DETERMINED:
                case AuthorisationStatus.SHOULD_EXPLAIN:
                    Location.service.requestAuthorisation();
                    return;

                case AuthorisationStatus.RESTRICTED:
                case AuthorisationStatus.DENIED:
                case AuthorisationStatus.UNKNOWN:
                    trace("User denied access");
                    _locationSupport = false;
                    break;
            }

            if (onDenied != null) {
                onDenied();
            }


        }



        private static function checkGooglePlay():void {
            if (_googlePlyaSupport != null)
                return;
            var result:int = GoogleApiAvailability.instance.isGooglePlayServicesAvailable();
            if (result != ConnectionResult.SUCCESS) {
                if (GoogleApiAvailability.instance.isUserRecoverableError(result)) {
                    GoogleApiAvailability.instance.showErrorDialog(result);
                } else {
                    _googlePlyaSupport = false;
                    trace("Google Play Services aren't available on this device");
                }
            } else {
                _googlePlyaSupport = true;
                trace("Google Play Services are Available");
            }
        }
    }
}
