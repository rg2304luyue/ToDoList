/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { TaskItem } from '../viewmodel/DataModel';

@Component
export default struct ToDoItem {
  @Prop task: TaskItem;
  onToggle?: () => void;

  /**
   * 校验当前事项是否已逾期
   */
  isOverdue(): boolean {
    if (this.task.isComplete || !this.task.dueDate) return false;
    let today = new Date();
    let due = new Date(this.task.dueDate);
    today.setHours(0, 0, 0, 0);
    due.setHours(0, 0, 0, 0);
    return today.getTime() > due.getTime();
  }

  build() {
    Row() {
      // 左侧交互选择圆圈
      Image(this.task.isComplete ? $r('app.media.ic_ok') : $r('app.media.ic_default'))
        .objectFit(ImageFit.Contain)
        .width(26)
        .height(26)
        .margin({ right: 16 })

      // 中间文本多模态排版
      Column() {
        Text(this.task.content)
          .fontSize(17)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.task.isComplete ? '#A0A0A0' : '#2C2C2C')
          .decoration({ type: this.task.isComplete ? TextDecorationType.LineThrough : TextDecorationType.None })

        // 功能三：已完成事项标识确切时间
        if (this.task.isComplete && this.task.completionTime) {
          Text(`✓ 完成于: ${this.task.completionTime}`)
            .fontSize(12)
            .fontColor('#22C55E')
            .margin({ top: 6 })
        }

        // 未完成时显示截止时间
        if (!this.task.isComplete && this.task.dueDate) {
          Text(`⌛ 截止日期: ${this.task.dueDate}`)
            .fontSize(12)
            .fontColor(this.isOverdue() ? '#EF4444' : '#767676')
            .margin({ top: 6 })
        }
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      // 功能四：到期状态标签化提醒
      if (this.isOverdue()) {
        Text('已到期')
          .fontSize(11)
          .fontColor('#FFFFFF')
          .backgroundColor('#EF4444')
          .padding({ left: 6, right: 6, top: 3, bottom: 3 })
          .borderRadius(6)
          .fontWeight(FontWeight.Bold)
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(14)
    .shadow({ radius: 5, color: '#06000000', offsetX: 0, offsetY: 2 })
    .onClick(() => {
      if (this.onToggle) {
        this.onToggle();
      }
    })
  }
}