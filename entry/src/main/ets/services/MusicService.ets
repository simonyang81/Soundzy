import { HttpUtil } from '../utils/HttpUtil';
import { ApiConfig } from '../config/ApiConfig';
import { BaseService } from './BaseService';
import { hilog } from '@kit.PerformanceAnalysisKit';

/**
 * 推荐歌曲接口
 */
export interface Song {
  data: SongData[],
  banner: Banner[],
}

export interface Banner {
  online: number,
  title: string,
  id: number,
  type: number,
  imgurl: string,
}

export interface SongData {
  album_sizable_cover: string,
  hash: string,
  songname: string,
  singer_name: string,
  filename: string,
}

export interface Category {
  data: CategorySongData,
}

export interface SongByCategory {
  data: SongByCategoryData
}

export interface SongByCategoryData {
  info: SongByCategoryDataInfo[],
}

export interface CategorySongData {
  info: CategoryInfo[],
}

export interface SongByCategoryDataInfo {
  songname: string,
  hash: string,
  album_sizable_cover: string,
  authors: Authors[],
}

export interface Authors {
  author_name: string,
  sizable_avatar: string,
}

export interface CategoryInfo {
  rankname: string,
  album_img_9: string,
  rankid: string,
  intro: string,
}

class BaseDataSource<T> implements IDataSource {

  protected originDataArray: T[] = [];
  protected listeners: DataChangeListener[] = [];

  totalCount(): number {
    return this.originDataArray.length;
  }

  getData(index: number): T {
    return this.originDataArray[index];
  }

  public pushDataAll(data: T[]): void {
    this.originDataArray.push(...data);
    this.notifyDataAdd(this.originDataArray.length - 1);
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    });
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    });
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    });
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    });
  }

  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    });
  }

  notifyDatasetChange(operations: DataOperation[]): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange(operations);
    });
  }

}

export class CategoryInfoData extends BaseDataSource<CategoryInfo> {
  clearData(): void {
    this.originDataArray = [];
  }
}

const TAG = 'MusicService';
const DOMAIN = 0xFF00;

/**
 * 音乐服务类
 * 处理音乐相关的API请求
 */
export class MusicService extends BaseService {

  /**
   * 获取新歌榜数据
   * @returns Promise<Song>
   */
  static async getNewSongs(): Promise<Song> {

    try {

      hilog.info(DOMAIN, TAG, '-->> 开始获取新歌')

      const response = await HttpUtil.get<Song>(
        ApiConfig.URLS.PLAYLIST.NEW_SONG_CHART,
        {'json': true}
      );

      return response.data;
    } catch (error) {
      throw new Error(super.handleError(error as Error));
    }
  }

  static async getCategories(): Promise<Category> {
    try {

      hilog.info(DOMAIN, TAG, '-->> 开始获取歌曲分类列表')

      const response = await HttpUtil.get<Category>(
        ApiConfig.URLS.PLAYLIST.CATEGORIES,
      );

      return response.data;
    } catch (error) {
      throw new Error(super.handleError(error as Error));
    }

  }

  static async getSongs(id: string): Promise<SongByCategory> {
    try {

      hilog.info(DOMAIN, TAG, '-->> 开始按分类获取歌曲列表')

      const response = await HttpUtil.get<SongByCategory>(
        ApiConfig.URLS.PLAYLIST.SONGS,
        { 'rankid': id, }
      );

      return response.data;
    } catch (error) {
      throw new Error(super.handleError(error as Error));
    }
  }

}