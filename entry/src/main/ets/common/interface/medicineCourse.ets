export interface ListCourseData {
    medicine_name: string
    medicine_image: string
    medicine_type: number
    medicine_timing?: number
    course_start_time: string
    frequency: number
}

export interface ListCourseResponse {
    code: number
    message: string
    result: ListCourseData[]
}

export interface CreateCourseResponse {
    code: number,
    message: string,
    result: number
}

export interface CreateCourseData {
    user_id: number; // 1
    medicine_name: string; // 厄贝沙坦氢氟噻嗪片
    medicine_image: string; // ''
    medicine_type: number; // 0 外用； 1 内用
    medicine_timing: number; // 0 不限; 1 饭前用药; 2 饭后用药; 3 随餐用药; 4 睡前用药;
    course_start_time: string; // 开始日期  2025-05-27 19:00:00
    course_start_times: string[];
    status: number; //方案状态 0 生效， 废弃； 创建时激活
    amount: number; // 用药数量
    type: string; // 剂量单位
    plan_time: string;
    frequency: number
}

export interface DeleteCourseData {
    user_id?: number,
    medicine_name: string
}

export interface DeleteCourseResponse {
    code: number,
    message: string,
    result: number
}