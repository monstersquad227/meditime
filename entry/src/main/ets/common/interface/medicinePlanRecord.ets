export interface recordListResponse {
    code: number,
    message: string,
    result: recordListData[]
}

export interface recordListData {
    actual_time: string,
    contents: recordListDataContents[]
}

export interface recordListDataContents {
    id: number,
    medicine_name: string,
    memo?: string,
    status: number,
    is_checked: number,
}

/*

{
    "code": 0,
    "message": "",
    "result": 1
}

*/
export interface recordPutResponse {
    code: number,
    message: string,
    result: number
}

export interface recordPutData {
    id: number,
    actual_time: string,
    is_checked: number,
    plan_id: number,
}