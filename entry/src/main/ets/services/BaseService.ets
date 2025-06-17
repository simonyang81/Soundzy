import { HttpUtil } from '../utils/HttpUtil';

/**
 * 服务基类
 * 提供通用的服务功能
 */
export abstract class BaseService {
  /**
   * 初始化HTTP工具
   */
  static initialize(): void {

    // 设置公共请求头
    HttpUtil.setCommonHeaders({
      'User-Agent': 'Soundzy-HarmonyOS/1.0.0',
      'Accept-Language': 'zh-CN,zh;q=0.9'
    });
  }

  /**
   * 处理业务错误
   * @param error 错误对象
   * @returns 处理后的错误信息
   */
  protected static handleError(error: Error): string {
    if (error.message.includes('网络')) {
      return '网络连接失败，请检查网络设置';
    } else if (error.message.includes('超时')) {
      return '请求超时，请稍后重试';
    } else if (error.message.includes('401')) {
      return '用户未登录或登录已过期';
    } else if (error.message.includes('403')) {
      return '没有权限访问该资源';
    } else if (error.message.includes('404')) {
      return '请求的资源不存在';
    } else if (error.message.includes('500')) {
      return '服务器内部错误，请稍后重试';
    }
    return error.message || '未知错误';
  }
} 