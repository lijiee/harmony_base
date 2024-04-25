import { media } from '@kit.MediaKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { VideoConstants } from '../constants/VideoConstants';
import { LogUtils } from './LogUtils';
import { VideoSpeed } from '../entity/VideoSpeed';

export class AvPlayerUtils {
  private avPlayer?: media.AVPlayer;
  private iUrl: string = '';
  private playState: string = 'idle';
  private surfaceId: string = '';
  private sliderBegin: number = 0;
  private startTime: number = 0;
  private onError: (err: BusinessError) => void = (err: BusinessError) => {
    LogUtils.error(`Invoke avPlayer failed, code is ${err.code}, message is ${err.message}`);
    if (this.avPlayer === undefined) {
      LogUtils.error(`AvPlayer is undefined`);
      return;
    }
    this.avPlayer.reset();
  }
  private onTimeUpdateFunction: (updateTime: number) => void = (updateTime: number) => {
    if (this.avPlayer === undefined) {
      LogUtils.error(`AvPlayer is undefined`);
      return;
    }
    AppStorage.setOrCreate<string>(VideoConstants.AV_PLAYER_CURRENT_TIME, this.formatTime(updateTime));
    AppStorage.setOrCreate<number>(VideoConstants.AV_PLAYER_PROGRESS, updateTime / this.avPlayer.duration *
    VideoConstants.PROGRESS_HUNDRED);
  }
  private onStateChange: (state: media.AVPlayerState) => void = async (state: media.AVPlayerState) => {
    if (this.avPlayer === undefined) {
      LogUtils.error(`AvPlayer is undefined`);
      return;
    }
    this.playState = state;
    AppStorage.setOrCreate<string>(VideoConstants.AV_PLAYER_STATE, state);
    switch (state) {
      case VideoConstants.AV_PLAYER_IDLE_STATE:
        this.avPlayer.url = this.iUrl;
        LogUtils.info('AVPlayer state idle called.');
        break;
      case VideoConstants.AV_PLAYER_INITIALIZED_STATE:
        LogUtils.info('AVPlayer initialized called.');
        this.avPlayer.surfaceId = this.surfaceId;
        this.avPlayer.prepare().then(() => {
          LogUtils.info('AVPlayer prepare succeeded.');
        }, (err: BusinessError) => {
          LogUtils.error(`Invoke prepare failed, code is ${err.code}, message is ${err.message}`);
          if (this.avPlayer === undefined) {
            LogUtils.error(`AvPlayer is undefined`);
            return;
          }
          this.avPlayer.reset();
        });
        break;
      case VideoConstants.AV_PLAYER_PREPARED_STATE:
        this.avPlayer.videoScaleType = media.VideoScaleType.VIDEO_SCALE_TYPE_FIT;
        LogUtils.info('AVPlayer state prepared called.');
        this.seekToStart();
        this.avPlayer.play();
        AppStorage.setOrCreate<string>(VideoConstants.AV_PLAYER_TOTAL_TIME, this.formatTime(this.avPlayer.duration));
        break;
      case VideoConstants.AV_PLAYER_PLAYING_STATE:
        LogUtils.info('AVPlayer state playing called.');
        this.seekToStart();
        break;
      case VideoConstants.AV_PLAYER_PAUSED_STATE:
        LogUtils.info('AVPlayer state paused called.');
        this.seekToStart();
        break;
      case VideoConstants.AV_PLAYER_COMPLETED_STATE:
        LogUtils.info('AVPlayer state completed called.');
        this.avPlayer.stop();
        break;
      case VideoConstants.AV_PLAYER_STOPPED_STATE:
        LogUtils.info('AVPlayer state stopped called.');
        break;
      case VideoConstants.AV_PLAYER_RELEASE_STATE:
        LogUtils.info('AVPlayer state released called.');
        break;
      case VideoConstants.AV_PLAYER_ERROR_STATE:
        LogUtils.error('AVPlayer state error called.');
        break;
      default:
        LogUtils.info('AVPlayer state unknown called.');
        break;
    }
  }

  async createAvPlayer(surfaceId: string, iUrl: string): Promise<void> {
    this.iUrl = iUrl;
    if (this.avPlayer === undefined || this.avPlayer.state === VideoConstants.AV_PLAYER_RELEASE_STATE) {
      this.avPlayer = await media.createAVPlayer();
      this.surfaceId = surfaceId;
      LogUtils.info('Created AvPlayer successfully.');
      // Entering idle state.
      this.avPlayer.url = this.iUrl;
      this.setAVPlayerCallback();
    } else {
      LogUtils.info(`AvPlayer has been created`);
    }
  }

  setAVPlayerCallback(): void {
    if (this.avPlayer === undefined) {
      LogUtils.error(`AvPlayer is undefined`);
      return;
    }
    this.avPlayer.on('error', this.onError);
    this.onTimeUpdate();
    this.setStateChange();
  }

  onTimeUpdate(): void {
    if (this.avPlayer === undefined) {
      LogUtils.error(`AvPlayer is undefined`);
      return;
    }
    this.avPlayer.on('timeUpdate', this.onTimeUpdateFunction);
  }

  offTimeUpdate(): void {
    if (this.avPlayer === undefined) {
      LogUtils.error(`AvPlayer is undefined`);
      return;
    }
    try {
      this.avPlayer.off('timeUpdate');
    } catch (exception) {
      console.error('Failed to unregister callback. Code: ' + JSON.stringify(exception));
    }
  }

