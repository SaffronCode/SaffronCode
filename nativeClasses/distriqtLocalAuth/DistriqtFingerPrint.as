package nativeClasses.distriqtLocalAuth
{
	import dataManager.GlobalStorage;

	public class DistriqtFingerPrint
	{
		private static const id_securePass:String = "id_securePass";

		private static var _isSupported:* = null ;

		/**com.distriqt.extension.localauth.LocalAuth */
		private static var LocalAuthClass:Class ;
		/**com.distriqt.extension.localauth.BiometryType */
		private static var BiometryTypeClass:Class ;
		/**com.distriqt.extension.localauth.events.LocalAuthEvent */
		private static var LocalAuthEventClass:Class ;

		private static function setUp():void
		{
			if(_isSupported==null)
			{
				LocalAuthClass = Obj.generateClass('com.distriqt.extension.localauth.LocalAuth');
				BiometryTypeClass = Obj.generateClass('com.distriqt.extension.localauth.BiometryType');
				LocalAuthEventClass = Obj.generateClass('com.distriqt.extension.localauth.events.LocalAuthEvent');

				if(LocalAuthClass==null)
				{
					_isSupported = false ;
				}
				else
				{
					_isSupported = true ;
				}
			}
		}

		public static function savePassForUserFingerPrint(pass:String=null):void
		{
			GlobalStorage.save(id_securePass,pass);
		}

		private static function loadPass():String
		{
			return GlobalStorage.load(id_securePass);
		}

		public static function isPasswordSaved():Boolean
		{
			setUp();
			return loadPass()!=null;
		}

		public static function isSupported():Boolean
		{
			setUp();
			return _isSupported&& (LocalAuthClass as Object).service.canAuthenticateWithBiometryType((BiometryTypeClass as Object).FINGERPRINT) ;
		}

		public static function getSavedPassByFingerPrint(getPassword:Function,accessFaild:Function,title:String= "Unlock access to locked feature"):void
		{
			setUp();
			var loadedPass:String = loadPass();
			if (isPasswordSaved && isSupported())
			{
				(LocalAuthClass as Object).service.addEventListener( (LocalAuthEventClass as Object).AUTH_SUCCESS, authSuccessHandler );
				(LocalAuthClass as Object).service.addEventListener( (LocalAuthEventClass as Object).AUTH_FAILED, authFailedHandler );

				(LocalAuthClass as Object).service.authenticateWithBiometryType(title);
			}
			else
			{
				accessFaild();
			}

			function authFailedHandler(e:*):void
			{
				(LocalAuthClass as Object).service.removeEventListener( (LocalAuthEventClass as Object).AUTH_SUCCESS, authSuccessHandler );
				(LocalAuthClass as Object).service.removeEventListener( (LocalAuthEventClass as Object).AUTH_FAILED, authFailedHandler );
				accessFaild();
			}

			function authSuccessHandler(event:*):void
			{
				(LocalAuthClass as Object).service.removeEventListener( (LocalAuthEventClass as Object).AUTH_SUCCESS, authSuccessHandler );
				(LocalAuthClass as Object).service.removeEventListener( (LocalAuthEventClass as Object).AUTH_FAILED, authFailedHandler );

				getPassword(loadedPass);
			}
		}

			
	}
}