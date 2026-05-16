/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import CommonConstants from '../common/constant/CommonConstant';

/**
 * 待办事项数据接口定义
 */
export interface TaskItem {
  id: string;               // 唯一标识
  content: string;          // 待办内容
  isComplete: boolean;      // 是否完成
  completionTime: string;   // 完成时间
  dueDate: string;          // 截止日期 (YYYY-MM-DD)
}

/**
 * Saving and manipulating data displayed on the page.
 */
export class DataModel {
  // 默认初始数据
  public tasks: Array<TaskItem> = [
    { id: '1', content: '早起晨练', isComplete: false, completionTime: '', dueDate: '2026-05-16' },
    { id: '2', content: '准备早餐', isComplete: false, completionTime: '', dueDate: '2026-05-16' },
    { id: '3', content: '阅读名著', isComplete: false, completionTime: '', dueDate: '2026-05-18' },
    { id: '4', content: '学习ArkTS', isComplete: false, completionTime: '', dueDate: '2026-05-20' },
    { id: '5', content: '看剧放松', isComplete: false, completionTime: '', dueDate: '2026-05-15' }
  ];

  /**
   * Get the data.
   */
  getData(): Array<TaskItem> {
    return this.tasks;
  }
}

export default new DataModel();