/**
 * API配置文件
 * 管理API相关的配置信息
 */

/**
 * 音乐相关API端点接口
 */
interface MusicDetailUrls {
  RECOMMEND: string;
  SEARCH: string;
  DETAIL: string;
  PLAYLISTS: string;
  SONGS: string;
}

/**
 * 播放列表相关API端点接口
 */
interface PlaylistUrls {
  NEW_SONG_CHART: string;
  SONGS_CATEGORY: string;
  // CREATE: string;
  // UPDATE: string;
  // DELETE: string;
  // SONGS: string;
}

/**
 * API端点集合接口
 */
interface ApiUrl {
  PLAYLIST: PlaylistUrls;
  MUSIC: MusicDetailUrls;
}

/**
 * 超时配置接口
 */
interface TimeoutConfig {
  CONNECT: number;
  READ: number;
}

/**
 * 状态码配置接口
 */
interface StatusCodeConfig {
  SUCCESS: number;
  UNAUTHORIZED: number;
  FORBIDDEN: number;
  NOT_FOUND: number;
  SERVER_ERROR: number;
}

export class ApiConfig {

  /** API端点定义 */
  static readonly URLS: ApiUrl = {

    // 播放列表相关
    PLAYLIST: {
      NEW_SONG_CHART: 'http://m.kugou.com/',
      SONGS_CATEGORY: 'http://mobilecdnbj.kugou.com/api/v3/rank/list',
    },

    // 音乐相关
    MUSIC: {
      RECOMMEND: '/music/recommend',
      SEARCH: '/music/search',
      DETAIL: '/music/detail',
      PLAYLISTS: '/music/playlists',
      SONGS: '/music/songs'
    },
    
  };
  
  /** 请求超时配置 */
  static readonly TIMEOUT: TimeoutConfig = {
    CONNECT: 10000,  // 连接超时 10秒
    READ: 30000      // 读取超时 30秒
  };
  
  /** 通用响应状态码 */
  static readonly STATUS_CODE: StatusCodeConfig = {
    SUCCESS: 200,
    UNAUTHORIZED: 401,
    FORBIDDEN: 403,
    NOT_FOUND: 404,
    SERVER_ERROR: 500
  };
} 