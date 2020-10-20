package nativeClasses.distriqtAudioPlayer
//nativeClasses.distriqtAudioPlayer.DistriqtAudioPlayerUI
{

    import flash.display.MovieClip;
    import appManager.displayContentElemets.TitleText;
    import flash.events.Event;
    import flash.events.MouseEvent;

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

        private var player:* ;


        private var lineMC:MovieClip,
                    cursolMC:MovieClip ;

        private var seekAreaMC:MovieClip ;

        private var pauseMC:MovieClip,
                    playMC:MovieClip;

        private var currentPositionTF:TitleText,
                    titleTF:TitleText,
                    durationTF:TitleText;

        private var lastPosition:Number,lastDuration:Number ;

        private static var ME:DistriqtAudioPlayerUI ;

        private var seekPermission:Boolean = false ;

        private var speedMC:MovieClip ;

        private var closeMC:MovieClip ;

        private var hidden:Boolean = true ;

        public function DistriqtAudioPlayerUI()
        {
            super();

            lineMC = Obj.get("line_mc",this);
            lineMC.mouseChildren = lineMC.mouseEnabled = false ;
            cursolMC = Obj.get("cursol_mc",this);
            cursolMC.mouseChildren = cursolMC.mouseEnabled = false ;
            pauseMC = Obj.get("pause_mc",this);
                Obj.setButton(pauseMC,pauseCurrentSound);
            playMC = Obj.get("play_mc",this);
                Obj.setButton(playMC,startPlayingCurrentSound);
            currentPositionTF = Obj.get("current_time_mc",this);
            titleTF = Obj.get("title_mc",this);
            durationTF = Obj.get("total_tile_mc",this);
            speedMC = Obj.get("speed_mc",this);
            speedMC.gotoAndStop(1);
                Obj.setButton(speedMC,speedUp);
            seekAreaMC = Obj.get("seek_area_mc",this);

            closeMC = Obj.get("close_mc",this);
            Obj.setButton(closeMC,hide);

            pauseMC.visible = false ;

            this.addEventListener(Event.ENTER_FRAME,controlCursol);
            this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);

            seekAreaMC.addEventListener(MouseEvent.MOUSE_DOWN,permissionToSeek);

            ME = this ;

            setUp();

            hide();
        }

        private function hide():void
        {
            hidden = true ;
            pauseCurrentSound();
        }

        private function show():void
        {
            hidden = false ;
        }

        public static function playSound(soundURL:String,title:String=''):void
        {
            if(ME!=null)
            {
                ME.playSound(soundURL,title);
            }
        }

        private function speedUp():void
        {
            if(speedMC.currentFrame==1)
            {
                speedMC.gotoAndStop(2);
                player.setPlaybackSpeed(2);
            }
            else
            {
                speedMC.gotoAndStop(1);
                player.setPlaybackSpeed(1);
            }
        }

            private function permissionToSeek(e:MouseEvent):void
            {
                seekPermission = true ;
                stage.addEventListener(MouseEvent.MOUSE_UP,removeSeekPermission);
            }

            private function removeSeekPermission(e:MouseEvent):void
            {
                seekPermission = false ;
                stage.removeEventListener(MouseEvent.MOUSE_UP,removeSeekPermission);
            }


        private function pauseCurrentSound():void
        {
            setUp();
            if(player)player.pause();
        }

        private function startPlayingCurrentSound():void
        {
            setUp();
            if(player)player.play();
        }

        private function unLoad(e:Event):void
        {
            this.removeEventListener(Event.ENTER_FRAME,controlCursol);
            this.removeEventListener(Event.REMOVED_FROM_STAGE,unLoad);

            ME = null ;
        }

        private function controlCursol(e:Event):void
        {

            if(hidden)
            {
                this.prevFrame();
                if(this.currentFrame == 1)
                    this.visible = false ;
            }
            else
            {
                this.nextFrame();
                this.visible = true ;
            }
            if(player==null)return;
            if(seekPermission)
            {
                if(this.mouseX<lineMC.x+lineMC.width && this.mouseX>lineMC.x)
                {
                    var seekTo:Number = player.duration*(this.mouseX-lineMC.x)/lineMC.width ;
                    trace("seekTo : "+seekTo);
                    player.seek(seekTo);
                }
            }

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

        public function playSound(soundPathURL:String,title:String=''):void
        {
            show();
            setUp();
            trace("Play function called")
            if(AudioPlayerClass==null)return;
            trace("player : "+player+" << "+soundPathURL);
            player.load(soundPathURL);
            player.play();
            titleTF.text = title ;
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
                var options:* = new AudioPlayerOptionsClass();
                    (options).enableBackgroundAudio(true);
                    options.enablePlaybackSpeed(true);
                player = (MediaPlayerClass).service.createAudioPlayer(); 
                player.addEventListener( (AudioPlayerEventClass as Object).PLAYING, audioPlayer_played );
                player.addEventListener( (AudioPlayerEventClass as Object).PAUSED, audioPlayer_completeHandler );
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
            speedMC.gotoAndStop(1);
            player.setPlaybackSpeed(1);
        }

        private function audioPlayer_paused(event:*):void
        {
            pauseMC.visible = false ;
            playMC.visible = true ;
        }
       
    }
}