  setStateChange(): void {
    if (this.avPlayer === undefined) {
      LogUtils.error(`AvPlayer is undefined`);
      return;
    }
    this.avPlayer.on('stateChange', this.onStateChange)
  }

  setStartTime(startTime: number): void {
    this.startTime = startTime;
  }

  seekToStart(): void {
    if (this.startTime != 0 && this.avPlayer !== undefined) {
      this.avPlayer.seek(this.startTime);
      this.startTime = 0;
    } else {
      LogUtils.info(`Video is played from the beginning`);
    }
  }

  release(): void {
    if (this.avPlayer !== undefined && this.avPlayer.state !== VideoConstants.AV_PLAYER_RELEASE_STATE) {
      try {
        this.avPlayer.off('error');
        this.avPlayer.off('stateChange');
      } catch (exception) {
        console.error('Failed to unregister callback. Code: ' + JSON.stringify(exception));
      }
      this.avPlayer.release();
    } else {
      LogUtils.info(`AvPlayer release failed`);
    }
  }

  sliderChange(value: number, mode: SliderChangeMode): void {
    let seekType: media.SeekMode = value > this.sliderBegin ? media.SeekMode.SEEK_PREV_SYNC :
    media.SeekMode.SEEK_NEXT_SYNC;
    if (this.avPlayer === undefined) {
      LogUtils.error(`AvPlayer is undefined`);
      return;
    }
    switch (mode) {
      case SliderChangeMode.Begin:
        LogUtils.info(`AvPlayer SliderChangeMode Begin`);
        this.sliderBegin = value;
        this.avPlayer.pause();
        break;
      case SliderChangeMode.Moving:
        LogUtils.info(`AvPlayer SliderChangeMode Moving`);
        this.avPlayer.seek(value / VideoConstants.PROGRESS_HUNDRED * this.avPlayer.duration, seekType);
        break;
      case SliderChangeMode.End:
        LogUtils.info(`AvPlayer SliderChangeMode End`);
        this.avPlayer.play();
        break;
      case SliderChangeMode.Click:
        LogUtils.info(`AvPlayer SliderChangeMode Click`);
        this.avPlayer.seek(this.sliderBegin / VideoConstants.PROGRESS_HUNDRED * this.avPlayer.duration, seekType);
        break;
      default:
        break;
    }

  }

  playerStateControl(): void {
    if (this.avPlayer === undefined) {
      LogUtils.error(`AvPlayer is undefined`);
      return;
    }
    if (this.avPlayer.state === VideoConstants.AV_PLAYER_STOPPED_STATE) {
      this.avPlayer.prepare();
      AppStorage.setOrCreate<string>(VideoConstants.AV_PLAYER_STATE, VideoConstants.AV_PLAYER_PREPARED_STATE);
      return;
    }
    if (this.playState !== VideoConstants.AV_PLAYER_PLAYING_STATE) {
      this.avPlayer.play();
    } else {
      this.avPlayer.pause();
    }
  }

  play(): void {
    if (this.avPlayer !== undefined && this.playState !== VideoConstants.AV_PLAYER_PLAYING_STATE) {
      this.avPlayer.play();
    } else {
      LogUtils.info(`AvPlayer play failed`);
    }
  }

  pause(): void {
    if (this.avPlayer !== undefined && this.playState === VideoConstants.AV_PLAYER_PLAYING_STATE) {
      this.avPlayer.pause();
    } else {
      LogUtils.info(`AvPlayer pause failed`);
    }
  }

  getCurrentTime(): number {
    if (this.avPlayer === undefined) {
      LogUtils.error(`AvPlayer is undefined`);
      return 0;
    }
    return this.avPlayer.currentTime;
  }

  formatTime(duration: number): string {
    let totalSecond: number = Math.round(duration / VideoConstants.PROGRESS_THOUSAND);
    let hourNum: number = Math.floor(totalSecond / VideoConstants.SECOND_IN_HOUR);
    let minNum: number = Math.floor((totalSecond % VideoConstants.SECOND_IN_HOUR) / VideoConstants.SECOND_IN_MINUTE);
    let secNum: number = (totalSecond % VideoConstants.SECOND_IN_HOUR) % VideoConstants.SECOND_IN_MINUTE;
    return this.formatUnitTime(hourNum) + VideoConstants.COLON + this.formatUnitTime(minNum) + VideoConstants.COLON +
    this.formatUnitTime(secNum);
  }

  formatUnitTime(time: number): string {
    if (time >= VideoConstants.ONE && time < VideoConstants.TEN) {
      let zero: string = VideoConstants.TIME_PREFIX;
      return zero.concat(time.toString());
    } else if (time >= VideoConstants.ZERO && time < VideoConstants.ONE) {
      return VideoConstants.EMPTY_TIME;
    }
    return time.toString();
  }

  setSpeed(speed: VideoSpeed) {
    if (this.avPlayer === null) {
      return;
    }
    if (VideoConstants.OPERATE_STATE.indexOf(this.avPlayer!.state) === -1) {
      return;
    }
    AppStorage.setOrCreate<string>(VideoConstants.AV_PLAYER_SPEED, speed.text);
    this.avPlayer?.setSpeed(speed.value);
  }

  changeVideoUrl(iUrl: string) {
    if (this.avPlayer === null) {
      return;
    }
    if (VideoConstants.OPERATE_STATE.indexOf(this.avPlayer!.state) === -1) {
      return;
    }
    this.iUrl = iUrl;
    this.avPlayer?.reset();
  }
}