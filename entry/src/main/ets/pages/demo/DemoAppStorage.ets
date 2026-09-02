/**
 * ============================================================
 * 主题⑧：AppStorage —— 应用级共享状态（跨组件、跨页面）
 * ============================================================
 * 场景：多个组件、多个页面要读写「同一份」数据（比如用户信息、购物车数量）。
 *       @State 只管组件内部；@Prop/@Link 只覆盖父子；
 *       AppStorage 是「全局仓库」——整个应用共用一份。
 *
 * 两个配套装饰器：
 *   @StorageLink('key')  双向：组件改了，仓库和其他用的人都变；仓库变，组件也变
 *   @StorageProp('key')  单向：只有仓库 → 组件，组件改了不影响仓库
 *
 * 常用 API：
 *   AppStorage.setOrCreate('key', 值)  创建或更新仓库里的值
 *   AppStorage.get('key')              读值（非组件里用）
 *
 * 本页用一个页面里两个组件 + AppStorage 演示「跨组件共享」。
 * 跨页面同理：另一个页面里写 @StorageLink('score') 也能拿到同一份数据。
 *
 * 相关补充：
 *   - LocalStorage：页面级仓库（一个页面内部共享，页面销毁数据也销毁）
 *   - PersistentStorage：持久化（App 关了重启还在，适合存登录态）
 * ============================================================
 */

@Entry
@Component
struct DemoAppStorage {
  // 页面初始化时，往全局仓库里塞一个初始值（如果还没有的话）
  // aboutToAppear 是组件的生命周期：创建后、build 前自动调用
  aboutToAppear(): void {
    if (AppStorage.get('score') === undefined) {
      AppStorage.setOrCreate('score', 0);
    }
  }

  build() {
    Scroll() {
      Column({ space: 16 }) {
        Text('AppStorage 全局共享（同一个 key = 同一份数据）')
          .fontSize(15)
          .fontWeight(700)

        Text('下面的 组件A 和 组件B 没有父子关系，')
          .fontSize(12)
          .fontColor('#888888')
        Text('但都绑定仓库里的同一个 score，所以会实时同步。')
          .fontSize(12)
          .fontColor('#888888')

        // 两个没有父子关系的兄弟组件，靠 AppStorage 同步
        CompA()
        CompB()

        Text('⚠ 还想了解：')
          .fontSize(12)
          .fontColor('#888888')
        Text('· @StorageProp 是单向（仓库→组件），组件改了不会写回仓库')
          .fontSize(12)
          .fontColor('#888888')
        Text('· LocalStorage 是页面级仓库；PersistentStorage 会持久化到磁盘')
          .fontSize(12)
          .fontColor('#888888')
      }
      .width('100%')
      .padding(16)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f6fa')
  }
}

/** 组件A：@StorageLink 双向绑定 score */
@Component
struct CompA {
  // @StorageLink('score')：双向，key 是 'score'
  @StorageLink('score') scoreA: number = 0;

  build() {
    Column({ space: 12 }) {
      Text('组件A（@StorageLink 双向）')
        .fontSize(13)
        .fontWeight(600)
      Text(`A 看到的 score = ${this.scoreA}`)
        .fontSize(24)
        .fontWeight(700)
        .fontColor('#4f6ef2')
      Button('A 加 1')
        .onClick(() => {
          this.scoreA = this.scoreA + 1; // 仓库和 B 都会同步
        })
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#eef4ff')
    .borderRadius(12)
  }
}

/** 组件B：@StorageProp 单向绑定 score（只读仓库） */
@Component
struct CompB {
  // @StorageProp('score')：单向，仓库变化 B 会更新，但 B 改了不影响仓库
  @StorageProp('score') scoreB: number = 0;

  build() {
    Column({ space: 12 }) {
      Text('组件B（@StorageProp 单向）')
        .fontSize(13)
        .fontWeight(600)
      Text(`B 看到的 score = ${this.scoreB}`)
        .fontSize(24)
        .fontWeight(700)
        .fontColor('#e63946')
      Button('B 加 1（不会写回仓库）')
        .backgroundColor('#e63946')
        .onClick(() => {
          this.scoreB = this.scoreB + 1; // 只影响 B 自己，A 和仓库不变
        })
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#fdeeee')
    .borderRadius(12)
  }
}
