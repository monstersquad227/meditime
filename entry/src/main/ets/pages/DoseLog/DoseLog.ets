import { recordList } from "../../common/function/medicinePlanRecord";
import { recordListData } from "../../common/interface/medicinePlanRecord";
import { listIterm } from "./listIterm/listIterm";

@Component
export struct DoseLog {
    @State recordIterm: Array<recordListData> = [];
    @State isRefreshing: boolean = false;

    async aboutToAppear(): Promise<void> {
        this.recordIterm = await recordList()
    }

    build() {
        Column() {
            Refresh({
                refreshing: this.isRefreshing,
                promptText: '刷新中......'
            }) {
                if (this.recordIterm.length === 0) {
                    Column() {
                        Text('还有没打卡记录哦')
                    }
                    .width('100%')
                    .height('100%')
                    .justifyContent(FlexAlign.Center)
                    .align(Alignment.Center)
                } else {
                    List({ space: '20.00vp' }) {
                        ForEach(this.recordIterm, (item: recordListData) => {
                            ListItem() {
                                listIterm({
                                    date: item.actual_time,
                                    contents: item.contents
                                })
                            }
                            .border({ width: 1, color: '#cccccc', radius: 8 })
                        })
                    }
                }
            }
            .layoutWeight(1)
            .onStateChange(async () => {
                this.isRefreshing = true
                this.recordIterm = await recordList()
                setTimeout(() => {
                    this.isRefreshing = false
                }, 1000)
            })
            .refreshOffset(100)
        }
    }
}