import '../provider/provider_config.dart';
import '../model/news_model.dart';
import 'base_http.dart';

class ServiceApi {

  static Future<int> apiNewsGetPageList({int page = 1, bool isRef = false})
  async {
    await Request.get(
      '/api/News/GetPageList',
      data: {"PageIndex": page, "city": app.cityCode ?? "-1"},
      catchError: (v) {
        // 当请求失败时，手动生成几条默认数据
        List<Map<String, dynamic>> defaultNews = [
          {
            'preview': 'https://via.placeholder.com/400x300/FF6B6B/FFFFFF?text=资讯1',
            'content': '',
            'title': '默认资讯标题1'
          },
          {
            'preview': 'https://via.placeholder.com/400x300/4ECDC4/FFFFFF?text=资讯2',
            'content': '',
            'title': '默认资讯标题2'
          },
          {
            'preview': 'https://via.placeholder.com/400x300/45B7D1/FFFFFF?text=资讯3',
            'content': '',
            'title': '默认资讯标题3'
          },
        ];
        NewsModel.zixunDm.addList(defaultNews, isRef, defaultNews.length);
      },
      success: (v) {
        NewsModel.zixunDm.addList(v['data'], isRef, v['total']);
      },
    );
    return NewsModel.zixunDm.flag!;
  }
}

class ExportSourceType {
  static const String healthRecords = 'HEALTH_RECORDS';
  static const String exdHealthRecords = 'EXTERNAL_DEVICE_HEALTH_RECORDS';
}