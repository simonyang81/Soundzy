import { http } from '@kit.NetworkKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = 'HttpUtil';
const DOMAIN = 0xFF00;

/**
 * HTTP请求配置接口
 */
export interface HttpConfig {
  /** 请求URL */
  url: string;
  /** 请求方法 */
  method?: http.RequestMethod;
  /** 请求头 */
  headers?: Record<string, string>;
  /** 请求参数 */
  params?: Record<string, string | number | boolean>;
  /** 请求体数据 */
  data?: string | Object;
  /** 连接超时时间（毫秒） */
  connectTimeout?: number;
  /** 读取超时时间（毫秒） */
  readTimeout?: number;
}

/**
 * HTTP响应接口
 */
export interface HttpResponse<T> {
  /** 响应状态码 */
  statusCode: number;
  /** 响应数据 */
  data: T;
  /** 响应头 */
  headers: Record<string, string>;
  /** 原始响应文本 */
  result: string;
}

/**
 * API响应数据格式接口
 */
export interface ApiResponse<T> {
  /** 业务状态码 */
  code: number;
  /** 响应消息 */
  message: string;
  /** 响应数据 */
  data: T;
}

/**
 * 默认配置类
 */
class DefaultConfig {
  method: http.RequestMethod = http.RequestMethod.GET;
  connectTimeout: number = 10000;
  readTimeout: number = 30000;
  headers: Record<string, string> = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };
}

/**
 * HTTP工具类
 * 封装鸿蒙网络请求功能，提供类型安全的JSON API调用
 */
export class HttpUtil {
  /** 默认配置 */
  private static defaultConfig: DefaultConfig = new DefaultConfig();

  /** 基础URL */
  private static baseUrl: string = '';

  /** 公共请求头 */
  private static commonHeaders: Record<string, string> = {};

  /**
   * 设置公共请求头
   * @param headers 请求头对象
   */
  static setCommonHeaders(headers: Record<string, string>): void {
    const keys = Object.keys(headers);
    for (let i = 0; i < keys.length; i++) {
      const key = keys[i];
      HttpUtil.commonHeaders[key] = headers[key];
    }
  }

  /**
   * 设置认证Token
   * @param token 认证令牌
   */
  static setAuthToken(token: string): void {
    const authHeaders: Record<string, string> = {};
    authHeaders['Authorization'] = `Bearer ${token}`;
    HttpUtil.setCommonHeaders(authHeaders);
  }

  /**
   * 移除认证Token
   */
  static removeAuthToken(): void {
    const newHeaders: Record<string, string> = {};
    const keys = Object.keys(HttpUtil.commonHeaders);
    for (let i = 0; i < keys.length; i++) {
      const key = keys[i];
      if (key !== 'Authorization') {
        newHeaders[key] = HttpUtil.commonHeaders[key];
      }
    }
    HttpUtil.commonHeaders = newHeaders;
  }

  /**
   * 构建完整URL
   * @param url 请求路径
   * @returns 完整URL
   */
  private static buildUrl(url: string): string {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    return HttpUtil.baseUrl + (url.startsWith('/') ? url : '/' + url);
  }

  /**
   * 构建查询参数字符串
   * @param params 参数对象
   * @returns 查询参数字符串
   */
  private static buildQueryString(params: Record<string, string | number | boolean>): string {
    if (!params) {
      return '';
    }
    
    const keys = Object.keys(params);
    if (keys.length === 0) {
      return '';
    }
    
    const queryPairs: string[] = [];
    for (let i = 0; i < keys.length; i++) {
      const key = keys[i];
      const value = params[key];
      if (value !== undefined && value !== null) {
        queryPairs.push(`${encodeURIComponent(key)}=${encodeURIComponent(String(value))}`);
      }
    }
    
    return queryPairs.length > 0 ? '?' + queryPairs.join('&') : '';
  }

  /**
   * 合并请求头
   * @param customHeaders 自定义请求头
   * @returns 合并后的请求头
   */
  private static mergeHeaders(customHeaders?: Record<string, string>): Record<string, string> {
    const merged: Record<string, string> = {};
    
    // 添加默认请求头
    const defaultKeys = Object.keys(HttpUtil.defaultConfig.headers);
    for (let i = 0; i < defaultKeys.length; i++) {
      const key = defaultKeys[i];
      merged[key] = HttpUtil.defaultConfig.headers[key];
    }
    
    // 添加公共请求头
    const commonKeys = Object.keys(HttpUtil.commonHeaders);
    for (let i = 0; i < commonKeys.length; i++) {
      const key = commonKeys[i];
      merged[key] = HttpUtil.commonHeaders[key];
    }
    
    // 添加自定义请求头
    if (customHeaders) {
      const customKeys = Object.keys(customHeaders);
      for (let i = 0; i < customKeys.length; i++) {
        const key = customKeys[i];
        merged[key] = customHeaders[key];
      }
    }
    
    return merged;
  }

