import { router } from '@kit.ArkUI';
import { webview } from '@kit.ArkWeb';

interface GeneratedTypeLiteralInterface_1 {
    url: string;
    title: string;
}

@Entry
struct WebPage {
    controller: webview.WebviewController = new webview.WebviewController();
    @State url: string = '';
    @State title: string = '';

    aboutToAppear() {
        const params = router.getParams() as GeneratedTypeLiteralInterface_1;
        this.url = params?.url ?? '';
        this.title = params?.title ?? '';
    }

    build() {
        Column() {
            Row() {
                Image($r('app.media.right_grey')).width('16.00vp').height('16.00vp').rotate({ angle: 180 })
                    .margin({
                        left: '20.00vp',
                        top: '20.00vp',
                        bottom: '20.00vp',
                        right: '20.00vp'
                    })
                Text(this.title)
            }
            .backgroundColor('#f9f9f9')
            .alignSelf(ItemAlign.Start)
            .width('100%')
            .height('40.00vp')
            .onClick(() => {
                router.back()
            })

            Web({ src: this.url, controller: this.controller })// ArkTS 内嵌网页组件
                .width('100%')
                .height('100%')
        }
    }
}