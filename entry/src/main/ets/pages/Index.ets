@Entry
@Component
struct Index {
  build() {
    Column() {
      Text('pages').onClick(() => {
        this.getUIContext().getRouter().pushUrl({
          url: 'pages/practice/Index'
        }).catch((err: Error) => {
          console.error(`pushUrl failed, code is ${err.message}`)
        })
      })
    }
  }
}