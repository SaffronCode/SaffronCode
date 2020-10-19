package nativeClasses.distriqtAudioPlayer
//nativeClasses.distriqtAudioPlayer.DistriqtAudioPlayerUI
{

    import flash.display.MovieClip;
    import appManager.displayContentElemets.TitleText;
    import com.distriqt.extension.mediaplayer.audio.AudioPlayer;
    import com.distriqt.extension.mediaplayer.audio.AudioPlayerOptions;
    import flash.utils.setTimeout;
    import contents.alert.Alert;
    import com.distriqt.extension.mediaplayer.MediaPlayer;
    import flash.events.Event;

    public class DistriqtAudioPlayerUI extends MovieClip
    {
        /**com.distriqt.extension.mediaplayer.audio.AudioPlayer */
        private var AudioPlayerClass:Class;
        /**com.distriqt.extension.mediaplayer.MediaPlayer */
        private var MediaPlayerClass:Class;
        /**com.distriqt.extension.mediaplayer.audio.AudioPlayerOptions */
        private var AudioPlayerOptionsClass:Class;
        /**com.distriqt.extension.mediaplayer.events.AudioPlayerEvent */
        private var AudioPlayerEventClass:Class;
        /**com.distriqt.extension.mediaplayer.events.MediaErrorEvent */
        private var MediaErrorEventClass:Class;

        private var player:AudioPlayer ;


        private var lineMC:MovieClip,
                    cursolMC:MovieClip ;

        private var pauseMC:MovieClip,
                    playMC:MovieClip;

        private var currentPositionTF:TitleText,
                    durationTF:TitleText;

        private var lastPosition:Number,lastDuration:Number ;

        private static var ME:DistriqtAudioPlayerUI ;

        public function DistriqtAudioPlayerUI()
        {
            super();

            lineMC = Obj.get("line_mc",this);
            cursolMC = Obj.get("cursol_mc",this);
            pauseMC = Obj.get("pause_mc",this);
            playMC = Obj.get("play_mc",this);
            currentPositionTF = Obj.get("current_time_mc",this);
            durationTF = Obj.get("total_tile_mc",this);

            pauseMC.visible = false ;

            this.addEventListener(Event.ENTER_FRAME,controlCursol);
            this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);

            ME = this ;

            setUp();
        }

        private function unLoad(e:Event):void
        {
            this.removeEventListener(Event.ENTER_FRAME,controlCursol);
            this.removeEventListener(Event.REMOVED_FROM_STAGE,unLoad);

            ME = null ;
        }

        private function controlCursol(e:Event):void
        {
            if(player==null)return;
            if(lastPosition != player.position)
            {
                currentPositionTF.setUp(TimeToString.timeInString(player.position),false,false,1);
            }
            if(lastDuration != player.duration)
            {
                durationTF.setUp(TimeToString.timeInString(player.duration),false,false,1);
            }
            lastPosition = player.position ;
            lastDuration = player.duration ;

            cursolMC.x = lineMC.x + lineMC.width*(player.duration!=0?(player.position/player.duration):0) ;
        }

        public function playSound(soundPathURL:String):void
        {
            setUp();
            trace("Play function called")
            if(AudioPlayerClass==null)return;
            trace("player : "+player+" << "+soundPathURL);
            player.load(soundPathURL);
            player.play();
        }

        public function setUp():void
        {
            
            if(player==null)
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
                var options:AudioPlayerOptions = new AudioPlayerOptionsClass();
                    (options).enableBackgroundAudio(true);
                    options.enablePlaybackSpeed(true);
                player = (MediaPlayerClass).service.createAudioPlayer(); 
                player.addEventListener( (AudioPlayerEventClass as Object).PLAYING, audioPlayer_played );
                player.addEventListener( (AudioPlayerEventClass as Object).COMPLETE, audioPlayer_completeHandler );
                player.addEventListener( (MediaErrorEventClass as Object).ERROR, audioPlayer_errorHandler );
            }
        }

        private function audioPlayer_played(e:*=null):void
        {
            pauseMC.visible = true ;
            playMC.visible = false ;
        }

        private function audioPlayer_errorHandler(e:*):void
        {
            pauseMC.visible = false ;
            playMC.visible = true ;
        }

        private function audioPlayer_completeHandler(event:*):void
        {
            pauseMC.visible = false ;
            playMC.visible = true ;
        }
       
    }
}