  /**
   * 通用HTTP请求方法
   * @param config 请求配置
   * @returns Promise<HttpResponse<T>>
   */
  static async request<T>(config: HttpConfig): Promise<HttpResponse<T>> {
    try {

      // 构建完整URL
      let fullUrl = HttpUtil.buildUrl(config.url);
      
      // 获取请求方法
      const method = config.method || HttpUtil.defaultConfig.method;
      
      // 处理GET请求参数
      if (method === http.RequestMethod.GET && config.params) {
        fullUrl += HttpUtil.buildQueryString(config.params);
      }

      // 合并请求头
      const headers = HttpUtil.mergeHeaders(config.headers);

      // 构建请求体数据
      let requestData: string | undefined;
      if (config.data) {
        if (typeof config.data === 'string') {
          requestData = config.data;
        } else {
          requestData = JSON.stringify(config.data);
        }
      }

      // 创建HTTP请求
      const httpRequest = http.createHttp();
      
      hilog.info(DOMAIN, TAG, `-->> 发起请求: ${method} ${fullUrl}`);
      
      // 发送请求
      const response = await httpRequest.request(fullUrl, {
        method: method,
        header: headers,
        extraData: requestData,
        expectDataType: http.HttpDataType.STRING,
        connectTimeout: config.connectTimeout || HttpUtil.defaultConfig.connectTimeout,
        readTimeout: config.readTimeout || HttpUtil.defaultConfig.readTimeout
      });

      // 销毁请求对象
      httpRequest.destroy();

      hilog.info(DOMAIN, TAG, `-->> 请求完成: ${response.responseCode}`);

      // 解析响应数据
      let parsedData: T;
      try {
        const resultStr = response.result as string;
        hilog.debug(DOMAIN, TAG, `-->> 请求返回的response: ${resultStr}`);
        parsedData = JSON.parse(resultStr) as T;
        hilog.debug(DOMAIN, TAG, `-->> JSON解析后的对象类型: ${typeof parsedData}`)
      } catch (error) {
        hilog.warn(DOMAIN, TAG, `-->> JSON解析失败，返回原始字符串: ${error}`);
        parsedData = response.result as T;
      }

      const httpResponse: HttpResponse<T> = {
        statusCode: response.responseCode,
        data: parsedData,
        headers: response.header as Record<string, string>,
        result: response.result as string
      };

      return httpResponse;

    } catch (error) {
      hilog.error(DOMAIN, TAG, `-->> 网络请求失败: ${JSON.stringify(error)}`);
      throw new Error(`-->> 网络请求失败: ${error}`);
    }
  }

  /**
   * GET请求
   * @param url 请求URL
   * @param params 查询参数
   * @param headers 自定义请求头
   * @returns Promise<HttpResponse<T>>
   */
  static async get<T>(
    url: string, 
    params?: Record<string, string | number | boolean>,
    headers?: Record<string, string>
  ): Promise<HttpResponse<T>> {
    const config: HttpConfig = {
      url: url,
      method: http.RequestMethod.GET,
      params: params,
      headers: headers
    };
    return HttpUtil.request<T>(config);
  }

  /**
   * POST请求
   * @param url 请求URL
   * @param data 请求体数据
   * @param headers 自定义请求头
   * @returns Promise<HttpResponse<T>>
   */
  static async post<T>(
    url: string, 
    data?: Object | string, 
    headers?: Record<string, string>
  ): Promise<HttpResponse<T>> {
    const config: HttpConfig = {
      url: url,
      method: http.RequestMethod.POST,
      data: data,
      headers: headers
    };
    return HttpUtil.request<T>(config);
  }

  /**
   * PUT请求
   * @param url 请求URL
   * @param data 请求体数据
   * @param headers 自定义请求头
   * @returns Promise<HttpResponse<T>>
   */
  static async put<T>(
    url: string, 
    data?: Object | string, 
    headers?: Record<string, string>
  ): Promise<HttpResponse<T>> {
    const config: HttpConfig = {
      url: url,
      method: http.RequestMethod.PUT,
      data: data,
      headers: headers
    };
    return HttpUtil.request<T>(config);
  }

  /**
   * DELETE请求
   * @param url 请求URL
   * @param headers 自定义请求头
   * @returns Promise<HttpResponse<T>>
   */
  static async delete<T>(
    url: string, 
    headers?: Record<string, string>
  ): Promise<HttpResponse<T>> {
    const config: HttpConfig = {
      url: url,
      method: http.RequestMethod.DELETE,
      headers: headers
    };
    return HttpUtil.request<T>(config);
  }

  /**
   * API请求方法（自动处理业务状态码）
   * @param config 请求配置
   * @returns Promise<T> 直接返回业务数据
   */
  static async api<T>(config: HttpConfig): Promise<T> {
    const response = await HttpUtil.request<ApiResponse<T>>(config);
    
    // 检查HTTP状态码
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw new Error(`HTTP错误: ${response.statusCode}`);
    }

    // 检查业务状态码
    if (response.data.code !== 200 && response.data.code !== 0) {
      throw new Error(response.data.message || '业务处理失败');
    }

    return response.data.data;
  }

  /**
   * GET API请求
   * @param url 请求URL
   * @param params 查询参数
   * @returns Promise<T> 业务数据
   */
  static async getApi<T>(
    url: string, 
    params?: Record<string, string | number | boolean>
  ): Promise<T> {
    const config: HttpConfig = {
      url: url,
      method: http.RequestMethod.GET,
      params: params
    };
    return HttpUtil.api<T>(config);
  }

  /**
   * POST API请求
   * @param url 请求URL
   * @param data 请求体数据
   * @returns Promise<T> 业务数据
   */
  static async postApi<T>(url: string, data?: Object | string): Promise<T> {
    const config: HttpConfig = {
      url: url,
      method: http.RequestMethod.POST,
      data: data
    };
    return HttpUtil.api<T>(config);
  }

  /**
   * PUT API请求
   * @param url 请求URL
   * @param data 请求体数据
   * @returns Promise<T> 业务数据
   */
  static async putApi<T>(url: string, data?: Object | string): Promise<T> {
    const config: HttpConfig = {
      url: url,
      method: http.RequestMethod.PUT,
      data: data
    };
    return HttpUtil.api<T>(config);
  }

  /**
   * DELETE API请求
   * @param url 请求URL
   * @returns Promise<T> 业务数据
   */
  static async deleteApi<T>(url: string): Promise<T> {
    const config: HttpConfig = {
      url: url,
      method: http.RequestMethod.DELETE
    };
    return HttpUtil.api<T>(config);
  }
} 