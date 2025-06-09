import { ListPlanData, ListPlanResponse } from "../interface/medicinePlan";
import { http } from "@kit.NetworkKit";
import { promptAction } from "@kit.ArkUI";
import { baseURL } from "../constant/constant";

export async function ListPlan(): Promise<ListPlanData[]> {
    let httpRequest = http.createHttp();
    let URL = baseURL + '/plan' + '/' + AppStorage.get('user_id');

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
        let res: ListPlanResponse = JSON.parse(resp.result as string);
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