import {  UpdatePushTokenData, UpdatePushTokenResponse } from "../interface/medicineUser";
import { http } from "@kit.NetworkKit";
import { baseURL } from "../constant/constant";
import { promptAction } from "@kit.ArkUI";


export async function updatePushToken(data: UpdatePushTokenData): Promise<number> {
    let httpRequest = http.createHttp();
    let URL = baseURL + '/user';

    try {
        let resp = await httpRequest.request(URL, {
            method: http.RequestMethod.PUT,
            connectTimeout: 3000,
            readTimeout: 3000,
            header: {
                'Content-Type': 'application/json',
                'token': AppStorage.get('token')
            },
            extraData: data,
        });
        let res: UpdatePushTokenResponse = JSON.parse(resp.result as string)
        if (res.code !== 0) {
            promptAction.showToast({ message: res.message });
            return res.code;
        }
        return res.result;
    } catch (error) {
        promptAction.showToast({ message: 'catch error' });
        return 1;
    }
}