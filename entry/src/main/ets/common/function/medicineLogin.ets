import { http } from "@kit.NetworkKit";
import { baseURL } from "../constant/constant";
import { LoginRequestData, LoginResponse, LoginResponseData } from "../interface/medicineLogin";
import { promptAction } from "@kit.ArkUI";

// export async function medicineLogin(data: LoginRequestData): Promise<LoginResponseData | null> {
//     let httpRequest = http.createHttp();
//     let URL = baseURL + '/user/loginV2';
//
//     try {
//         let resp = await httpRequest.request(URL, {
//             method: http.RequestMethod.POST,
//             connectTimeout: 3000,
//             readTimeout: 3000,
//             header: {
//                 'Content-Type': 'application/json',
//             },
//             extraData: data,
//             expectDataType: http.HttpDataType.OBJECT,
//         });
//
//         let res: LoginResponse = JSON.parse(resp.result as string);
//         if (res.code !== 0 || resp.responseCode !== 200){
//             promptAction.showToast({ message: res.message });
//             return null;
//         }
//         return res.result
//     } catch (error) {
//         promptAction.showToast({ message: error });
//         return null;
//     }
// }

export async function medicineLogin(data: LoginRequestData): Promise<LoginResponseData | null> {
    let httpRequest = http.createHttp();
    let URL = baseURL + '/user/loginV2';

    try {
        let resp = await httpRequest.request(URL, {
            method: http.RequestMethod.POST,
            connectTimeout: 3000,
            readTimeout: 3000,
            header: {
                'Content-Type': 'application/json',
            },
            // ⚠️ extraData 仍然要是字符串形式
            extraData: JSON.stringify(data),
            expectDataType: http.HttpDataType.OBJECT, // ✅ 你希望的是直接返回对象
        });

        // ⚠️ 此时 resp.result 已经是对象，不要再 parse
        let res = resp.result as LoginResponse;

        if (res.code !== 0 || resp.responseCode !== 200) {
            promptAction.showToast({ message: res.message });
            return null;
        }

        return res.result;
    } catch (error) {
        promptAction.showToast({ message: JSON.stringify(error) });
        return null;
    }
}