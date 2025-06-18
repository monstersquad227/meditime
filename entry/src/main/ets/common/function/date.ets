export function getDate(): string {
    let year = new Date().getFullYear()
    let month = new Date().getMonth() + 1;
    let day = new Date().getDate()
    return `${year}-${month.toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`;
}