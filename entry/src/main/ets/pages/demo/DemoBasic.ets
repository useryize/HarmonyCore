/**
 * ============================================================
 * 主题①：基础组件怎么用
 * ============================================================
 * 鸿蒙 UI 的写法是「声明式」的：
 *   组件(参数) .属性(值) .属性(值) ... .事件(回调)
 *
 * 比如：Text('你好').fontSize(20).fontColor('#ff0000')
 *
 * 本页演示最常用的 4 个基础组件：
 *   Text       文本
 *   Image      图片
 *   Button     按钮
 *   TextInput  输入框
 * 以及它们的事件绑定（onClick / onChange）。
 *
 * 注意：这里输入框用了 @State 保存输入值，
 *       @State 的详细讲解见「主题③ @State 状态」。
 * ============================================================
 */

import { promptAction, router } from '@kit.ArkUI'; // promptAction 弹轻提示，router 做页面跳转

@Entry
@Component
struct DemoBasic {
  // @State 响应式状态：inputValue 变化时，界面上引用它的地方会自动刷新
  @State inputValue: string = '';

  build() {
    Scroll() { // 内容可能超出屏幕，用 Scroll 包住可以上下滚动
      Column({ space: 16 }) {
        // ---------- 1. Text 文本 ----------
        Text('一、Text 文本')
          .fontSize(14)
          .fontWeight(700)
        Text('这是一段默认样式的文本')
        Text('这是 24 号加粗红色文本')
          .fontSize(24)
          .fontWeight(700)      // 字重：加粗
          .fontColor('#e63946') // 字体颜色
        Text('这是多行文本，超过宽度会自动换行。用来演示 maxLines 和省略号的效果：这是一段比较长的文字。')
          .maxLines(2) // 最多显示 2 行
          .textOverflow({ overflow: TextOverflow.Ellipsis }) // 超出部分显示省略号
          .fontSize(14)

        // ---------- 2. Image 图片 ----------
        Text('二、Image 图片')
          .fontSize(14)
          .fontWeight(700)
        // $r('app.media.xxx') 表示引用 resources/base/media 目录下的资源
        Image($r('app.media.startIcon'))
          .width(100)          // 宽度
          .height(100)         // 高度
          .objectFit(ImageFit.Contain) // 图片适配方式：保持比例完整显示
          .borderRadius(16)    // 圆角
          .clip(true)          // 让圆角真正裁剪图片
          .backgroundColor('#f0f0f0')

        // ---------- 3. Button 按钮 ----------
        Text('三、Button 按钮')
          .fontSize(14)
          .fontWeight(700)
        // 第 1 个参数是按钮文字
        Button('默认风格按钮')
          .onClick(() => {
            // 事件回调：点击后弹出轻提示
            promptAction.showToast({ message: '你点击了默认按钮' });
          })
        // 用 {} 传子组件的方式可以自定义按钮内容
        Button() {
          Row({ space: 6 }) {
            Text('👍')
            Text('带图标的按钮')
          }
        }
        .backgroundColor('#4f6ef2')
        .fontColor(Color.White)
        .onClick(() => {
          promptAction.showToast({ message: '这是自定义内容按钮' });
        })

        // ---------- 4. TextInput 输入框 ----------
        Text('四、TextInput 输入框')
          .fontSize(14)
          .fontWeight(700)
        TextInput({ placeholder: '请输入内容…' }) // placeholder：提示文字
          .width('100%')
          .height(44)
          .backgroundColor('#ffffff')
          .borderRadius(8)
          .onChange((value: string) => {
            // onChange 事件：每次输入都会触发，value 是当前输入框内容
            this.inputValue = value; // 把输入值存进 @State
          })
        // 实时回显输入内容（@State 变化自动刷新）
        Text(`你输入的是：${this.inputValue}`)
          .fontSize(14)
          .fontColor('#4f6ef2')

        // ---------- 5. 回到首页按钮 ----------
        Button('返回导航首页')
          .backgroundColor('#999999')
          .onClick(() => {
            // router.back() 返回上一页
            router.back();
          })
      }
      .width('100%')
      .padding(16)
      .alignItems(HorizontalAlign.Start) // 子元素靠左对齐
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f6fa')
  }
}
