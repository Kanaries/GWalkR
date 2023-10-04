import React, { useEffect, useState } from "react";
import Modal from "../modal";
import { observer } from "mobx-react-lite";
import DefaultButton from "../button/default";
import PrimaryButton from "../button/primary";

import type { IGlobalStore } from "@kanaries/graphic-walker/dist/store";

interface ICodeExport {
    globalStore: React.MutableRefObject<IGlobalStore | null>;
    open: boolean;
    setOpen: (open: boolean) => void;
}

const downloadFile = (data: string) => {
    const fileName = "config";
    const json = data;
    const blob = new Blob([json], { type: "application/json" });
    const href = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.href = href;
    link.download = fileName + ".json";
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    URL.revokeObjectURL(href);
};

const CodeExport: React.FC<ICodeExport> = observer((props) => {
    const [code, setCode] = useState<string>("");

    useEffect(() => {
        if (props.open) {
            const res = props.globalStore.current?.vizStore.exportViewSpec();
            if (res) setCode(JSON.stringify(res));
        }
    }, [props.open]);

    return (
        <Modal
            show={props.open}
            onClose={() => {
                props.setOpen(false);
            }}
        >
            <div className="dark:text-white">
                <h1 className="mb-4 font-bold text-base">Config Export</h1>
                <div className="text-sm max-h-64 overflow-auto w-full">
                    <code className="font-mono text-xs whitespace-nowrap w-full">{code}</code>
                </div>
                <div className="mt-4 flex justify-start">
                    <DefaultButton
                        text="Cancel"
                        className="mr-2 px-6"
                        onClick={() => {
                            props.setOpen(false);
                        }}
                    />
                    <PrimaryButton
                        text="Download"
                        className="mr-2 px-6"
                        onClick={() => {
                            downloadFile(code);
                        }}
                    />{" "}
                </div>
                <div className="text-sm max-h-56 mt-4 text-left">
                    <div>Option 1: paste the config in your R code as a string and pass it to `visConfig` parameter.</div>
                    <div>Option 2: download the config file and pass the file path to `visConfigFile` parameter.</div>
                </div>
            </div>
        </Modal>
    );
});

export default CodeExport;
