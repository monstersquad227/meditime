import { http } from "@kit.NetworkKit";
import { baseURL } from "../constant/constant";
import {
    CreateCourseData,
    CreateCourseResponse,
    DeleteCourseData,
    DeleteCourseResponse,
    ListCourseData,
    ListCourseResponse
} from "../interface/medicineCourse";
import { promptAction } from "@kit.ArkUI";
import { dealAllError } from "./error";

// 查询用药方案
export async function ListCourse(): Promise<ListCourseData[]> {
    let httpRequest = http.createHttp();
    let URL = baseURL + '/course';

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
        let res: ListCourseResponse = JSON.parse(resp.result as string);
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

export function translateMedicineTime(medicineTime: number): string {
    switch (medicineTime) {
        case 1:
            return '饭前用药';
        case 2:
            return '饭后用药';
        case 3:
            return '随餐用药';
        case 4:
            return '睡前用药';
        default:
            return '不限';
    }
}

export function parseJSON<T>(jsonStr: string): T {
    return JSON.parse(jsonStr) as T;
}

export function translateType(type: number): string {
    switch (type) {
        case 1:
            return '外服';
        default:
            return '内服';
    }
}

// 创建用药方案
export async function CreateCourse(data: CreateCourseData): Promise<void> {
    let httpRequest = http.createHttp();
    let URL = baseURL + '/course';

    try {
        await httpRequest.request(URL, {
            method: http.RequestMethod.POST,
            connectTimeout: 3000,
            readTimeout: 3000,
            header: {
                'Content-Type': 'application/json',
                'token': AppStorage.get('token')
            },
            extraData: data,
            expectDataType: http.HttpDataType.OBJECT
        }).then((res: http.HttpResponse) => {
            let result = res.result as CreateCourseResponse
            if (result.code !== 0) {
                promptAction.showToast({ message: result.message });
                return;
            } else {
                promptAction.showToast({ message: '添加成功' });
            }
        })
    } catch (error) {
        dealAllError(error)
        // promptAction.showToast({ message: 'Network error' });
        return;
    }
}

export async function DeleteCourse(data: DeleteCourseData): Promise<void> {
    let httpRequest = http.createHttp();
    let URL = baseURL + '/course';

    try {
        await httpRequest.request(URL, {
            method: http.RequestMethod.DELETE,
            connectTimeout: 3000,
            readTimeout: 3000,
            header: {
                'Content-Type': 'application/json',
                'token': AppStorage.get('token')
            },
            extraData: data,
            expectDataType: http.HttpDataType.OBJECT
        }).then((res: http.HttpResponse) => {
            let result = res.result as DeleteCourseResponse
            
            if (result.code !== 0) {
                promptAction.showToast({ message: result.message });
                return;
            } else {
                promptAction.showToast({ message: '结束成功' });
            }
        })
    } catch (err) {
        dealAllError(err)
    }
    ;
}