import type { IGWProps } from '@kanaries/graphic-walker/dist/App'

export interface IAppProps extends IGWProps {
    id: string;
    version?: string;
    hashcode?: string;
    visSpec?: string;
    env?: string;
    needLoadDatas?: boolean;
    specType?: string;
}