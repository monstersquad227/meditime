import { http } from "@kit.NetworkKit";
import { baseURL } from "../constant/constant";
import { LoginResponse } from "../interface/medicineLogin";
import { promptAction } from "@kit.ArkUI";

export async function medicineLogin(authorizationCode: string) {
    let httpRequest = http.createHttp();
    let URL = baseURL + '/user/loginV2';
    AlertDialog.show({title: 'sss', message:authorizationCode })
    try {
        let resp = await httpRequest.request(URL, {
            method: http.RequestMethod.POST,
            connectTimeout: 3000,
            readTimeout: 3000,
            header: {
                'Content-Type': 'application/json',
            },
            extraData: {
                'authorization_code': authorizationCode
            },
            expectDataType: http.HttpDataType.OBJECT
        });

        let res: LoginResponse = JSON.parse(resp.result as string);
        if (res.code !== 0 || resp.responseCode !== 200){
            promptAction.showToast({ message: res.message });
            return null;
        }
        return res.result
    } catch (error) {
        AlertDialog.show({title: 'title', message: error})
        // promptAction.showToast({ message: error });
        return null;
    }
}