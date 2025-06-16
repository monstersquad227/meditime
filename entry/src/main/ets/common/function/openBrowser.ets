import { common, Want } from "@kit.AbilityKit";
import { BusinessError } from "@kit.BasicServicesKit";
import { dealAllError } from "./error";


export function openBrowser(context: common.UIAbilityContext, url: string) {
    let want: Want = {
        action: 'ohos.want.action.viewData', // 改为 viewData
        uri: url,
        entities: ['entity.system.browser'],
    };

    try {
        context.startAbility(want).then(() => {
            // 成功回调可省略
        }).catch((err: BusinessError) => {
            dealAllError(err)
            // promptAction.showToast({ message: '启动浏览器失败: ' + JSON.stringify(err) });
        });
    } catch (err) {
        dealAllError(err)
        // promptAction.showToast({ message: '异常: ' + JSON.stringify(err) });
    }
}