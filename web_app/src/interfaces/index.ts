import type { IRow, IMutField } from '@kanaries/graphic-walker/interfaces'

export interface IAppProps {
    id: string;
    version?: string;
    hashcode?: string;
    visSpec?: string;
    env?: string;
    needLoadDatas?: boolean;
    specType?: string;
    dataSource: IRow[];
    rawFields: IMutField[];
}
