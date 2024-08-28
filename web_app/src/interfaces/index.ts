import type { IRow, IMutField } from "@kanaries/graphic-walker/interfaces";

export interface IAppPropsBase {
    id: string;
    version?: string;
    visSpec?: string;
    dataSource: IRow[];
    rawFields: IMutField[];
    toolbarExclude: string[];
    useKernel: boolean;
}

export interface IAppPropsWithKernel extends IAppPropsBase {
    useKernel: true;
    fieldMetas: { key: string; type: string }[];
    endpointPath: string;
}

export interface IAppPropsWithoutKernel extends IAppPropsBase {
    useKernel: false;
}

export type IAppProps = IAppPropsWithKernel | IAppPropsWithoutKernel;
