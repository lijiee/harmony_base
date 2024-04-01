import { VideoSpeed } from '../entity/VideoSpeed';

export class VideoConstants {
  /**
   * Window util.
   */
  static readonly WINDOW_UTIL: string = 'windowUtils';

  /**
   * Device types.
   */
  static readonly DEVICE_TYPES: string[] = ['2in1', 'tablet', 'phone'];

  /**
   * Idle state of avPlayer.
   */
  static readonly AV_PLAYER_IDLE_STATE: string = 'idle';

  /**
   * Initialized state of avPlayer.
   */
  static readonly AV_PLAYER_INITIALIZED_STATE: string = 'initialized';

  /**
   * Prepared state of avPlayer.
   */
  static readonly AV_PLAYER_PREPARED_STATE: string = 'prepared';

  /**
   * Playing state of avPlayer.
   */
  static readonly AV_PLAYER_PLAYING_STATE: string = 'playing';

  /**
   * Pause state of avPlayer.
   */
  static readonly AV_PLAYER_PAUSED_STATE: string = 'paused';

  /**
   * Completed state of avPlayer.
   */
  static readonly AV_PLAYER_COMPLETED_STATE: string = 'completed';

  /**
   * Stopped state of avPlayer.
   */
  static readonly AV_PLAYER_STOPPED_STATE: string = 'stopped';

  /**
   * Release state of avPlayer.
   */
  static readonly AV_PLAYER_RELEASE_STATE: string = 'released';

  /**
   * Error state of avPlayer.
   */
  static readonly AV_PLAYER_ERROR_STATE: string = 'error';
  /**
   *  state of avPlayer.
   */
  static readonly AV_PLAYER_STATE: string = 'playStatus';

  /**
   * Current time of av player.
   */
  static readonly AV_PLAYER_CURRENT_TIME: string = 'currentTime';

  /**
   * Total time of av player.
   */
  static readonly AV_PLAYER_TOTAL_TIME: string = 'totalTime';

  /**
   * Progress of av player.
   */
  static readonly AV_PLAYER_PROGRESS: string = 'progress';
  /**
   * One hundred for progress.
   */
  static readonly PROGRESS_HUNDRED: number = 100;
  /**
   * Time prefix.
   */
  static readonly TIME_PREFIX: string = '0';
  /**
   * Empty time.
   */
  static readonly EMPTY_TIME: string = '00';
  /**
   * Second in hour.
   */
  static readonly SECOND_IN_HOUR: number = 3600;

  /**
   * Second in minute.
   */
  static readonly SECOND_IN_MINUTE: number = 60;

  /**
   * Zero.
   */
  static readonly ZERO: number = 0;

  /**
   * One.
   */
  static readonly ONE: number = 1;
  /**
   * Ten.
   */
  static readonly TEN: number = 10;
  /**
   * One thousand for progress.
   */
  static readonly PROGRESS_THOUSAND: number = 1000;
  /**
   * colon.
   */
  static readonly COLON: string = ':';

  static readonly OPERATE_STATE: Array<string> = ['prepared', 'playing', 'paused', 'completed'];

  /**
   * Video detail.
   */
  static readonly XComponent_ID : string = 'video';

  /**
   * Initial time.
   */
  static readonly INITIAL_TIME: string = '00:00:00';
  /**
   * X component surface width.
   */
  static readonly X_COMPONENT_SURFACE_WIDTH: number = 1920;

  /**
   * X component surface height.
   */
  static readonly X_COMPONENT_SURFACE_HEIGHT: number = 1080;

  static readonly VIDEO_ASPECT_RATIO: number = 1.78;
  static readonly SPEED_ARRAY: VideoSpeed[] = [
    new VideoSpeed('0.75X', 0),
    new VideoSpeed('1.0X', 1),
    new VideoSpeed('1.25X', 2),
    new VideoSpeed('1.75X', 3),
    new VideoSpeed('2.0X', 4)
  ];

  /**
   * Current speed of av player.
   */
  static readonly AV_PLAYER_SPEED: string = 'playSpeed';

}