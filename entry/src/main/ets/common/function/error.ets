import { BusinessError } from '@kit.BasicServicesKit'
import { hilog } from '@kit.PerformanceAnalysisKit';
import { promptAction } from '@kit.ArkUI';

// 错误处理
export function dealAllError(error: BusinessError): void {
    hilog.error(0x0000, 'testTag', `Failed to login, errorCode=${error.code}, errorMsg=${error.message}`);
    // 在应用登录涉及UI交互场景下，建议按照如下错误码指导提示用户
    if (error.code === ErrorCode.ERROR_CODE_LOGIN_OUT) {
        promptAction.showToast({ message: '请登录华为账号并重试' })
        // 用户未登录华为账号，请登录华为账号并重试或者尝试使用其他方式登录
    } else if (error.code === ErrorCode.ERROR_CODE_NETWORK_ERROR) {
        promptAction.showToast({ message: '请检查当前网络状态并重试' })
        // 网络异常，请检查当前网络状态并重试或者尝试使用其他方式登录
    } else if (error.code === ErrorCode.ERROR_CODE_INTERNAL_ERROR) {
        promptAction.showToast({ message: '登录失败' })
        // 登录失败，请尝试使用其他方式登录
    } else if (error.code === ErrorCode.ERROR_CODE_USER_CANCEL) {
        promptAction.showToast({ message: '用户取消授权' })
        // 用户取消授权
    } else if (error.code === ErrorCode.ERROR_CODE_SYSTEM_SERVICE) {
        promptAction.showToast({ message: '系统服务异常，请稍后重试' })
        // 系统服务异常，请稍后重试或者尝试使用其他方式登录
    } else if (error.code === ErrorCode.ERROR_CODE_REQUEST_REFUSE) {
        promptAction.showToast({ message: '重复请求' })
        // 重复请求，应用无需处理
    } else if (error.code === ErrorCode.ERROR_CODE_AGREEMENT_STATUS_NOT_ACCEPTED) {
        promptAction.showToast({ message: '用户未同意协议' })
        // 用户未同意协议
    } else {
        promptAction.showToast({ message: error.message })
        // 应用登录失败，请尝试使用其他方式登录
    }
}

enum ErrorCode {
    // 账号未登录
    ERROR_CODE_LOGIN_OUT = 1001502001,
    // 网络错误
    ERROR_CODE_NETWORK_ERROR = 1001502005,
    // 内部错误
    ERROR_CODE_INTERNAL_ERROR = 1001502009,
    // 用户取消授权
    ERROR_CODE_USER_CANCEL = 1001502012,
    // 系统服务异常
    ERROR_CODE_SYSTEM_SERVICE = 12300001,
    // 用户未同意用户协议
    ERROR_CODE_AGREEMENT_STATUS_NOT_ACCEPTED = 1005300001,
    // 重复请求
    ERROR_CODE_REQUEST_REFUSE = 1001500002
}