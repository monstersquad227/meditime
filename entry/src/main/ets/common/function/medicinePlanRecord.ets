import { recordListData, recordListResponse, recordPutData, recordPutResponse } from "../interface/medicinePlanRecord";
import { http } from "@kit.NetworkKit";
import { baseURL } from "../constant/constant";
import { promptAction } from "@kit.ArkUI";

export async function recordList(): Promise<recordListData[]> {
    let httpRequest = http.createHttp();
    let URL = baseURL + '/record/' + AppStorage.get('user_id');

    try {
        let resp = await httpRequest.request(URL, {
            method: http.RequestMethod.GET,
            connectTimeout: 3000,
            readTimeout: 3000,
            header: {
                'Content-Type': 'application/json',
                'token': AppStorage.get('token')
            },
        });
        let res: recordListResponse = JSON.parse(resp.result as string);
        if (res.code !== 0) {
            promptAction.showToast({ message: res.message });
            return [];
        }
        return res.result;

    } catch (error) {
        promptAction.showToast({ message: 'Network error' });
        return [];
    }
}

export async function recordUpdate(data: recordPutData): Promise<number> {
    let httpRequest = http.createHttp();
    let URL = baseURL + '/record/' + AppStorage.get('user_id');

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
        let res: recordPutResponse = JSON.parse(resp.result as string)
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