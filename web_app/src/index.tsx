import React, { useMemo, useState } from "react";
import { createRoot } from "react-dom/client";
import { observer } from "mobx-react-lite";
import { IAppProps } from "./interfaces";
import { GraphicWalker } from "@kanaries/graphic-walker";
import type { IGlobalStore } from "@kanaries/graphic-walker/dist/store";
import type { IDataSetInfo, IVisSpec } from "@kanaries/graphic-walker/dist/interfaces";
import type { IStoInfo } from "@kanaries/graphic-walker/dist/utils/save";
import { getExportTool } from "./tools/exportTool";
import CodeExportModal from "./components/codeExportModal";
import "./index.css";

// eslint-disable-next-line @typescript-eslint/no-unused-vars
const App: React.FC<IAppProps> = observer((propsIn) => {
    const { dataSource, ...props } = propsIn;
    const storeRef = React.useRef<IGlobalStore>(null);
    const specList: IVisSpec[] = useMemo(() => {
        return props.visSpec ? (JSON.parse(props.visSpec) as IVisSpec[]) : [];
    }, []);
    const [exportOpen, setExportOpen] = useState(false);

    React.useEffect(() => {
        if (specList.length !== 0) {
            storeRef?.current?.vizStore?.importStoInfo({
                dataSources: [
                    {
                        id: "dataSource-0",
                        data: dataSource,
                    },
                ],
                datasets: [
                    {
                        id: "dataset-0",
                        name: "DataSet",
                        rawFields: props.rawFields,
                        dsId: "dataSource-0",
                    },
                ],
                specList,
            } as IStoInfo);
        } else {
            storeRef?.current?.commonStore?.updateTempSTDDS({
                name: "Dataset",
                rawFields: props.rawFields,
                dataSource: dataSource,
            } as IDataSetInfo);
            storeRef?.current?.commonStore?.commitTempDS();
        }
    }, [storeRef, dataSource, props.rawFields, props.visSpec, specList]);

    props.storeRef = storeRef;

    const exportTool = getExportTool(setExportOpen);

    const tools = [exportTool];

    const toolbarConfig = {
        exclude: ["export_code"],
        extra: tools,
    };
    return (
        <React.StrictMode>
            <div style={{ height: "100%", width: "100%", overflowY: "scroll" }}>
                <CodeExportModal open={exportOpen} setOpen={setExportOpen} globalStore={storeRef} />
                <GraphicWalker {...props} toolbar={toolbarConfig} />
            </div>
        </React.StrictMode>
    );
});

const GWalker = (props: IAppProps, id: string) => {
    const container = document.getElementById(id);
    if (container) {
        const root = createRoot(container);
        root.render(<App {...props} />);
    }
    // If you want to execute GWalker after the document has loaded, you can do it here.
    // But remember, you will need to provide the 'props' and 'id' parameters.
    // GWalker(someProps, someId);
    // });
};

export default GWalker;
