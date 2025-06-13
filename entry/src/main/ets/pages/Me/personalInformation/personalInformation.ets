import { router } from '@kit.ArkUI';

@Entry
struct personalInformation {
    @StorageProp('nickname') nickname: string = AppStorage.get('nickname') ?? '默认昵称';
    @StorageProp('phone') phone: string = AppStorage.get('phone') ?? '18888888888';
    @State inputText: string = '';
    @State type: string = '';

    build() {
        Column() {
            Image($r('app.media.right_grey'))
                .width('16.00vp')
                .height('16.00vp')
                .rotate({ angle: 180 })
                .onClick(() => {
                    router.back()
                })
                .alignSelf(ItemAlign.Start)
                .margin({ left: '20.00vp', top: '20.00vp' })

            Column() {
                Row() {
                    Text('头像').margin({ left: '10.00vp' })
                    Blank().layoutWeight(1)
                    Image($r('app.media.circle'))
                        .width('30.00vp')
                        .height('30.00vp')
                        .margin({ right: '10.00vp' })
                }
                .width('90%')
                .height('50.00vp')
                .border({ width: { bottom: '1.00vp' }, color: '#cccccc', radius: { topLeft: 8, topRight: 8 } })
                .backgroundColor('#f9f9f9')

                Row() {
                    Text('昵称').margin({ left: '10.00vp' })
                    Blank().layoutWeight(1)
                    Text(this.nickname).margin({ right: '10.00vp' })
                        .onClick(() => {
                            this.inputText = this.nickname
                            this.type = 'nickname'
                            // this.dialogController.open()
                        })
                }
                .width('90%')
                .height('50.00vp')
                .border({ width: { bottom: '1.00vp' }, color: '#cccccc' })
                .backgroundColor('#f9f9f9')

                Row() {
                    Text('手机号').margin({ left: '10.00vp' })
                    Blank().layoutWeight(1)
                    Text(this.phone).margin({ right: '10.00vp' })
                        .onClick(() => {
                            this.inputText = this.phone
                            this.type = 'phone'
                            // this.dialogController.open()
                        })
                }
                .width('90%')
                .height('50.00vp')
                .border({ width: '1.00vp', color: '#f9f9f9', radius: { bottomLeft: 8, bottomRight: 8 } })
                .backgroundColor('#f9f9f9')
            }
            .margin({ top: '20.00vp' })

            Blank().layoutWeight(1)

            Button($r('app.string.LogOut'))
                .width('90%')
                .height('50.00vp')
                .backgroundColor('rgba(255, 0, 0, 0.15)')// 半透明红色背景
                .fontColor('rgba(255, 0, 0, 0.9)')// 较深红色文字
                .onClick(async () => {
                    await Promise.all([
                        PersistentStorage.deleteProp('token'),
                        PersistentStorage.deleteProp('user_id'),
                        PersistentStorage.deleteProp('huawei_id'),
                        PersistentStorage.deleteProp('phone')
                    ])
                    router.replaceUrl({ url: 'pages/Login/Login' })
                })

        }.height('100%').width('100%')
    }
}