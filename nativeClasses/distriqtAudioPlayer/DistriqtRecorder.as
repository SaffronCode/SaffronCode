package nativeClasses.distriqtAudioPlayer {

    import flash.filesystem.File;
    import flash.utils.clearTimeout;
    import flash.utils.getDefinitionByName;
    import flash.utils.setTimeout;

    public class DistriqtRecorder {
        public static var _file:File;

        private static var timeoutId:uint;

        /**import com.distriqt.extension.audiorecorder.AudioRecorder;*/
        private static var AudioRecorderClass:Class;
        /**import com.distriqt.extension.audiorecorder.AudioRecorderOptions;*/
        private static var AudioRecorderOptionsClass:Class;
        /**import com.distriqt.extension.audiorecorder.AuthorisationStatus;*/
        private static var AuthorisationStatusClass:Class;
        /**import com.distriqt.extension.audiorecorder.events.AuthorisationEvent;*/
        private static var AuthorisationEventClass:Class;


        public static var logger:Boolean = false;

        public static function setUp():Boolean {
            if (AudioRecorderClass != null)
                return true;

            try {
                AudioRecorderClass = getDefinitionByName("com.distriqt.extension.audiorecorder.AudioRecorder") as Class;
                AudioRecorderOptionsClass = getDefinitionByName("com.distriqt.extension.audiorecorder.AudioRecorderOptions") as Class;
                AuthorisationStatusClass = getDefinitionByName("com.distriqt.extension.audiorecorder.AuthorisationStatus") as Class;
                AuthorisationEventClass = getDefinitionByName("com.distriqt.extension.audiorecorder.events.AuthorisationEvent") as Class;
                SaffronLogger.log("\n\n\n\n\n\n\n*************************** Distriqt recorder is supports ****************************\n\n\n\n\n\n\n");
                if (logger)
                    SaffronLogger.log("\n\n\n\n\n\n\n*************************** Distriqt recorder is supports ****************************\n\n\n\n\n\n\n");
            } catch (e) {
                AudioRecorderClass = null;
                AudioRecorderOptionsClass = null;
                AuthorisationStatusClass = null;
                SaffronLogger.log("\n\n\n\n\n\n\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Distriqt recorder is NOT supports !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\n\n\n\n\n\n");
                if (logger)
                    SaffronLogger.log("\n\n\n\n\n\n\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Distriqt recorder is NOT supports !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\n\n\n\n\n\n");
                return false;
            }
            switch (AudioRecorderClass.service.authorisationStatus()) {
                case AuthorisationStatusClass.AUTHORISED:
                    SaffronLogger.log("authorised");
                    if (logger)
                        SaffronLogger.log("authorised");
                    break;

                case AuthorisationStatusClass.SHOULD_EXPLAIN:
                case AuthorisationStatusClass.NOT_DETERMINED:
                    AudioRecorderClass.service.addEventListener(AuthorisationEventClass.CHANGED, authChangedHandler);
                    AudioRecorderClass.service.requestAuthorisation();
                    break;

                case AuthorisationStatusClass.DENIED:
                case AuthorisationStatusClass.RESTRICTED:
                case AuthorisationStatusClass.UNKNOWN:
                    SaffronLogger.log("denied or restricted");
                    if (logger)
                        SaffronLogger.log("denied or restricted");
            }
            return true;
        }

        private static function authChangedHandler(event:*):void {
            SaffronLogger.log("authChangedHandler( " + event.status + " )");
        }

        /**Start recording.*/
        public static function startRecord(rcorderTimeout:uint = 0, whereToSave:File = null):Boolean {
            if (!setUp()) {
                return false;
            }
            clearTimeout(timeoutId);
            if (whereToSave == null) {
                _file = File.createTempDirectory();
                _file = File.createTempDirectory().resolvePath(_file.name.split(_file.name.lastIndexOf('.')) + '.m4a');
            } else {
                _file = whereToSave;
            }
            SaffronLogger.log("save on : " + _file.nativePath);
            if (logger)
                SaffronLogger.log("save on : " + _file.nativePath);


            if (rcorderTimeout != 0) {
                timeoutId = setTimeout(stop, rcorderTimeout);
            }

            if (AudioRecorderClass.service.hasAuthorisation()) {
                var options:* = new AudioRecorderOptionsClass();
                options.filename = _file.nativePath;

                var success:Boolean = AudioRecorderClass.service.start(options) as Boolean;

                SaffronLogger.log("start(): " + success);

                if (logger)
                    SaffronLogger.log("start(): " + success);

                return success;
            } else {
                SaffronLogger.log("Not authorised for start");
                if (logger)
                    SaffronLogger.log("Not authorised for start");
            }
            return false;
        }

        /**Stop recording. returns true if recording was successfull.*/
        public static function stop():Boolean {
            if (!setUp()) {
                return false;
            }
            clearTimeout(timeoutId);
            if (AudioRecorderClass.service.hasAuthorisation()) {
                var success:Boolean = AudioRecorderClass.service.stop() as Boolean;
                SaffronLogger.log("stop(): " + success);

                //				AudioRecorderClass.service.removeEventListener( AudioRecorderEvent.START, audioRecorderEventHandler );
                //				AudioRecorderClass.service.removeEventListener( AudioRecorderEvent.COMPLETE, audioRecorderEventHandler );
                //				AudioRecorderClass.service.removeEventListener( AudioRecorderEvent.PROGRESS, audioRecorderEventHandler );
                return success;
            } else {
                SaffronLogger.log("Not authorised for stop");
                if (logger)
                    SaffronLogger.log("Not authorised for stop");
            }
            return false;
        }

        public static function hasAuthorisation():Boolean {
            if (DevicePrefrence.isItPC) {
                return true
            }
            if (AudioRecorderClass.service.authorisationStatus() == AuthorisationStatusClass.AUTHORISED || AudioRecorderClass.service.authorisationStatus() == AuthorisationStatusClass.UNKNOWN) {
                return true;
            } else {
                return false;
            }
        }
    }
}
