import type { IDataQueryPayload, IRow } from "@kanaries/graphic-walker/interfaces";
import { parser_dsl_with_meta } from "@kanaries/gw-dsl-parser";

const DEFAULT_LIMIT = 50_000;

const sendHTTPData = (sql: string, endpointPath: string) => {
    return new Promise((resolve, reject) => {
        fetch(`${endpointPath}&sql=${encodeURIComponent(sql)}`)
            .then((response) => response.json())
            .then((data) => {
                console.log("Processed data from R:", data);
                resolve(data);
            })
            .catch((error) => {
                console.error("Error:", error);
                reject(error);
            });
    });
};

export function getDataFromKernelBySql(fieldMetas: { key: string; type: string }[], endpointPath: string) {
    return async (payload: IDataQueryPayload) => {
        const sql = parser_dsl_with_meta(
            "gwalkr_mid_table",
            JSON.stringify({ ...payload, limit: payload.limit ?? DEFAULT_LIMIT }),
            JSON.stringify({ gwalkr_mid_table: fieldMetas })
        );
        const result = (await sendHTTPData(sql, endpointPath)) ?? [];
        return result as IRow[];
    };
}
