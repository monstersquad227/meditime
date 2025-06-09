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