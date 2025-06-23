export interface ListPlanData {
    plan_id: number,
    is_checked: number
    medicine_name: string,
    medicine_timing?: number,
    amount: number,
    type: string,
    plan_time: string,
    record_id: number
}

export interface ListPlanResponse {
    code: number,
    message: string,
    result: ListPlanData[]
}

export interface createPlanData {
    plan_id: number,
    medicine_name: string,
    actual_time: string,
    memo: string,
    status: number
}

export interface CreatePlanResponse {
    code: number,
    message: string,
    result: number
}