/**
 * 入口页面：书籍列表 + 顶部天气卡片
 * 天气数据来自 Open-Meteo 公共接口（无需 API Key，免费，HTTPS）
 *   GET https://api.open-meteo.com/v1/forecast?latitude=...&longitude=...
 * 需要在 module.json5 声明 INTERNET 权限（本项目已加）
 */
import { http } from '@kit.NetworkKit'; // 网络请求模块
import { BusinessError } from '@kit.BasicServicesKit'; // 错误类型

interface listItem {
  id: number;
  title: string;
  description: string;
  author: string;
  price: number;
  category: string;
  rating: number;
}

// ==================== 天气接口 ====================
// 城市：武汉（经纬度 30.59, 114.31）。切换城市只需改 latitude / longitude。
const WEATHER_API_URL: string =
  'https://api.open-meteo.com/v1/forecast?latitude=30.59&longitude=114.31' +
    '&current=temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m' +
    '&daily=weather_code,temperature_2m_max,temperature_2m_min' +
    '&timezone=Asia%2FShanghai&forecast_days=5';

// 接口返回的 JSON 结构（只声明我们用到的字段）
interface CurrentWeather {
  temperature_2m: number; // 当前温度
  relative_humidity_2m: number; // 相对湿度
  apparent_temperature: number; // 体感温度
  weather_code: number; // WMO 天气代码
  wind_speed_10m: number; // 风速 km/h
}

interface DailyWeather {
  time: string[]; // 日期，如 2026-09-03
  weather_code: number[]; // 每天 WMO 代码
  temperature_2m_max: number[]; // 每天最高温
  temperature_2m_min: number[]; // 每天最低温
}

interface WeatherResponse {
  current: CurrentWeather;
  daily: DailyWeather;
}

// 页面展示用的单日天气
interface WeatherDay {
  label: string; // 今天 / 明天 / 周X
  icon: string; // 天气图标
  text: string; // 天气描述
  max: number; // 最高温
  min: number; // 最低温
}

// WMO 天气代码 → 中文描述
function weatherText(code: number): string {
  if (code === 0) {
    return '晴';
  }
  if (code === 1) {
    return '基本晴';
  }
  if (code === 2) {
    return '多云';
  }
  if (code === 3) {
    return '阴';
  }
  if (code === 45 || code === 48) {
    return '雾';
  }
  if (code === 51 || code === 53 || code === 55) {
    return '毛毛雨';
  }
  if (code === 56 || code === 57) {
    return '冻毛毛雨';
  }
  if (code === 61) {
    return '小雨';
  }
  if (code === 63) {
    return '中雨';
  }
  if (code === 65) {
    return '大雨';
  }
  if (code === 66 || code === 67) {
    return '冻雨';
  }
  if (code === 71) {
    return '小雪';
  }
  if (code === 73) {
    return '中雪';
  }
  if (code === 75) {
    return '大雪';
  }
  if (code === 77) {
    return '雪粒';
  }
  if (code === 80 || code === 81 || code === 82) {
    return '阵雨';
  }
  if (code === 85 || code === 86) {
    return '阵雪';
  }
  if (code === 95) {
    return '雷暴';
  }
  if (code === 96 || code === 99) {
    return '雷暴冰雹';
  }
  return '未知';
}

// WMO 天气代码 → 图标符号
function weatherIcon(code: number): string {
  if (code === 0) {
    return '☀';
  }
  if (code === 1) {
    return '🌤';
  }
  if (code === 2) {
    return '⛅';
  }
  if (code === 3) {
    return '☁';
  }
  if (code === 45 || code === 48) {
    return '🌫';
  }
  if (code >= 51 && code <= 57) {
    return '🌦';
  }
  if (code === 61 || code === 63 || code === 65) {
    return '🌧';
  }
  if (code === 66 || code === 67) {
    return '🌧';
  }
  if (code >= 71 && code <= 77) {
    return '🌨';
  }
  if (code >= 80 && code <= 82) {
    return '🌧';
  }
  if (code === 85 || code === 86) {
    return '🌨';
  }
  if (code >= 95) {
    return '⛈';
  }
  return '？';
}

