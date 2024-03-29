export interface AppVersionInfoEntity {
  lastVersion: string;
  lastCode: number;
  reminderBeginTime: number;
  auditStatus: number;
  promptUpdateInterval: number;
  updateType: number;
  historyVersions: HistoryVersionEntity[];
}
export interface HistoryVersionEntity {
  version: string;
  code: number;
  updateDescription: string;
}


