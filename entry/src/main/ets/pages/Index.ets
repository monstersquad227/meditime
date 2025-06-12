import router from '@ohos.router'

@Entry
@Component
struct Index {
    // @State message: string = 'Hello World';
    @StorageProp ('token') token: string | undefined = AppStorage.get('token')
    onPageShow(): void {
        if (this.token === undefined || this.token === '') {
            AlertDialog.show({message: this.token})
            router.pushUrl({ url: 'pages/Login/Login'})
        } else {
            AlertDialog.show({message: this.token})
            router.pushUrl({ url: 'pages/Dashboard/Dashboard'})
        }
    }

    build() {
        // RelativeContainer() {
        //     Text(this.message)
        //         .id('HelloWorld')
        //         .fontSize($r('app.float.page_text_font_size'))
        //         .fontWeight(FontWeight.Bold)
        //         .alignRules({
        //             center: { anchor: '__container__', align: VerticalAlign.Center },
        //             middle: { anchor: '__container__', align: HorizontalAlign.Center }
        //         })
        //         .onClick(() => {
        //             this.message = 'Welcome';
        //         })
        // }
        // .height('100%')
        // .width('100%')
    }
}