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

import DataModel, { TaskItem } from '../viewmodel/DataModel';
import CommonConstants from '../common/constant/CommonConstant';
import ToDoItem from '../view/ToDoItem';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct ToDoListPage {
  @State totalTasks: Array<TaskItem> = [];
  @State newTodoContent: string = '';
  @State selectDueDate: string = '';

  aboutToAppear() {
    this.totalTasks = DataModel.getData();
    // 默认将当前日期设为新待办的截止日期
    let date = new Date();
    this.selectDueDate = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;

    // 初始化排序与到期安全提醒
    this.sortTasks();
    this.checkDueReminders();
  }

  /**
   * 核心排序算法：完成的排序在前 (isComplete 为 true 优先)
   */
  sortTasks() {
    this.totalTasks.sort((a, b) => {
      if (a.isComplete && !b.isComplete) return -1;
      if (!a.isComplete && b.isComplete) return 1;
      return 0;
    });
  }

  /**
   * 自动检测到期提醒
   */
  checkDueReminders() {
    let todayStr = new Date().toISOString().slice(0, 10);
    let overdueCount = 0;
    this.totalTasks.forEach(task => {
      if (!task.isComplete && task.dueDate <= todayStr) {
        overdueCount++;
      }
    });
    if (overdueCount > 0) {
      promptAction.showToast({
        message: `🔔 到期提醒：您有 ${overdueCount} 项待办已到期或今天到期，请尽快处理！`,
        duration: 4000
      });
    }
  }

  /**
   * 获取当前格式化的时间 (YYYY-MM-DD HH:mm)
   */
  getFormattedTime(): string {
    let date = new Date();
    return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')} ${String(date.getHours()).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}`;
  }

  build() {
    Column() {
      // 顶栏美化
      Text('高级待办清单')
        .fontSize(26)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')
        .width('90%')
        .margin({ top: 24, bottom: 16 })
        .textAlign(TextAlign.Start)

      // 功能一：事项动态添加卡片区域
      Column({ space: 12 }) {
        Row() {
          TextInput({ text: this.newTodoContent, placeholder: '想做点什么呢...' })
            .placeholderColor('#999999')
            .backgroundColor('#F5F5F5')
            .layoutWeight(1)
            .height(44)
            .borderRadius(10)
            .onChange((val) => {
              this.newTodoContent = val;
            })

          Button('添加')
            .borderRadius(10)
            .backgroundColor('#007DFF')
            .height(44)
            .width(72)
            .margin({ left: 10 })
            .onClick(() => {
              if (this.newTodoContent.trim() === '') {
                promptAction.showToast({ message: '待办内容不能为空哦' });
                return;
              }
              // 构造新任务节点
              let newTask: TaskItem = {
                id: Date.now().toString(),
                content: this.newTodoContent,
                isComplete: false,
                completionTime: '',
                dueDate: this.selectDueDate
              };
              this.totalTasks.push(newTask);
              this.newTodoContent = '';
              this.sortTasks(); // 重新排序
              promptAction.showToast({ message: '创建成功 🎉' });
            })
        }
        .width('100%')

        // 截止日期快捷选择器
        Row() {
          Text(`📅 设置截止日期: `)
            .fontSize(14)
            .fontColor('#666666')
          Text(this.selectDueDate)
            .fontSize(14)
            .fontColor('#007DFF')
            .fontWeight(FontWeight.Medium)
          Blank()
          Button('选择日期', { type: ButtonType.Capsule })
            .fontSize(12)
            .backgroundColor('#E6F1FE')
            .fontColor('#007DFF')
            .height(28)
            .onClick(() => {
              DatePickerDialog.show({
                start: new Date('2020-01-01'),
                end: new Date('2030-12-31'),
                selected: new Date(this.selectDueDate),
                // 修复逻辑点：增加对 value 属性的非空校验，规避 ArkTSCheck 报错
                onAccept: (value: DatePickerResult) => {
                  if (value.year !== undefined && value.month !== undefined && value.day !== undefined) {
                    this.selectDueDate = `${value.year}-${String(value.month + 1).padStart(2, '0')}-${String(value.day).padStart(2, '0')}`;
                  }
                }
              })
            })
        }
        .width('100%')
      }
      .width('91.5%')
      .padding(14)
      .backgroundColor('#FFFFFF')
      .borderRadius(16)
      .margin({ bottom: 16 })
      .shadow({ radius: 8, color: '#0A000000', offsetX: 0, offsetY: 4 })

      // 功能二：满屏支持高弹性上下拉的列表组件
      List({ space: 12 }) {
        ForEach(this.totalTasks, (item: TaskItem) => {
          ListItem() {
            ToDoItem({
              task: item,
              onToggle: () => {
                // 切换完成状态
                item.isComplete = !item.isComplete;
                // 功能三：动态标识并记录点击完成的时间
                item.completionTime = item.isComplete ? this.getFormattedTime() : '';
                // 状态变更，重新激活首部排序
                this.sortTasks();
                // 深度浅拷贝驱动页面数据视图感知刷新
                this.totalTasks = [...this.totalTasks];
              }
            })
          }
        }, (item: TaskItem) => item.id + '_' + item.isComplete)
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: '4.2%', right: '4.2%' })
      .edgeEffect(EdgeEffect.Spring) // 高弹性满屏上下拉效果
      .scrollBar(BarState.Auto)
    }
    .width(CommonConstants.FULL_LENGTH)
    .height(CommonConstants.FULL_LENGTH)
    .backgroundColor('#F1F3F5')
    .padding({ top: AppStorage.get<number>('statusBarHeight') || 24, bottom: 12 })
  }
}