// 日期字符串 → 「今天 / 明天 / 周X」
function dayLabel(dateStr: string, index: number): string {
  if (index === 0) {
    return '今天';
  }
  if (index === 1) {
    return '明天';
  }
  const weeks: string[] = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
  return weeks[new Date(dateStr).getDay()];
}

@Entry
@Component
struct Index {
  @State list: listItem[] = [
    {
      id: 1,
      title: "深度学习入门：基于Python的理论与实现",
      description: "日本深度学习专家斋藤康毅所著，用通俗易懂的语言和直观的代码，手把手带你从零实现神经网络，是AI入门必读之作。",
      author: "斋藤康毅",
      price: 89.9,
      category: "技术",
      rating: 9.2
    },
    {
      id: 2,
      title: "长安的荔枝",
      description: "马伯庸以「一骑红尘妃子笑」为引，讲述了一个小吏跨越五千里运送鲜荔枝的荒诞故事，于细微处见大唐盛世的另一面。",
      author: "马伯庸",
      price: 59.0,
      category: "小说",
      rating: 8.8
    },
    {
      id: 3,
      title: "也许你该找个人聊聊",
      description: "心理治疗师洛莉·戈特利布以双重视角——治疗师和来访者——讲述了四个真实案例，温暖而犀利，让人在故事中看见自己的影子。",
      author: "洛莉·戈特利布",
      price: 68.0,
      category: "心理学",
      rating: 9.0
    }
  ];
  // ==================== 天气状态 ====================
  @State loading: boolean = false; // 是否正在请求
  @State errorMsg: string = ''; // 失败时的错误信息
  @State temp: number = 0; // 当前温度
  @State feels: number = 0; // 体感温度
  @State humidity: number = 0; // 湿度
  @State wind: number = 0; // 风速
  @State icon: string = ''; // 当前天气图标
  @State text: string = ''; // 当前天气描述
  @State daily: WeatherDay[] = []; // 未来 5 天预报

  // ---------- 天气请求 ----------
  fetchWeather(): void {
    this.loading = true;
    this.errorMsg = '';

    // ① 创建请求对象
    const httpRequest = http.createHttp();

    // ② 发起 GET 请求
    httpRequest.request(
      WEATHER_API_URL,
      {
        method: http.RequestMethod.GET,
        connectTimeout: 10000, // 连接超时（毫秒）
        readTimeout: 10000       // 读取超时（毫秒）
      }
    )
    // ③ 成功回调
      .then((response: http.HttpResponse) => {
        if (response.responseCode === 200) {
          // response.result 是返回内容，先转 string 再 JSON.parse
          const data = JSON.parse(response.result as string) as WeatherResponse;
          const cur = data.current;

          // 当前天气
          this.temp = cur.temperature_2m;
          this.feels = cur.apparent_temperature;
          this.humidity = cur.relative_humidity_2m;
          this.wind = cur.wind_speed_10m;
          this.icon = weatherIcon(cur.weather_code);
          this.text = weatherText(cur.weather_code);

          // 未来 5 天预报
          const times: string[] = data.daily.time;
          const codes: number[] = data.daily.weather_code;
          const maxs: number[] = data.daily.temperature_2m_max;
          const mins: number[] = data.daily.temperature_2m_min;
          const days: WeatherDay[] = [];
          for (let i = 0; i < times.length; i++) {
            days.push({
              label: dayLabel(times[i], i),
              icon: weatherIcon(codes[i]),
              text: weatherText(codes[i]),
              max: maxs[i],
              min: mins[i]
            });
          }
          this.daily = days;
        } else {
          this.errorMsg = `天气请求失败，HTTP 状态码: ${response.responseCode}`;
        }
      })
      // ④ 失败回调
      .catch((err: BusinessError) => {
        this.errorMsg = `天气加载失败: ${err.message}`;
      })
      // ⑤ 不管成功失败：关掉加载、销毁请求对象
      .finally(() => {
        this.loading = false;
        httpRequest.destroy();
      });
  }

