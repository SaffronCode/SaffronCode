package nativeClasses.distriqtAudioPlayer {


    import flash.net.NetConnection;
    import flash.net.NetStream;
    import flash.events.NetStatusEvent;
    import flash.desktop.NativeApplication;
    import flash.events.Event;

    public class DistriqtAudioPlayer {

        /**com.distriqt.extension.mediaplayer.audio.AudioPlayer */
        private static var AudioPlayerClass:Class;
        /**com.distriqt.extension.mediaplayer.MediaPlayer */
        private static var MediaPlayerClass:Class;
        /**com.distriqt.extension.mediaplayer.audio.AudioPlayerOptions */
        private static var AudioPlayerOptionsClass:Class;
        /**com.distriqt.extension.mediaplayer.events.AudioPlayerEvent */
        private static var AudioPlayerEventClass:Class;
        /**com.distriqt.extension.mediaplayer.events.MediaErrorEvent */
        private static var MediaErrorEventClass:Class;

        private static var player:* ;

        private static var _nc:NetConnection = null;
        private static var _ns:NetStream = null;

        private static var myId:uint ;

        private static var onStoppedFunc:Function ;

        private static var isPlaying:Boolean = false ;

        public static function currentPlayinID():uint
        {
            return myId ;
        }

        public static function setUp():void
        {
            
            if(player==null)
            {
                if(DevicePrefrence.isPC())
                {
                    _nc = new NetConnection();
                    _nc.connect(null);
                    _ns = new NetStream( _nc );
                    _ns.removeEventListener(NetStatusEvent.NET_STATUS,statusChanged);
                    _ns.addEventListener(NetStatusEvent.NET_STATUS,statusChanged);
                    _ns.client = new Object();
                }
                else
                {
                    AudioPlayerClass = Obj.generateClass('com.distriqt.extension.mediaplayer.audio.AudioPlayer');
                    MediaPlayerClass = Obj.generateClass('com.distriqt.extension.mediaplayer.MediaPlayer');
                    AudioPlayerOptionsClass = Obj.generateClass('com.distriqt.extension.mediaplayer.audio.AudioPlayerOptions');
                    AudioPlayerEventClass = Obj.generateClass('com.distriqt.extension.mediaplayer.events.AudioPlayerEvent');
                    MediaErrorEventClass = Obj.generateClass('com.distriqt.extension.mediaplayer.events.MediaErrorEvent');

                    trace("AudioPlayerClass : "+AudioPlayerClass);
                    trace("MediaPlayerClass : "+MediaPlayerClass);
                    trace("AudioPlayerOptionsClass : "+AudioPlayerOptionsClass);
                    trace("AudioPlayerEventClass : "+AudioPlayerEventClass);
                    trace("MediaErrorEventClass : "+MediaErrorEventClass);
                    if(AudioPlayerClass==null)return;
                    var options:* = new AudioPlayerOptionsClass();
                        (options).enableBackgroundAudio(false);
                    player = (MediaPlayerClass as Object).service.createAudioPlayer(); 
                    player.addEventListener( (AudioPlayerEventClass as Object).PLAYING, audioPlayer_played );
                    player.addEventListener( (AudioPlayerEventClass as Object).COMPLETE, audioPlayer_completeHandler );
                    player.addEventListener( (MediaErrorEventClass as Object).ERROR, audioPlayer_errorHandler );
                }

                NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE,pausePlayingSound);
                NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE,playPausedSound);
            }
        }

        

        private static function statusChanged(e:NetStatusEvent):void
        {
            trace("Net status "+e.info.code);
            switch(e.info.code)
            {
                case "NetStream.Play.Stop":
                    trace("Playing finished");
                    triggerStop();
                break;
                case "NetStream.Play.Start":
                    trace("Playing started");
                    audioPlayer_played() ;
                break;
            }
        }

        private static function audioPlayer_played(e:*=null):void
        {
            isPlaying = true ;
        }

        private static function audioPlayer_errorHandler(e:*):void
        {
            trace("Adress error : "+e)
        }

        private static function audioPlayer_completeHandler(event:*):void
        {
            trace("Sound completed");
            triggerStop();
        }

        private static function triggerStop():void
        {
            trace("Trigger stop");
            isPlaying = false ;
            var cashedStop:Function = onStoppedFunc ;
            onStoppedFunc = null ;
            if(cashedStop!=null)cashedStop();
        }

        public static function stop():void
        {
            setUp();
            if(DevicePrefrence.isPC())
            {
                _ns.close();
            }
            else
            {
                player.stop();
            }
            trace("Stop funcitn called")
            triggerStop();
        }


        public static function play(soundPathURL:String,onStopped:Function=null):uint
        {
            setUp();
            trace("Play function called")
            triggerStop();
            if(DevicePrefrence.isPC())
            {
                _ns.play( soundPathURL );
            }
            else
            {
                if(AudioPlayerClass==null)return 0;
                //setTimeout(player.loadFile,0,new File(soundPathURL));
                trace("player : "+player+" << "+soundPathURL);
                player.load(soundPathURL);
                player.play();
            }

            onStoppedFunc = onStopped ;

            myId++;
            return myId ;
        }

        private static function pausePlayingSound(event:Event):void
        {
            if(isPlaying)
            {
                if(player!=null)
                    player.pause();
                else
                    _ns.pause();
            }
        }

        private static function playPausedSound(event:Event):void
        {
            if(isPlaying)
            {
                if(player!=null)
                    player.play();
                else
                    _ns.resume();
            }
        }
    }
}
