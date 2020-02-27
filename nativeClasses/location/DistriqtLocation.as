package nativeClasses.location
{
	import com.distriqt.extension.playservices.base.ConnectionResult;
	import com.distriqt.extension.playservices.base.GoogleApiAvailability;
	import com.distriqt.extension.location.events.AuthorisationEvent;
	import com.distriqt.extension.location.Location;
	import com.distriqt.extension.location.AuthorisationStatus;
	import com.distriqt.extension.location.LocationRequest;
	import com.distriqt.extension.location.events.LocationSettingsEvent;

	public class DistriqtLocation
	{
		private static var _googlePlyaSupport:* = null ;
		private static var _locationSupport:* = null ;


		public static function setUp():void
		{
			checkGooglePlay();
			checkLocationPermission();
		}

		public static function activateLocationService():void
		{
			checkGooglePlay();
			checkLocationPermission(openLocationSetting,openLocationSetting);

			function openLocationSetting():void
			{
				trace("** openLocationSetting");
				if(_googlePlyaSupport)
				{
					if (!Location.service.isAvailable()) 
					{
						if(DevicePrefrence.isAndroid())
						{
							trace("************** open location");
							var request:LocationRequest = new LocationRequest();
							request.priority = LocationRequest.PRIORITY_HIGH_ACCURACY;

							Location.service.removeEventListener( LocationSettingsEvent.SUCCESS, checkLocationSettingsHandler );
							Location.service.removeEventListener( LocationSettingsEvent.FAILED, checkLocationSettingsHandler );
							Location.service.addEventListener( LocationSettingsEvent.SUCCESS, checkLocationSettingsHandler );
							Location.service.addEventListener( LocationSettingsEvent.FAILED, checkLocationSettingsHandler );

							var success:Boolean = Location.service.checkLocationSettings( request );
							if (!success)
							{
								Location.service.displayLocationSettings();
							}

							function checkLocationSettingsHandler( event:LocationSettingsEvent ):void
							{
								trace("********** Location is ? "+ event.type );
							}
						}
						else
						{
							trace("********* Open location setting")
							Location.service.displayLocationSettings(); 
						}
					}
					else
					{
						trace("************* Locatoin service is not available *************");
					}
				}
				else
				{
					trace("************* Google play is not support")
				}
			}
		}

		private static function checkLocationPermission(onPermissioned:Function=null,onDenied:Function=null):void
		{
			//if(_locationSupport==true)
				//return ;

			Location.service.addEventListener( AuthorisationEvent.CHANGED, function(e):*{
				checkLocationPermission(onPermissioned,onDenied);
			} );
			switch (Location.service.authorisationStatus())
			{
				case AuthorisationStatus.ALWAYS:
				case AuthorisationStatus.IN_USE:
					_locationSupport = true ;
					trace( "User allowed access: " + Location.service.authorisationStatus()+" >> "+onPermissioned );
					if(onPermissioned!=null)
					{
						onPermissioned();
						return ;
					}
					break;
				
				case AuthorisationStatus.NOT_DETERMINED:
				case AuthorisationStatus.SHOULD_EXPLAIN:
					Location.service.requestAuthorisation( AuthorisationStatus.ALWAYS );
					return;
				
				case AuthorisationStatus.RESTRICTED:
				case AuthorisationStatus.DENIED:
				case AuthorisationStatus.UNKNOWN:
					trace( "User denied access" );
					_locationSupport = false ;
					break;
			}

			if(onDenied!=null)
			{
				onDenied();
			}
		}

		private static function checkGooglePlay():void
		{
			if(_googlePlyaSupport!=null)
				return;
			var result:int = GoogleApiAvailability.instance.isGooglePlayServicesAvailable();
			if (result != ConnectionResult.SUCCESS)
			{
				if (GoogleApiAvailability.instance.isUserRecoverableError( result ))
				{
					GoogleApiAvailability.instance.showErrorDialog( result );
				}
				else
				{
					_googlePlyaSupport = false ;
					trace( "Google Play Services aren't available on this device" );
				}
			}
			else
			{
				_googlePlyaSupport = true ;
				trace( "Google Play Services are Available" );
			}
		}
	}
}