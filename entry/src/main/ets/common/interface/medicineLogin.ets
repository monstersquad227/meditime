export interface LoginResponse {
    code: number,
    message: string,
    result: LoginResponseData
}

export interface LoginResponseData {
    token: string
    user: UserInfo
}

export interface UserInfo {
    id: number,
    nickname: string,
    image?: string,
    huawei_id?: string,
    phone_num: string,
    password: string,
    created_at: string,
    updated_at: string
}