  // 页面一出现就自动请求一次天气
  aboutToAppear(): void {
    this.fetchWeather();
  }

  // ---------- 天气卡片 ----------
  @Builder
  WeatherCard() {
    Column() {
      // 顶部：城市 + 刷新按钮
      Row() {
        Text('武汉').fontSize(16).fontWeight(700)
        Text('当前天气').fontSize(12).fontColor('#888888').margin({ left: 6 })
        Blank()
        Button('刷新')
          .fontSize(11)
          .height(26)
          .onClick(() => {
            this.fetchWeather();
          })
      }
      .width('100%')

      // 加载中
      if (this.loading) {
        Row({ space: 8 }) {
          LoadingProgress().width(24).height(24).color('#4f6ef2')
          Text('天气加载中…').fontSize(12).fontColor('#888888')
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .padding({ top: 14, bottom: 14 })
      } else if (this.errorMsg.length > 0) {
        // 失败
        Column() {
          Text(this.errorMsg).fontSize(12).fontColor('#e63946')
          Text('点击右上角「刷新」重试').fontSize(11).fontColor('#999999').margin({ top: 4 })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
        .padding({ top: 12, bottom: 12 })
      } else {
        // 成功：当前天气
        Row() {
          Text(this.icon).fontSize(44)
          Column({ space: 4 }) {
            Text(`${this.temp}°C`).fontSize(30).fontWeight(700)
            Text(`${this.text} · 体感 ${this.feels}°C`).fontSize(12).fontColor('#666666')
          }
          .alignItems(HorizontalAlign.Start)
          .margin({ left: 12 })

          Blank()
          Column({ space: 4 }) {
            Text(`湿度 ${this.humidity}%`).fontSize(12).fontColor('#666666')
            Text(`风速 ${this.wind} km/h`).fontSize(12).fontColor('#666666')
          }
          .alignItems(HorizontalAlign.End)
        }
        .width('100%')
        .padding({ top: 8, bottom: 8 })

        // 分隔线
        Divider().color('#eeeeee').margin({ top: 4, bottom: 8 })

        // 未来 5 天预报
        Row({ space: 4 }) {
          ForEach(this.daily, (d: WeatherDay, idx: number) => {
            Column({ space: 3 }) {
              Text(d.label).fontSize(11).fontColor('#888888')
              Text(d.icon).fontSize(20)
              Text(`${d.max}°`).fontSize(12).fontWeight(600)
              Text(`${d.min}°`).fontSize(11).fontColor('#999999')
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Center)
          }, (d: WeatherDay, idx: number) => `${d.label}_${idx}`)
        }
        .width('100%')
        .padding({ top: 2, bottom: 2 })
      }
    }
    .width('100%')
    .padding(14)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .margin({ left: 16, right: 16 })
  }

  build() {
    Column({ space: 10 }) {
      Text('入口页面').fontSize(22).fontWeight(700).margin({ top: 20 })

      // 天气卡片
      this.WeatherCard()

      List({ space: 10 }) {
        ForEach(this.list, (item: listItem) => {
          ListItem() {
            Row() {
              Column({ space: 10 }) {
                Text(item.title).fontSize(15).fontWeight(600)
                Text(item.description)
                  .fontSize(12)
                  .fontColor('#666')
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }.alignItems(HorizontalAlign.Start).layoutWeight(1)

              Column() {
                Text('›').fontSize(24).fontColor('#CCC')

              }.width(20).alignItems(HorizontalAlign.End)
            }
            .border({ width: 1, color: '#eeeeee' })
            .width('100%')
            .backgroundColor(Color.White)
            .borderRadius(8)
            .padding(16)
          }
        }, (item: listItem) => item.id.toString())
      }.width('100%').padding({ left: 16, right: 16 })

      Text('1246').onClick(() => {
        try {
          this.getUIContext().getRouter().pushUrl({
            url: 'pages/demo/index'
          }).catch(() => {
            // TODO: Implement error handling.
          })
        } catch (err) {
        }

      })
    }.width('100%').height('100%').backgroundColor('#f5f6fa')
  }
}
